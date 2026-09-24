# Phase 2 real-LAN discovery and presence gate

This gate requires a physical Android device and one desktop host at a time on the same multicast-capable LAN. An emulator, a single machine, or automated parser tests cannot establish cross-platform mDNS behavior. Do not mark a row complete until the observation and environment are recorded. Phase 2 proves discovery and presence; authenticated sessions and messages belong to later phases.

The service type is `_localmsg._tcp`, and the planned listener port is TCP `45873` ([protocol baseline](../protocol.md)). The TXT record carries version, device ID, capabilities, profile revision, and optionally a plaintext display-name hint. A discovered name or ID is unverified until the Phase 3 handshake. Rebuild and update both Android and desktop test apps before retesting this extension; earlier four-key parsers reject the added TXT key.

## Per-pair record

| Pair | Advertise, browse, resolve both ways | Duplicate/update/lost reconciliation | Wi-Fi reconnect and stale expiry | Diagnostics and firewall check |
| --- | --- | --- | --- | --- |
| Android ↔ Windows | [ ] User reports mutual detection within 10 s on fresh launch, one row each; environment/address details pending | [ ] | [ ] Entries disappear almost immediately on disconnect; reappear after reconnect: Android ~3 s, Windows ~1 s; stale-expiry fallback not exercised | [ ] |
| Android ↔ macOS | [ ] | [ ] | [ ] | [ ] |
| Android ↔ Linux | [ ] | [ ] | [ ] | [ ] |

### Android ↔ Windows observation — 2026-09-23 16:32 UTC

The user reports that each device detects the other. On 2026-09-23 at
16:35 UTC, the user reported reappearance after reconnect in approximately
3 seconds on Android and 1 second on Windows. At 16:36 UTC, the user
reported that peer entries disappear almost immediately on disconnect.
At 16:37 UTC, the user confirmed that on fresh launch each app shows exactly
one entry for the other within 10 seconds. These are user estimates, not
instrumented measurements. They demonstrate the observed loss/recovery path,
not the 15-second stale-expiry fallback. The Android model/API level,
router/LAN details, address family, profile-update behavior, stale-expiry
fallback, and firewall/blocked-network response have not yet been recorded.
The cells remain unchecked until those acceptance details are verified.

These observations came from the earlier four-key builds. They do not prove
the later optional-name TXT extension; update both installations and repeat
the name/rename/single-row check.

For each pair:

1. Record the Android model/API level, desktop OS version, app build, Wi-Fi access point/router, VLAN/guest-network status, interface names, and time. Put both peers on the same LAN; disable AP/client isolation for the test.
2. Launch both installations with distinct identities. Confirm each advertises and discovers the other within 10 seconds, resolves at least one usable address, and shows only one nearby row per advertised device ID. Record IPv4 and IPv6 candidates separately; preserve the interface scope on link-local IPv6 candidates.
3. Change a local display name to increment its profile revision. Nearby should show the new advertised name next to the same fingerprint, keep it marked Unverified, and remain a single row. Use a redacted DNS-SD TXT capture or automated test to confirm the new `profile` value propagated. Restart an advertiser, then stop it; confirm update/lost events and stale expiry converge to the correct state.
4. Disconnect and reconnect Android Wi-Fi, then repeat with the desktop network interface. Confirm discovery restarts, stale addresses disappear, and both sides find each other again.
5. Block multicast or the application in the host firewall once. Confirm the app reports a useful discovery error or empty-state hint rather than hanging, restore the rule, and confirm recovery. Record the original and restored firewall state.
6. Capture timestamps, redacted discovery events, service instance/type, TXT validation outcome, resolved address family/scope, and screenshots of the nearby and diagnostic states. Never capture private keys or message contents.

If a listener is active during the test, check TCP `45873` reachability separately from DNS-SD discovery. A discovered service with a blocked TCP port is a firewall/listener problem, while no service record is usually an mDNS, interface, or network-isolation problem. A successful TCP probe does not prove the Phase 3 secure handshake.

## Platform checks

### Android

Use a physical device. The app currently targets API 36: `INTERNET` provides the local network access used by sockets/NSD, `ACCESS_NETWORK_STATE` supports network-state checks, and `CHANGE_WIFI_MULTICAST_STATE` allows Bonsoir's Wi-Fi multicast lock. Do not request `ACCESS_LOCAL_NETWORK` for this target; re-evaluate when targeting API 37. Android documents the NSD mDNS behavior and multicast-lock differences by OS version ([NsdManager](https://developer.android.com/reference/android/net/nsd/NsdManager), [local-network permission](https://developer.android.com/privacy-and-security/local-network-permission)).

Android Diagnostics shows notification permission state and offers an
explicit, optional request. Denial does not block discovery. This permission
is for later incoming-message alerts, not the Phase 2 browse/advertise path.

### Windows

Check that the active network is trusted/Private and inspect Windows Defender Firewall inbound rules for the exact application executable, TCP `45873`, and local-subnet scope. If discovery itself is missing, inspect mDNS UDP `5353` traffic/rules and the network's multicast policy. Prefer a rule limited to the app executable and local subnet rather than disabling the firewall. Microsoft's [firewall rule guidance](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/rules) recommends narrow application, port, profile, and remote-address scope; [New-NetFirewallRule](https://learn.microsoft.com/en-us/powershell/module/netsecurity/new-netfirewallrule) provides those filters.

In an elevated PowerShell session, after confirming the actual executable path and test network profile, an inbound listener rule can be created with:

```powershell
$appExe = 'C:\path\to\local_messenger.exe'
New-NetFirewallRule -DisplayName 'Local Messenger LAN TCP' -Direction Inbound -Action Allow -Program $appExe -Protocol TCP -LocalPort 45873 -RemoteAddress LocalSubnet -Profile Private
```

This rule is only needed on a host that accepts inbound TCP connections; it does not by itself fix blocked mDNS. Remove the test rule when no longer needed with `Remove-NetFirewallRule -DisplayName 'Local Messenger LAN TCP'`.

### macOS

Launch the packaged app, allow the Local Network prompt, and check **System Settings → Privacy & Security → Local Network** if discovery is denied. The app declares `NSLocalNetworkUsageDescription` and `_localmsg._tcp` in `NSBonjourServices`; both Debug/Profile and Release sandbox entitlements allow incoming and outgoing network connections. Apple documents that Bonjour browse/register/resolve requires local-network access and that users can later change the decision in Settings ([local-network privacy](https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy), [sandbox network entitlement](https://developer.apple.com/documentation/BundleResources/Entitlements/com.apple.security.network.client)).

### Linux

Confirm that Avahi is installed and running before testing the app. On a systemd host, inspect `systemctl status avahi-daemon`; install/enable the distribution's Avahi package only if missing. With `avahi-utils` installed, `avahi-browse -rt _localmsg._tcp` should show and resolve the Android service; `+`/ `-` events show arrival/loss. Bonsoir requires a running Avahi daemon on Linux ([Bonsoir requirements](https://bonsoir.skyost.eu/docs/), [Avahi project](https://avahi.org/), [avahi-browse manual](https://manpages.debian.org/bookworm/avahi-utils/avahi-browse.1.en.html)).

If the daemon sees no service, check that the active LAN firewall zone/interface permits mDNS UDP `5353` for IPv4 and IPv6 multicast. If discovery succeeds but inbound connections fail, permit TCP `45873` from the LAN. With firewalld, inspect the active zone before enabling its `mdns` service and adding `45873/tcp`; with UFW, inspect `sudo ufw status verbose` and add narrowly scoped UDP/TCP rules for the LAN interface/subnet. Keep the host firewall enabled. See [firewalld service configuration](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/securing_networks/using-and-configuring-firewalld_securing-networks) and [Ubuntu UFW guidance](https://documentation.ubuntu.com/server/how-to/security/firewalls/index.html).

## Evidence and exit

Record one entry per checked cell with date/time, peer versions, observed result, redacted logs, and any open issue. Keep unchecked cells open if the matching physical host or LAN is unavailable. Attach the observations to the Phase 2 review before moving to Phase 3.
