# Local Messenger architecture

Status: Phase 2 implementation baseline; real-device discovery gate pending. Phase 0 feasibility evidence remains in
docs/research/phase-0-feasibility.md.

## Product boundary

Local Messenger is a peer-to-peer direct-messaging app for at most ten installations on the same multicast-capable LAN segment. There is no cloud service, relay, central database, account service, or push coordinator. Each installation is an independent identity, and each direct conversation is stored only by its two participants.

The initial platforms are Android, Windows, macOS, and Linux. iOS, routed discovery, guest-network isolation workarounds, groups, media, edits, read receipts, identity backup, and linked devices are outside v1.

Delivery is eventually consistent. A queued message transfers only while its sender and recipient overlap online. Android Online mode is best effort and may be stopped by the OS or device vendor.

## System shape

```text
presentation and state
        |
domain models, use cases, repository interfaces
        ^
        |
infrastructure adapters
  |- Drift/SQLite operation store
  |- OS-backed secure key storage
  |- DNS-SD discovery
  |- TCP transport and libsodium sessions
  |- anti-entropy synchronization
  `- Android availability service
```

Dependencies point toward the domain layer. Domain code does not depend on widgets, platform plugins, sockets, or generated database types. Presentation observes repositories and controllers rather than calling plugins directly.

## Stable application contracts

- `PeerDiscovery`: advertise this installation, browse and resolve peers, and expose presence changes.
- `IdentityRepository`: create/load the installation identity, update its display name, and expose the verified public profile.
- `SecurePeerTransport`: listen, connect, authenticate, exchange encrypted bounded frames, and expose connection state.
- `OperationStore`: validate and transactionally persist operations, query ranges/frontiers, rebuild projections, and record acknowledgements and retention floors.
- `SyncEngine`: compare frontiers, request missing ranges, apply batches, and acknowledge durable receipt.
- `AvailabilityController`: enable or disable listening and expose lifecycle and permission diagnostics.
- `ConversationRepository`: derive direct conversations, send text, stream visible messages, expose queued/delivered state, and clear local history.

Exact Dart signatures arrive with the phase that implements each contract. Their responsibilities above are fixed architectural seams.

## Identity and trust

Identity creation and profile updates write a versioned secure envelope before
writing reconstructable public metadata to Drift. On restart, a secure envelope
without a database row reconstructs that row. A database row without a secure
identity, or a public-key mismatch between them, fails closed rather than
rotating identity. Display-name changes increment the profile revision without
changing keys or the device ID.

On first launch an installation creates an Ed25519 key pair. Its stable `deviceId` is the SHA-256 digest of canonical public-key bytes. Private key material belongs in OS-backed secure storage; databases and logs contain only public identity data. Reinstalling or clearing app data creates a new identity.

Peers use trust on first use. The first authenticated public key is pinned. A later key mismatch is not silently accepted: communication is rejected or quarantined and the UI presents a prominent warning. Display names are mutable, non-unique presentation data. UI shows a short fingerprint wherever duplicate names or trust warnings could be ambiguous.

## Persistence and replication

Schema version 1 contains local profiles, pinned peers, conversations,
operations, feed heads, message projections, retention floors, and delivery
acknowledgements. IDs, keys, hashes, signatures, and canonical operation bytes
are BLOBs. Application time values are UTC epoch microseconds. Foreign keys and
range, order, and acknowledgement indexes are enabled when the database opens.

Drift over SQLite is the local persistence boundary. The source of truth is an immutable signed operation log, not the rendered message list. Materialized projections can be deleted and rebuilt from valid operations.

The schema will represent local public identity/profile metadata, pinned peers, deterministic two-party conversations, immutable operations, per-author contiguous feed heads, visible-message projections, local retention floors, and delivery acknowledgements. Database changes require numbered forward migrations and migration tests. Operation insertion, feed-head advancement, and projection updates commit atomically; acknowledgement is sent only after durable commit.

Clearing a conversation is local. It records a retention floor at the current frontier and removes the projection so acknowledged old history does not reappear during sync. It neither deletes the remote participant's data nor creates a replicated deletion.

DNS-SD/mDNS advertises `_localmsg._tcp`. TXT records contain protocol version, device ID, capability flags, profile revision, and an optional bounded display-name hint. Nearby shows that name beside the fingerprint with an explicit unverified state; absent or invalid hints fall back to "Nearby device." The name is visible in plaintext on the LAN and is never trusted. Authenticated session data supplies the verified profile.

The Bonsoir adapter advertises only after local identity is ready. It uses a
short service-instance label and keeps the complete advertised device ID in
TXT. Resolved IPv4/IPv6 candidates are validated before becoming unverified
presence. IPv6 link-local candidates require an interface scope. Presence is
deduplicated by advertised ID, bounded in memory, and expires after 15 seconds
without refresh. Native browse/advertise actions are recreated after detected
interface changes and on app resume. A short disconnect/reconnect while the
app remains active with exactly the same interface snapshot may still need
physical validation; the platform matrix records that gate.

Resolved peers communicate through bounded length-prefixed TCP frames. The handshake authenticates both identities, checks the advertised device ID, derives directional keys, and establishes an authenticated encrypted stream. See [protocol.md](protocol.md).

Each conversation has one hash-chained feed per author. Peers exchange exact contiguous frontiers, request missing ranges, and validate every operation before commit. Duplicate transfers are idempotent. A different hash at an existing `(conversation, author, sequence)` is a fork and quarantines that feed; last-write-wins is never used.

## Lifecycle and diagnostics

Foreground app processes advertise, listen, reconnect, and synchronize. A user-enabled Android foreground service later extends this under the `connectedDevice` service type with an ongoing notification and Stop action. It does not promise uninterrupted background delivery.

Diagnostics distinguish permission denied, discovery inactive, no peers
observed, and service stopped. Without a known expected peer, an empty scan
cannot prove whether no peer is online or the LAN blocks multicast; the UI
states that uncertainty and points to guest/client isolation and firewall
checks. The optional Android notification prompt is user-initiated in
Diagnostics; discovery does not depend on granting it. Logs are structured
and redact message bodies, private keys, session keys, and raw decrypted
frames.

## Invariants

- Only the two participant device IDs may author or receive an operation in a direct conversation.
- Network timestamps never establish authorship, ordering authority, or conflict winners.
- Outgoing messages are persisted before transmission.
- Received operations are acknowledged only after validation and durable commit.
- Frame and batch bounds are checked before allocation or database work.
- Untrusted network input cannot mutate projections without operation validation.
- No third peer stores or forwards a conversation in v1.
