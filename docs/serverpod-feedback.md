# Feedback on Serverpod 4 and App Studio

Notes from building [Santos NHF](https://santos.nhf.com.ar) with Serverpod 4, roughly in
order of how much time each one cost. Each item says what happened, how to reproduce it, and
what would have helped.

## 1. A newer CLI silently generates code the project's packages cannot compile

**What happened.** App Studio started using a Serverpod CLI 4.0.3 while the project was
pinned to 4.0.1. `serverpod start` regenerated `test/integration/test_tools/serverpod_test_tools.dart`
with an `ephemeralDatabase:` argument that `serverpod_test` 4.0.1 does not have. The test
suite stopped compiling locally, while CI, which installs the pinned CLI, kept passing.

**Reproduce.** Create a project pinned to 4.0.1, generate with the 4.0.3 CLI, then run
`dart analyze test/`.

**Suggestion.** The generator already knows which version it is and can read the
`serverpod` version in the pubspec. When the CLI is newer than the packages, it should refuse
to generate, or at least print a warning that cannot be missed. Today the CLI only suggests
upgrading, which reads as "harmless".

## 2. App Studio suggests `flutter upgrade` inside a pinned fvm version

**What happened.** After App Studio stopped bundling its own SDK, it picked up Flutter from
`~/fvm/default`, then version 3.35.7, and showed: *"Run `~/fvm/versions/3.35.7/bin/flutter
upgrade`"*. That command upgrades the folder in place. The folder would still be called
3.35.7 but would hold 3.47. Another project pins 3.35.7 in its `.fvmrc`, so it would have
silently moved to a different Flutter.

**Suggestion.** When the SDK path is under `~/fvm/versions/`, suggest
`fvm install <version> --setup` and `fvm global <version>` instead. It is also worth saying
in the dialog that App Studio no longer ships an SDK. The bundled `bin/` folder disappeared
without notice, and the project's notes still pointed to it.

## 3. The Serverpod MCP server says the server is not running when it is

**What happened.** After the toolchain change, the `serverpod mcp-server` process was still
running from the deleted toolchain folder. Every MCP tool answered *"The server is not
running with `serverpod start`"* while `serverpod start` was up. An agent following the
documented flow stops and asks the user to start a server that is already running.

**Suggestion.** Tell "no server" apart from "cannot reach it", and include the PID or port
that was checked. Restarting MCP servers when the toolchain changes would also help.

## 4. The `dart install`ed CLI is not on the PATH

The CLI that App Studio installs lives in `~/Library/Application Support/Dart/install/bin/`,
which is not on the shell's PATH. Running `serverpod generate` or `create-migration` from a
terminal fails with "command not found", and we could not find that folder in the docs. In CI we ended
up using `dart pub global activate serverpod_cli` instead, for the same reason.

## 5. Testing a stream that reacts to another call fails under the default rollback

A stream that queries the database as soon as another endpoint posts a message fails in
`withServerpod` with *"Concurrent database calls outside an already active transaction are
not supported when database rollbacks are enabled"*. The message is good. The streams and
testing docs could say up front that such tests need
`rollbackDatabase: RollbackDatabase.disabled`. Together with the new ephemeral database per
group, that works cleanly.

## 6. Future calls: the default scan interval is coarse for short timers

The default `futureCall.scanInterval` is 5 seconds, so a call scheduled 20 seconds out can
run up to 5 seconds late. We fixed it with `scanInterval: 1000`, after which our calls
landed within a second. One line in the scheduling docs about precision would save the
detour.

## 7. `serverpod_auth_idp_flutter` 4.0.3: two strings cannot be translated

- The email login form builds its `PasswordField` without passing
  `EmailSignInTexts.passwordLabel`, so it always says "Password". The registration form does
  use it.
- The resend button has `"Didn't receive? Send a new code"` as a constant, with no text in
  `EmailSignInTexts`.

Our app is fully in Spanish, and these are the only two English strings left.

## 8. Moving off Serverpod Cloud

- **The CORS failure leaves no trace.** A browser upload to the Cloud bucket with a signed
  URL is blocked by CORS, and nothing shows up in the server logs, because the request never
  reaches the server. We switched to uploading through an endpoint. A note in the file
  uploads docs would help.
- **Users must reset their passwords.** The auth peppers cannot be exported, so after moving
  the data every user had to reset their password. It is the right security default, but it
  should be stated where migrating off Cloud is documented, before anyone starts.

## What worked very well

- Streams combined with `session.messages`: the live, multi-user game, server and app,
  came together in a day.
- Idempotent future calls that survive restarts, with a typed generated API.
- `withServerpod` against a real embedded PostgreSQL. With 74 integration tests, we never had
  to mock the database.
