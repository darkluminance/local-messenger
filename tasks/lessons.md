# Lessons

Record durable workflow and implementation lessons here after user corrections or discovered mistakes.

- When proposing a manual acceptance check, first verify that the UI exposes the claimed outcome. The initial Phase 2 UI showed only a fingerprint, so its rename test could not visibly prove name propagation. The user subsequently chose to show a clearly unverified DNS-SD name hint; future checks must still distinguish visible name updates from authenticated identity and use TXT/event evidence for the profile revision.
