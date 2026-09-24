BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "litany_run" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "lives" bigint NOT NULL DEFAULT 3,
    "score" bigint NOT NULL DEFAULT 0,
    "streak" bigint NOT NULL DEFAULT 0,
    "bestStreak" bigint NOT NULL DEFAULT 0,
    "answered" bigint NOT NULL DEFAULT 0,
    "correct" bigint NOT NULL DEFAULT 0,
    "questionId" bigint,
    "chosenIndex" bigint,
    "askedQuestionIds" json,
    "finished" boolean NOT NULL DEFAULT false,
    "wasRecord" boolean NOT NULL DEFAULT false,
    "startedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "litany_run_user_idx" ON "litany_run" USING btree ("authUserId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "player_profile" ADD COLUMN "litanyBest" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20260924003200252', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924003200252', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
