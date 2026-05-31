# Runbook: Investigate a Potentially Compromised Account

**Goal:** Contain and triage a suspected account compromise.
**Est. time:** 15–30 min · **Requires:** Security/Exchange/User Admin

## Steps

1. **Contain first** — disable sign-in (`Update-MgUser -AccountEnabled:$false`) and revoke sessions (`Revoke-MgUserSignInSession`). Reset the password.
2. **Check forwarding & rules** — run `Get-MailboxForwardingReport.ps1`. Attackers commonly add external forwarding or inbox rules to hide replies. Note (do not yet delete) anything suspicious for evidence.
3. **Review sign-in activity** — examine Entra sign-in logs for unfamiliar locations, IPs, and "impossible travel". Check `Get-EntraInactiveUsers.ps1` context for baseline.
4. **Review MFA methods** — run `Get-EntraMFAStatus.ps1`; look for attacker-registered methods (new phone/authenticator). Remove unrecognised methods.
5. **Check app consent / OAuth grants** — look for risky third-party app consents granted by the user.
6. **Check mailbox activity** — recent large downloads, deleted items, new delegates.
7. **Remediate** — remove malicious rules/forwarding/MFA methods, revoke risky app grants, force re-registration of MFA.
8. **Restore access** — re-enable only after remediation and a fresh strong credential + MFA re-enrolment.
9. **Document** — timeline, indicators, actions taken; report per your incident process.

## Safety checklist
- [ ] Contained BEFORE investigating
- [ ] Evidence captured before deletion
- [ ] All attacker persistence (rules, forwarding, MFA, app grants) reviewed
- [ ] Access restored only post-remediation

> Source basis: learn.microsoft.com/graph/api/user-revokesigninsession · Microsoft incident-response guidance
