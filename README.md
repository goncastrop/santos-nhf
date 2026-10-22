# Santos NHF

**A collectible card game about the saints, built for the audience of a live Catholic show.**
Live at **[santos.nhf.com.ar](https://santos.nhf.com.ar)** · Flutter + Serverpod 4.0.4

*No Hacemos Fotocopias* ("We don't make photocopies") is an Argentine Catholic streaming show.
Every episode has a segment called *El santo del día*, "the saint of the day": the hosts tell
the life of one saint and rate them on six scores, like a football trading card. The audience
wanted the cards. This app is where they collect them, learn who each saint was, and play.

The interface is in Spanish, because the audience is.

## Who it is for, and what it does

The user is someone who watches the show and wants to keep going after it ends.

- **Collect.** Five cards on sign-up and one new card a day. On a saint's feast day, that
  saint is the one you get. The six scores stay hidden until the card is yours.
- **Learn.** Each saint has a biography, a prayer, a reading list, a timeline of when they
  lived and a world map of where they were born and died. All of it is public, no account
  needed.
- **Play.** A daily question with a streak. *La Letanía*, a solo run of questions with three
  lives. Duels against the machine or a friend: you pick a category, compare cards and answer
  a question about your saint.
- **Play live, during the show.** The host launches a Kahoot-style trivia about the saint of
  the day from the admin panel. Everyone with the app open gets a banner and a countdown.
  Answers score 1000 points down to 500, faster is more. The best scores, plus a raffle
  among the rest who scored, win the saint's card.

## What Serverpod does here

Serverpod is the whole backend. There is no other service, and none of it is mocked.

| Feature | Where |
|---|---|
| **Endpoints and the generated client.** 20 endpoints; the Flutter app talks to them only through the generated client. | `saints_nhf_server/lib/src/**/*_endpoint.dart` |
| **Authentication.** Sign in with Google, or by email with verification codes sent through Brevo SMTP. JWT sessions. An `admin` scope guards the admin endpoints. A Google sign-in links to the existing email account with the same verified address, so players keep their album. Players can delete their account from the app. | `lib/server.dart`, `src/auth/`, `src/account/`, `src/email/` |
| **ORM and migrations.** 16 tables, with row locks where races matter: two taps must not grant two starter packs. | `src/**/*.spy.yaml`, `migrations/` |
| **File storage.** Saint illustrations are uploaded through an endpoint. The server turns each one into a WebP of at most 1200 px, so the illustrator uploads his originals: a 6.5 MB PNG is stored as 144 KB. They are served with immutable cache headers. | `src/admin/admin_saint_endpoint.dart`, `src/admin/illustration_optimizer.dart` |
| **Streams.** The live trivia sends every viewer a fresh view on each change. Friend duels update the board and the turn counter live. | `src/live/live_endpoint.dart`, `src/duel/duel_endpoint.dart` |
| **Server events.** Moves and answers post signals through `session.messages`. One shared snapshot per change, so a hundred viewers cost one round of queries. | `src/live/live_service.dart`, `src/duel/duel_events.dart` |
| **Future calls.** They open each trivia question when its countdown ends and close it when time is up, and they survive a restart. | `src/live/live_future_call.dart` |
| **Web server.** It serves the compiled Flutter web app and its runtime config. | `lib/server.dart` |
| **Testing.** 82 integration tests with `withServerpod` against a real embedded PostgreSQL, including the streams. | `saints_nhf_server/test/integration/` |

The live trivia is the part that would be hardest without Serverpod. It is a stream that
pushes state to every open app, a server-side clock that grades each answer by the
millisecond, and scheduled jobs that move the game along on their own. Every step is
idempotent, so the host's button and the scheduler never move the same step twice.

## Architecture

```
Flutter web app ──generated client──▶ Serverpod server ──▶ PostgreSQL
        ▲                                                │
        └──────────── WebSocket streams ◀── session.messages + future calls
```

In production it runs on one cloud server with Docker Compose: Caddy for TLS, the Serverpod
server, and PostgreSQL 16. Every push to `main` that passes the tests deploys through GitHub
Actions. The image is tagged with the commit, so rolling back means redeploying an older one.
See `deploy/README.md`.

## Try it

1. Open [santos.nhf.com.ar](https://santos.nhf.com.ar) and browse the saints, the timeline
   and the map. No account needed.
2. Sign in with Google, or create an account with your email. You get five cards and can
   claim one more each day.
3. Go to *Jugar* to play the daily question, *La Letanía*, or a duel against *El Sacristán*,
   the machine.
4. The live trivia happens during the show: the host launches it from the admin panel.

## Run it locally

You need Flutter 3.47 or newer and the Serverpod CLI 4.0.4. Serverpod starts and manages its
own PostgreSQL in development.

```bash
cd saints_nhf_server
serverpod start        # server, database, migrations and the Flutter app
dart test              # the integration tests
```

In development the catalog is seeded with example saints.

## How it was built

It was built with Serverpod's App Studio and Claude Code, working as a coding agent. The repo
keeps the agent's working notes: `AGENTS.md` explains the code, and `ROADMAP.md` holds the
product decisions and what is still pending.
