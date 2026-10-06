BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "live_answer" (
    "id" bigserial PRIMARY KEY,
    "gameId" bigint NOT NULL,
    "questionIndex" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "chosenIndex" bigint NOT NULL,
    "correct" boolean NOT NULL,
    "points" bigint NOT NULL,
    "elapsedMs" bigint NOT NULL,
    "answeredAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "live_answer_unique_idx" ON "live_answer" USING btree ("gameId", "questionIndex", "authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "live_game" (
    "id" bigserial PRIMARY KEY,
    "saintId" bigint NOT NULL,
    "questionIds" json NOT NULL,
    "phase" text NOT NULL DEFAULT 'countdown'::text,
    "currentIndex" bigint NOT NULL DEFAULT 0,
    "countdownTo" timestamp without time zone,
    "openedAt" timestamp without time zone,
    "closesAt" timestamp without time zone,
    "questionSeconds" bigint NOT NULL DEFAULT 20,
    "fastPrizes" bigint NOT NULL,
    "rafflePrizes" bigint NOT NULL,
    "results" json,
    "createdBy" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "live_game_phase_idx" ON "live_game" USING btree ("phase");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "live_answer"
    ADD CONSTRAINT "live_answer_fk_0"
    FOREIGN KEY("gameId")
    REFERENCES "live_game"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "live_game"
    ADD CONSTRAINT "live_game_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20261006214820112-live-trivia', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261006214820112-live-trivia', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
