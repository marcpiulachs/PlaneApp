# Contributing

## Code style
- Follow analysis_options.yaml lints.
- Keep BLoCs focused; prefer pure event/state logic over widget-side business logic.
- Small, composable widgets; avoid sprawling build methods.

## Branch and commits
- Prefer feature branches; meaningful commit messages.
- Keep changes scoped (e.g., per feature/bugfix).

## Documentation
- Update docs/ when adding new flows, clients, or BLoCs.
- Document new events/states in their BLoC files.

## Testing
- Add/extend tests for changed BLoCs and repositories.
- Include mock-based integration tests when touching connection/OTA paths.

## Review checklist
- Are errors surfaced to UI? Are retries/backoff sane?
- Are assets and dependencies declared in pubspec.yaml?
- Are resources disposed (sockets/streams) appropriately?
