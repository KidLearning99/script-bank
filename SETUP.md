# Setup — publish to GitHub & enable the auto-update agent

These steps push the `script-bank/` folder to your **kidlearning** GitHub account, turn on
GitHub Pages, and wire up the daily agent. Run the commands from inside the `script-bank/` folder.

## 1. Create the repo on GitHub

Create a new **public** repository named `script-bank` under the `kidlearning` account:
<https://github.com/new> → Owner: `kidlearning`, Repository name: `script-bank`, Public, **do not** add a README. Create.

## 2. Push the files

```bash
cd "script-bank"
git init -b main
git add -A
git commit -m "Initial commit: Enterprise IT Script Bank + daily auto-update agent"
git remote add origin https://github.com/kidlearning/script-bank.git
git push -u origin main
```

If you use SSH instead, swap the remote for `git@github.com:kidlearning/script-bank.git`.

## 3. Enable GitHub Pages (makes the site available online)

The repo ships with an auto-deploy workflow (`.github/workflows/deploy-pages.yml`).
**Recommended (one setting, then it's automatic):**

In the repo: **Settings → Pages → Source: GitHub Actions → Save.**

That's the only click. On every push to `main`, the workflow publishes the site.
Check progress under the **Actions** tab; when the "Deploy to GitHub Pages" job is green,
the site is live.

_Alternative (no workflow):_ Settings → Pages → Source: **Deploy from a branch** →
Branch `main` / `(root)` → Save.

Either way the site lives at:

```
https://kidlearning.github.io/script-bank/
```

> Seeing a **404 "There isn't a GitHub Pages site here"**? It means publishing hasn't
> completed: confirm the repo exists and is **public**, that Pages Source is set above,
> and wait ~1–2 min for the first deploy. The repo must be public (or you need GitHub Pro).

## 4. (Optional) Let the agent regenerate scripts, not just flag them

The daily workflow runs automatically at 06:00 UTC. By default it runs **report-only** —
it checks every script's source and writes findings to `agent/last_run.md`.

To let it **regenerate** outdated scripts, it uses **OpenRouter free models**
(`minimax/minimax-m2.5:free`, falling back to `moonshotai/kimi-k2.6:free`).

1. Get an API key from <https://openrouter.ai/keys>.
2. In the repo: **Settings → Secrets and variables → Actions → New repository secret**
   - Name: `OPENROUTER_API_KEY`
   - Value: your key

### Keeping the key private (even in a public repo)

Storing it as a **GitHub Actions secret** (step 2 above) is the correct way — it is the
mechanism GitHub provides exactly for this. The key is encrypted at rest, **never shown in
the repository, the published Pages site, or the workflow logs** (GitHub auto-masks it), and
contributors cannot read it. The agent reads it only at runtime via `${{ secrets.OPENROUTER_API_KEY }}`.

**Never** put the key in any committed file (`.py`, `.yml`, `.md`, etc.) — anything committed
to a public repo is world-readable. The agent is built to read it *only* from the
`OPENROUTER_API_KEY` environment variable, so there is nothing to hardcode.

> ⚠️ The key you shared in chat should be rotated. Delete it at
>