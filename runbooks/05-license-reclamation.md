# Runbook: License Reclamation (Cost Optimization)

**Goal:** Recover licenses from inactive accounts safely.
**Est. time:** 20–30 min · **Requires:** License + User Administrator

## Steps

1. **Identify candidates** — run `Get-EntraInactiveUsers.ps1 -DaysInactive 90 -ExportCsv inactive.csv`.
2. **Validate** — exclude service accounts, shared mailboxes, on-leave staff, and break-glass accounts. Confirm with managers/HR.
3. **Stage, don't delete** — for genuinely unused accounts, disable sign-in first and monitor for a grace period before touching licenses.
4. **Mailbox first** — if the account has a mailbox, convert to shared (under 50 GB) so it no longer needs a license, or apply retention.
5. **Remove license** — `Set-MgUserLicense` removing the SKU; reclaim the seat.
6. **Verify savings** — re-check `Get-MgSubscribedSku` consumed vs available seats.
7. **Document** — record which accounts were reclaimed and when.

## Safety checklist
- [ ] Service / break-glass / shared accounts excluded
- [ ] Disabled + grace period before license removal
- [ ] Mailbox preserved (shared/retention) before delicensing

> Source basis: learn.microsoft.com/graph/api/resources/signinactivity · /microsoft-365/admin
