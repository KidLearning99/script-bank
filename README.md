# Enterprise IT Script Bank ⚡

A large, curated, **source-cited and read-only** library of PowerShell, Microsoft Graph and Bash
scripts across seven enterprise IT domains — published as a searchable website with an in-page
code viewer, and kept honest by a daily source-checking agent.

🌐 **Live:** https://kidlearning99.github.io/script-bank/

## Highlights
- **~100 scripts** across IT troubleshooting, Entra ID, Intune, Active Directory, Windows Server, Exchange Online and Linux.
- **All read-only** — reporting/diagnostic/audit scripts only (no Set/Remove/New/Disable operations).
- **Readable** — click any script to view it syntax-highlighted with one-click copy; no raw-text wrangling.
- **Every script cites a Microsoft Learn source** in its header.
- **5 step-by-step runbooks** for common procedures (onboarding, offboarding, compromise triage, Intune enrolment, license reclamation).

## Structure
```
index.html                     # the searchable site (code viewer + domain tabs)
scripts/manifest.json          # drives the site
scripts/01..07-*/              # the script library, by domain
runbooks/                      # step-by-step guides
agent/update_scripts.py        # daily source-check / regenerate agent
.github/workflows/             # deploy-pages.yml + update-scripts.yml
```

## The daily agent
Checks each script's cited source URL, detects broken or changed documentation, and (if an
`OPENROUTER_API_KEY` repo secret is set) regenerates affected scripts with free OpenRouter models.
Without the key it runs report-only, writing findings to `agent/last_run.md`. See `SETUP.md`.

> Safety: scripts follow least-privilege Graph scopes and never embed credentials. Because the
> entire library is read-only, scripts can be reviewed and run without risk of unintended changes.
