# 0001 — Memory relief and process safety

## Context

MemoryGuard may pause a process group during memory pressure. Process control and sampling must remain safe while builds and child processes are running.

## Decision

- Protect the controller's mutable paused-group and watchdog collections with one lock. Send signals using copied group IDs outside that lock.
- Drain a sampler child's output while it is alive. Waiting for termination first could deadlock if `ps` fills the pipe buffer.
- When relief is necessary, pause the newest eligible build. The older build is more likely to finish soon and release memory.

## Consequences

The controller avoids unsynchronized collection access and does not hold its lock while sending signals. Sampling keeps consuming output until the child exits. Relief can delay a newer build while allowing an older one to complete.
