#!/usr/bin/env python3
"""
Enterprise IT Script Bank - daily auto-update agent.

On every run:
  1. Reads scripts/manifest.json.
  2. For each script, fetches its cited source URL and checks it still resolves (HTTP 200).
  3. Hashes the source page and compares to the last-seen hash (agent/source_state.json)
     to detect that the upstream documentation has CHANGED since the last run.
  4. A script is flagged for regeneration if its source is BROKEN or has CHANGED.
  5. If OPENROUTER_API_KEY is set, flagged scripts are regenerated via OpenRouter using
     FREE models only (agent/system_prompt.md as system prompt, live source as grounding),
     then written back. Without the key it runs report-only.
  6. Writes a run report to agent/last_run.md and refreshes manifest "generated" date.

Runs unattended from GitHub Actions. Exit 0 = clean, 1 = changes made, 2 = error.
Standard library only - no third-party packages required.
"""
from __future__ import annotations
import json, os, sys, hashlib, datetime, urllib.request, urllib.error, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
MANIFEST = ROOT / "scripts" / "manifest.json"
STATE = ROOT / "agent" / "source_state.json"
PROMPT = ROOT / "agent" / "system_prompt.md"
REPORT = ROOT / "agent" / "last_run.md"

# Regeneration uses OpenRouter (https://openrouter.ai), FREE models only.
# Tried in order; first one that responds wins. Override with BANK_MODELS (comma-separated).
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
DEFAULT_MODELS = ["minimax/minimax-m2.5:free", "moonshotai/kimi-k2.6:free"]
MODELS = [m.strip() for m in os.environ.get("BANK_MODELS", ",".join(DEFAULT_MODELS)).split(",") if m.strip()]
UA = {"User-Agent": "ScriptBank-UpdateAgent/1.0 (+github actions)"}


def log(msg):
    print("[" + datetime.datetime.utcnow().isoformat() + "Z] " + msg, flush=True)


def fetch(url, timeout=25):
    """Return (ok, status, body_text). Adds https:// if scheme missing."""
    if not url.startswith("http"):
        url = "https://" + url
    try:
        req = urllib.request.Request(url, headers=UA)
        with urllib.request.urlopen(req, timeout=timeout) as r:
            body = r.read(400000).decode("utf-8", "ignore")
            return True, r.status, body
    except urllib.error.HTTPError as e:
        return False, e.code, ""
    except Exception as e:
        log("  fetch error for " + url + ": " + str(e))
        return False, 0, ""


def page_hash(body):
    return hashlib.sha256(body.encode("utf-8", "ignore")).hexdigest()[:16]


def _openrouter_call(model, system, user):
    """Single OpenRouter chat completion. Returns assistant text ('' on failure)."""
    key = os.environ.get("OPENROUTER_API_KEY", "")
    payload = json.dumps({
        "model": model,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user},
        ],
        "max_tokens": 4096,
    }).encode("utf-8")
    headers = {
        "Authorization": "Bearer " + key,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/KidLearning99/script-bank",
        "X-Title": "Enterprise IT Script Bank",
    }
    headers.update(UA)
    try:
        req = urllib.request.Request(OPENROUTER_URL, data=payload, headers=headers)
        with urllib.request.urlopen(req, timeout=120) as r:
            data = json.loads(r.read().decode("utf-8", "ignore"))
        return data["choices"][0]["message"]["content"].strip()
    except Exception as e:
        log("  OpenRouter call failed on " + model + ": " + str(e))
        return ""


def regenerate(script_path, source_url, source_body):
    """Regenerate a script from its live source via OpenRouter free models."""
    if not os.environ.get("OPENROUTER_API_KEY"):
        log("  OPENROUTER_API_KEY not set; skipping regeneration (report-only).")
        return False

    system = PROMPT.read_text(encoding="utf-8")
    current = script_path.read_text(encoding="utf-8")
    excerpt = source_body[:12000]
    user = (
        "The cited source for the following script has changed or broken.\n"
        "Source URL: " + source_url + "\n\n"
        "=== CURRENT SCRIPT (" + script_path.name + ") ===\n" + current + "\n\n"
        "=== LIVE SOURCE PAGE EXCERPT ===\n" + excerpt + "\n\n"
        "Regenerate the COMPLETE script so it is correct against the current source, "
        "preserving its filename, parameters and behaviour where still valid. Keep all "
        "mandatory features (comment-based help, error handling, logging, WhatIf where "
        "destructive, no hardcoded secrets, source citation). Output ONLY the raw script "
        "with no markdown fences and no commentary."
    )
    text = ""
    for model in MODELS:
        log("  regenerating via " + model)
        text = _openrouter_call(model, system, user)
        if text:
            break
    if not text:
        log("  all free models failed; keeping original.")
        return False
    if text.startswith("```"):
        text = text.split("\n", 1)[1].rsplit("```", 1)[0].strip()
    if len(text) < 100:
        log("  regeneration returned too little content; keeping original.")
        return False
    script_path.write_text(text + "\n", encoding="utf-8")
    log("  regenerated " + script_path.name + " (" + str(len(text)) + " chars)")
    return True


def main():
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    state = json.loads(STATE.read_text(encoding="utf-8")) if STATE.exists() else {}
    changes, broken, regenerated = [], [], []
    cache = {}

    for s in manifest["scripts"]:
        name, url = s["name"], s["source"]
        log("Checking " + name + " -> " + url)
        if url in cache:
            ok, status, body = cache[url]
        else:
            ok, status, body = fetch(url); cache[url] = (ok, status, body)
        if not ok:
            broken.append((name, status))
            flag = True
            log("  BROKEN source (status " + str(status) + ")")
        else:
            h = page_hash(body)
            prev = state.get(url)
            flag = prev is not None and prev != h
            state[url] = h
            log("  source CHANGED since last run" if flag else "  source OK / unchanged")
            if flag:
                changes.append(name)
        if flag and regenerate(ROOT / s["path"], url, body):
            regenerated.append(name)

    today = datetime.date.today().isoformat()
    manifest["generated"] = today
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    STATE.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")

    def names(x):
        return (" (" + ", ".join(x) + ")") if x else ""
    lines = [
        "# Auto-update run - " + today, "",
        "- Scripts checked: **" + str(len(manifest["scripts"])) + "**",
        "- Broken sources: **" + str(len(broken)) + "**" + names([n for n, _ in broken]),
        "- Changed sources: **" + str(len(changes)) + "**" + names(changes),
        "- Regenerated scripts: **" + str(len(regenerated)) + "**" + names(regenerated),
        "",
        "_Regeneration runs only when OPENROUTER_API_KEY is configured (free models: "
        + ", ".join(MODELS) + "); otherwise this is a report-only run that flags drift._",
    ]
    REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    log("Run complete. " + " | ".join(lines[2:6]))
    return 1 if (changes or broken or regenerated) else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as e:
        log("FATAL: " + str(e))
        sys.exit(2)
