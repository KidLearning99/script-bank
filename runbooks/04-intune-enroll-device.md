# Runbook: Enroll a Windows Device in Intune (Autopilot)

**Goal:** Get a device managed and compliant.
**Est. time:** varies (provisioning) · **Requires:** Intune Administrator

## Steps

1. **Confirm prerequisites** — Intune licensing, MDM auto-enrolment scope set, and (for Autopilot) the device hardware hash registered.
2. **Register the device** — import the hardware hash (`Get-WindowsAutopilotInfo`) and assign an Autopilot deployment profile.
3. **Assign profiles** — ensure compliance policy, configuration profiles, and required apps are targeted to the device's group.
4. **Enroll** — out-of-box experience (OOBE) for new devices, or Settings → Accounts → Access work or school for existing ones.
5. **Verify compliance** — after sync, run `Get-IntuneNonCompliantDevices.ps1`; the device should not appear, or its issues should be visible.
6. **Verify apps** — run `Get-IntuneAppInstallStatus.ps1` to confirm required apps installed.
7. **Hand off** — confirm the user can sign in and access resources gated by compliance.

## Safety checklist
- [ ] Licensing + MDM scope confirmed
- [ ] Compliance & config profiles assigned before enrolment
- [ ] Post-enrolment compliance verified

> Source basis: learn.microsoft.com/mem/autopilot · /graph/api/intune-devices-manageddevice-list
