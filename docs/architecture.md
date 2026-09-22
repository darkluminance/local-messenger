# Local Messenger architecture

Status: Phase 0 baseline. This records the intended v1 architecture; later phases must update it when implementation decisions change.

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

On first launch an installation creates an Ed25519 key pair. Its stable `deviceId` is the SHA-256 digest of canonical public-key bytes. Private key material belongs in OS-backed secure storage; databases and logs contain only public identity data. Reinstalling or clearing app data creates a new identity.

Peers use trust on first use. The first authenticated public key is pinned. A later key mismatch is not silently accepted: communication is rejected or quarantined and the UI presents a prominent warning. Display names are mutable, non-unique presentation data. UI shows a short fingerprint wherever duplicate names or trust warnings could be ambiguous.

## Persistence and replication

Drift over SQLite is the local persistence boundary. The source of truth is an immutable signed operation log, not the rendered message list. Materialized projections can be deleted and rebuilt from valid operations.

The schema will represent local public identity/profile metadata, pinned peers, deterministic two-party conversations, immutable operations, per-author contiguous feed heads, visible-message projections, local retention floors, and delivery acknowledgements. Database changes require numbered forward migrations and migration tests. Operation insertion, feed-head advancement, and projection updates commit atomically; acknowledgement is sent only after durable commit.

Clearing a conversation is local. It records a retention floor at the current frontier and removes the projection so acknowledged old history does not reappear during sync. It neither deletes the remote participant's data nor creates a replicated deletion.

DNS-SD/mDNS advertises `_localmsg._tcp`. TXT records contain protocol version, device ID, capability flags, and profile revision only. A discovered display name is never trusted; authenticated session data supplies the verified profile.

Resolved peers communicate through bounded length-prefixed TCP frames. The handshake authenticates both identities, checks the advertised device ID, derives directional keys, and establishes an authenticated encrypted stream. See [protocol.md](protocol.md).

Each conversation has one hash-chained feed per author. Peers exchange exact contiguous frontiers, request missing ranges, and validate every operation before commit. Duplicate transfers are idempotent. A different hash at an existing `(conversation, author, sequence)` is a fork and quarantines that feed; last-write-wins is never used.

## Lifecycle and diagnostics

Foreground app processes advertise, listen, reconnect, and synchronize. A user-enabled Android foreground service later extends this under the `connectedDevice` service type with an ongoing notification and Stop action. It does not promise uninterrupted background delivery.

Diagnostics distinguish permission denied, discovery inactive, no peers observed, service stopped, and peer-to-peer traffic apparently blocked. Logs are structured and redact message bodies, private keys, session keys, and raw decrypted frames.

## Invariants

- Only the two participant device IDs may author or receive an operation in a direct conversation.
- Network timestamps never establish authorship, ordering authority, or conflict winners.
- Outgoing messages are persisted before transmission.
- Received operations are acknowledged only after validation and durable commit.
- Frame and batch bounds are checked before allocation or database work.
- Untrusted network input cannot mutate projections without operation validation.
- No third peer stores or forwards a conversation in v1.
