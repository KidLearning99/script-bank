# Script Bank Worker (free, keeps your API key private)

This tiny Cloudflare Worker is the **secure backend** for the site. It holds your OpenRouter
key server-side so it is **never** exposed in the public site, and it powers script uploads.

## Why
GitHub Pages is static — any key placed in the page is world-readable. The Worker solves this:
the browser calls the Worker, the Worker adds the key and forwards to OpenRouter. The key lives
only as an encrypted Worker secret.

## Deploy (about 5 minutes, free tier)

1. Install the CLI and log in:
   ```bash
   npm install -g wrangler
   wrangler login
   ```
2. From this `worker/` folder, set the secrets (these are encrypted, never in the repo):
   ```bash
   wrangler secret put OPENROUTER_API_KEY     # your free OpenRouter key
   wrangler secret put UPLOAD_PASSCODE        # any phrase; needed to upload scripts
   wrangler secret put GITHUB_TOKEN           # fine-grained PAT, Contents: Read+Write on KidLearning99/script-bank
   ```
   (Skip the last two if you only want chat and no uploads.)
3. Deploy:
   ```bash
   wrangler deploy
   ```
   Wrangler prints a URL like `https://script-bank-proxy.<your-subdomain>.workers.dev`.
4. On the site, open **Settings** (gear icon), paste that Worker URL, and Save. The site will
   route chat through the Worker (no browser key needed) and enable the **Upload** button.

## Endpoints
- `POST /chat`   – `{ messages: [...] }` → `{ reply, model }` (free models only)
- `POST /upload` – header `X-Upload-Passcode`, body `{ domain, name, type, synopsis, description, source, content }`
- `GET  /health` – `{ ok: true }`

## Notes
- `wrangler.toml` is safe to commit (no secrets). The `[vars]` block is public config only.
- The upload endpoint rejects scripts containing destructive operations, keeping the bank read-only.
- Cost: Cloudflare Workers free tier allows 100k requests/day — far beyond typical use.
