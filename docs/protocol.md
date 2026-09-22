# Local Messenger protocol outline

Status: Phase 0 design baseline. Wire compatibility is not implemented until Phase 3; changes to this document before then are not protocol commitments.

## Discovery and addressing

Peers advertise `_localmsg._tcp` on the local multicast domain. The default port is `45873`, with a test-only override. TXT keys are limited to protocol version (`v`), device ID (`id`), capabilities (`caps`), and profile revision (`profile`). Display names from DNS-SD are never trusted.

Resolved IP addresses are connection candidates. Implementations must support IPv4 and IPv6, preserve IPv6 scope identifiers, deduplicate by authenticated device ID, and never depend on `.local` hostname resolution.

## Framing and limits

TCP carries an unsigned four-byte big-endian payload length followed by that many bytes. A frame larger than 64 KiB is rejected before allocation. Text is valid UTF-8 and at most 8 KiB. Handshakes, batches, concurrent connections, and request rates have explicit bounds before Phase 3 exits.

The framed payload is canonical CBOR. Map keys, integer encodings, and byte strings follow one documented canonical profile so signatures and hashes have exactly one byte representation. Encrypted sessions carry a monotonically ordered authenticated stream; plaintext application frames are not accepted after the handshake.

## Authenticated session

The handshake exchanges protocol versions, fresh challenges, Ed25519 public keys, corresponding Curve25519 keys, profile data, and signed transcripts. Each side verifies that `deviceId` equals SHA-256 of the canonical Ed25519 public key. Client/server key-exchange roles are selected by sorted device IDs, directional session keys are derived with libsodium, and traffic is protected with authenticated secret streams.

The first valid identity is pinned. A key change for an existing device ID fails closed and produces a visible warning. Version mismatch, invalid transcript signature, advertised-ID mismatch, timeout, replay, and malformed input terminate the session without changing durable state.

## Frame kinds

- `hello`: authenticated identity, profile, version, and capability negotiation.
- `syncSummary`: exact per-author contiguous sequence frontiers and local retention floors.
- `rangeRequest`: bounded missing contiguous ranges.
- `operationBatch`: bounded immutable signed operations.
- `ack`: highest durably committed contiguous sequence per author.
- `ping` / `pong`: liveness without application state changes.
- `error`: bounded structured failure code with no sensitive payload.

Unknown optional capabilities are ignored; unknown required protocol versions fail negotiation.

## Operation validation

An operation ID is SHA-256 of canonical unsigned CBOR. Each operation includes the protocol version, deterministic conversation ID, author and recipient device IDs, per-author sequence, previous-operation hash, presentation timestamp, UTF-8 text, and Ed25519 signature.

Before commit, a recipient validates bounds, canonical encoding, participants, conversation ID, operation hash, signature, sequence continuity, and previous hash. Insert, frontier advancement, and projection update are one transaction. An acknowledgement is sent only after that transaction commits. A duplicate hash is idempotent; a different hash at an existing author/sequence is a quarantined feed fork.
