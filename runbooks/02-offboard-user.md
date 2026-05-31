# Runbook: Securely Offboard a User

**Goal:** Revoke access and preserve data without deleting prematurely.
**Est. time:** 10–20 min · **Requires:** User Administrator (+ Exchange Admin for mailbox)

## Steps

1. **Verify authorization** — confirm the request via HR/manager and the ticket. Note legal-hold/retention requirements before any change.
2. **Block sign-in immediately** — `Update-MgUser -AccountEnabled:$false`. This is reversible and stops access fast.
3. **Revoke active sessions / tokens** — `Revoke-MgUserSignInSession` so existing tokens stop working.
4. **Reset password** to a random value (prevents re-use while the account is retained).
5. **Remove from groups / app assignments** as policy dictates; capture the membership first (run `Get-ADGroupMembershipReport` / `Get-MgUserMemberOf`) for the record.
6. **Mailbox handling** — convert to a shared mailbox (`Set-Mailbox -Type Shared`) or apply litigation hold; set an auto-reply; delegate access to the manager if approved.
7. **Reassign / forward** — set mailbox delegation rather than external forwarding; reassign OneDrive/SharePoint ownership.
8. **Reclaim license** only after mailbox/data steps are complete.
9. **Verify** — run `Get-EntraInactiveUsers.ps1` and `Get-MailboxForwardingReport.ps1` to confirm no lingering forwarding/access.

## Safety checklist
- [ ] Disable + revoke sessions BEFORE removing data
- [ ] Retention/legal hold confirmed
- [ ] Membership captured before removal
- [ ] License reclaimed only after data preserved

> Source basis: learn.microsoft.com/graph/api/user-update · /powershell/module/exchange/set-mailbox
