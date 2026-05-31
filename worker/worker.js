/**
 * Enterprise IT Script Bank — Cloudflare Worker proxy.
 *
 * Endpoints (all JSON, CORS-enabled for your Pages origin):
 *   POST /chat    -> proxies to OpenRouter using the SERVER-SIDE key (free models).
 *                    The browser never sees OPENROUTER_API_KEY.
 *   POST /upload  -> passcode-protected. Commits a new script file to the repo
 *                    and appends it to scripts/manifest.json via the GitHub API,
 *                    which triggers the Pages redeploy.
 *   GET  /health  -> { ok: true }
 *
 * Configure with `wrangler secret put` (see worker/README.md):
 *   OPENROUTER_API_KEY, GITHUB_TOKEN, UPLOAD_PASSCODE
 * And vars in wrangler.toml: REPO, ALLOW_ORIGIN, BANK_MODELS
 */
const FREE_MODELS_FALLBACK = ["minimax/minimax-m2.5:free", "moonshotai/kimi-k2.6:free"];

function cors(env) {
  return {
    "Access-Control-Allow-Origin": env.ALLOW_ORIGIN || "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, X-Upload-Passcode",
    "Access-Control-Max-Age": "86400",
  };
}
function json(data, status, env) {
  return new Response(JSON.stringify(data), {
    status: status || 200,
    headers: { "Content-Type": "application/json", ...cors(env) },
  });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (request.method === "OPTIONS") return new Response(null, { headers: cors(env) });
    if (url.pathname === "/health") return json({ ok: true }, 200, env);

    if (url.pathname === "/chat" && request.method === "POST") {
      return handleChat(request, env);
    }
    if (url.pathname === "/upload" && request.method === "POST") {
      return handleUpload(request, env);
    }
    return json({ error: "Not found" }, 404, env);
  },
};

async function handleChat(request, env) {
  if (!env.OPENROUTER_API_KEY) return json({ error: "Server key not configured" }, 500, env);
  let body;
  try { body = await request.json(); } catch { return json({ error: "Bad JSON" }, 400, env); }
  const messages = body.messages || [];
  const models = (env.BANK_MODELS ? env.BANK_MODELS.split(",") : FREE_MODELS_FALLBACK).map(m => m.trim());
  let lastErr = "";
  for (const model of models) {
    try {
      const r = await fetch("https://openrouter.ai/api/v1/chat/completions", {
        method: "POST",
        headers: {
          "Authorization": "Bearer " + env.OPENROUTER_API_KEY,
          "Content-Type": "application/json",
          "HTTP-Referer": env.ALLOW_ORIGIN || "https://kidlearning99.github.io",
          "X-Title": "Enterprise IT Script Bank",
        },
        body: JSON.stringify({ model, messages, max_tokens: 1500 }),
      });
      if (!r.ok) { lastErr = "HTTP " + r.status + " on " + model; continue; }
      const d = await r.json();
      const text = d.choices && d.choices[0] && d.choices[0].message && d.choices[0].message.content;
      if (text) return json({ reply: text, model }, 200, env);
    } catch (e) { lastErr = String(e); }
  }
  return json({ error: lastErr || "All free models failed" }, 502, env);
}

async function handleUpload(request, env) {
  const pass = request.headers.get("X-Upload-Passcode") || "";
  if (!env.UPLOAD_PASSCODE || pass !== env.UPLOAD_PASSCODE) return json({ error: "Unauthorized" }, 401, env);
  if (!env.GITHUB_TOKEN || !env.REPO) return json({ error: "Upload not configured" }, 500, env);
  let b;
  try { b = await request.json(); } catch { return json({ error: "Bad JSON" }, 400, env); }
  const { domain, name, type, synopsis, description, source, content } = b;
  if (!domain || !name || !content) return json({ error: "domain, name and content are required" }, 400, env);
  // basic safety: block obvious destructive PowerShell in "read-only" bank
  if (/\b(Remove-|Set-Mailbox|Disable-AdAccount|Disable-MgUser|rm\s+-rf|Format-Volume)\b/i.test(content)) {
    return json({ error: "Rejected: content contains destructive operations (this bank is read-only)." }, 422, env);
  }
  const safeName = name.replace(/[^A-Za-z0-9._-]/g, "_");
  const path = `scripts/${domain}/${safeName}`;
  const api = `https://api.github.com/repos/${env.REPO}/contents/`;
  const gh = (p, init) => fetch(api + p, {
    ...init,
    headers: { "Authorization": "Bearer " + env.GITHUB_TOKEN, "User-Agent": "script-bank-worker",
      "Accept": "application/vnd.github+json", ...(init && init.headers) },
  });

  // 1) commit the script file
  const fileRes = await gh(encodeURI(path), {
    method: "PUT",
    body: JSON.stringify({ message: `feat: add script ${safeName} (via upload)`,
      content: b64(content) }),
  });
  if (!fileRes.ok && fileRes.status !== 201 && fileRes.status !== 200) {
    return json({ error: "Commit failed: " + (await fileRes.text()).slice(0, 200) }, 502, env);
  }

  // 2) read + update manifest.json
  const mRes = await gh("scripts/manifest.json");
  if (!mRes.ok) return json({ error: "Could not read manifest" }, 502, env);
  const mMeta = await mRes.json();
  const manifest = JSON.parse(atob(mMeta.content.replace(/\n/g, "")));
  const icons = { "01-IT-Support-Troubleshooting": "🛠", "02-Entra-ID-Management": "🔐",
    "03-Intune-DeviceManagement": "📱", "04-ActiveDirectory": "🗂",
    "05-WindowsServer": "🖥", "06-ExchangeOnline": "📧", "07-Linux-Servers": "🐧" };
  const labels = { "01-IT-Support-Troubleshooting": "General IT Troubleshooting", "02-Entra-ID-Management": "Entra ID (Azure AD)",
    "03-Intune-DeviceManagement": "Intune & Device Mgmt", "04-ActiveDirectory": "Active Directory",
    "05-WindowsServer": "Windows Server", "06-ExchangeOnline": "Exchange Online", "07-Linux-Servers": "Linux Server Mgmt" };
  manifest.scripts.push({ name: safeName, domain: labels[domain] || domain, icon: icons[domain] || "📄",
    path, type: type || (safeName.endsWith(".sh") ? "Bash" : "PowerShell"), tier: "COMMUNITY", readonly: true,
    synopsis: synopsis || "Community-submitted script.", description: description || synopsis || "",
    permissions: "See script header", modules: "See script header", example: `.\\${safeName}`,
    returns: "See script header", source: source || "community-submitted" });
  manifest.generated = new Date().toISOString().slice(0, 10);
  const mPut = await gh("scripts/manifest.json", {
    method: "PUT",
    body: JSON.stringify({ message: `chore: register ${safeName} in manifest`,
      content: b64(JSON.stringify(manifest, null, 2) + "\n"), sha: mMeta.sha }),
  });
  if (!mPut.ok) return json({ error: "Manifest update failed: " + (await mPut.text()).slice(0, 200) }, 502, env);
  return json({ ok: true, path, message: "Uploaded. The site will redeploy in ~1 minute." }, 200, env);
}

function b64(str) {
  // UTF-8 safe base64 for Workers
  const bytes = new TextEncoder().encode(str);
  let bin = ""; bytes.forEach(b => bin += String.fromCharCode(b));
  return btoa(bin);
}
