# Runbook: Onboard a New User (Microsoft 365 / Entra ID)

**Goal:** Create a fully provisioned, secure user account.
**Est. time:** 10–15 min · **Requires:** User Administrator + License Administrator

## Steps

1. **Confirm inputs** — full name, UPN/email, department, manager, job title, required groups, and license SKU. Confirm the target environment (cloud-only vs hybrid). For hybrid, create the user on-prem AD first and let sync replicate.
2. **Connect** with least privilege:
   `Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Organization.Read.All"`
3. **Create the account** with `New-MgUser` (force password change at first sign-in, strong random initial password from a secret store — never hardcoded).
4. **Assign license** with `Set-MgUserLicense`, verifying available seats first with `Get-MgSubscribedSku`.
5. **Add to groups** (security + distribution) using `New-MgGroupMember`. Prefer group-based licensing/access over per-user where possible.
6. **Register MFA / Conditional Access** — confirm the user is in scope of your MFA CA policy. Send first-sign-in MFA setup instructions.
7. **Verify** — run `Get-EntraMFAStatus.ps1` after the user enrols, and confirm group membership and license with `Get-MgUserLicenseDetail`.
8. **Hand off** — deliver credentials via a secure channel (not plain email); record the ticket.

## Safety checklist
- [ ] No hardcoded password — used a generated secret
- [ ] Least-privilege scopes only
- [ ] License seat availability confirmed before assignment
- [ ] User in scope of MFA / Conditional Access

> Source basis: learn.microsoft.com/graph/api/user-post-users · /graph/api/user-assignlicense
