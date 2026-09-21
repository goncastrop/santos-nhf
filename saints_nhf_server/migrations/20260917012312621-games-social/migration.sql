BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duel" (
    "id" bigserial PRIMARY KEY,
    "challengerId" uuid NOT NULL,
    "opponentId" uuid NOT NULL,
    "isVsMachine" boolean NOT NULL DEFAULT false,
    "status" text NOT NULL DEFAULT 'pendingDeck'::text,
    "roundNumber" bigint NOT NULL DEFAULT 1,
    "attackerId" uuid,
    "turnOf" uuid,
    "challengerScore" bigint NOT NULL DEFAULT 0,
    "opponentScore" bigint NOT NULL DEFAULT 0,
    "winnerId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "duel_challenger_idx" ON "duel" USING btree ("challengerId");
CREATE INDEX "duel_opponent_idx" ON "duel" USING btree ("opponentId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duel_deck" (
    "id" bigserial PRIMARY KEY,
    "duelId" bigint NOT NULL,
    "playerId" uuid NOT NULL,
    "saintIds" json NOT NULL,
    "usedSaintIds" json NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "duel_deck_unique_idx" ON "duel_deck" USING btree ("duelId", "playerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duel_round" (
    "id" bigserial PRIMARY KEY,
    "duelId" bigint NOT NULL,
    "roundNumber" bigint NOT NULL,
    "category" text NOT NULL,
    "attackerId" uuid NOT NULL,
    "defenderId" uuid NOT NULL,
    "attackerSaintId" bigint NOT NULL,
    "attackerQuestionId" bigint,
    "attackerAnswerIndex" bigint,
    "attackerCorrect" boolean,
    "defenderSaintId" bigint,
    "defenderQuestionId" bigint,
    "defenderAnswerIndex" bigint,
    "defenderCorrect" boolean,
    "attackerScore" bigint,
    "defenderScore" bigint,
    "pointTo" uuid,
    "resolved" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "duel_round_unique_idx" ON "duel_round" USING btree ("duelId", "roundNumber");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "friendship" (
    "id" bigserial PRIMARY KEY,
    "playerA" uuid NOT NULL,
    "playerB" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "friendship_unique_idx" ON "friendship" USING btree ("playerA", "playerB");
CREATE INDEX "friendship_b_idx" ON "friendship" USING btree ("playerB");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "player_profile" ADD COLUMN "displayName" text;
ALTER TABLE "player_profile" ADD COLUMN "friendCode" text;
ALTER TABLE "player_profile" ADD COLUMN "quizDay" text;
ALTER TABLE "player_profile" ADD COLUMN "quizQuestionId" bigint;
ALTER TABLE "player_profile" ADD COLUMN "quizChosenIndex" bigint;
ALTER TABLE "player_profile" ADD COLUMN "quizAnswered" boolean NOT NULL DEFAULT false;
ALTER TABLE "player_profile" ADD COLUMN "lastCorrectDay" text;
ALTER TABLE "player_profile" ADD COLUMN "streak" bigint NOT NULL DEFAULT 0;
ALTER TABLE "player_profile" ADD COLUMN "bestStreak" bigint NOT NULL DEFAULT 0;
ALTER TABLE "player_profile" ADD COLUMN "totalAnswered" bigint NOT NULL DEFAULT 0;
ALTER TABLE "player_profile" ADD COLUMN "totalCorrect" bigint NOT NULL DEFAULT 0;
ALTER TABLE "player_profile" ADD COLUMN "duelsWon" bigint NOT NULL DEFAULT 0;
ALTER TABLE "player_profile" ADD COLUMN "duelsPlayed" bigint NOT NULL DEFAULT 0;
CREATE UNIQUE INDEX "player_profile_friend_code_idx" ON "player_profile" USING btree ("friendCode");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "question" (
    "id" bigserial PRIMARY KEY,
    "saintId" bigint NOT NULL,
    "prompt" text NOT NULL,
    "options" json NOT NULL,
    "correctIndex" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "question_saint_idx" ON "question" USING btree ("saintId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unlock_code" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "saintId" bigint,
    "maxUses" bigint,
    "uses" bigint NOT NULL DEFAULT 0,
    "expiresAt" timestamp without time zone,
    "active" boolean NOT NULL DEFAULT true,
    "note" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "unlock_code__code__unique_idx" ON "unlock_code" USING btree ("code");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unlock_redemption" (
    "id" bigserial PRIMARY KEY,
    "codeId" bigint NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "unlock_redemption_unique_idx" ON "unlock_redemption" USING btree ("codeId", "authUserId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "duel_deck"
    ADD CONSTRAINT "duel_deck_fk_0"
    FOREIGN KEY("duelId")
    REFERENCES "duel"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "duel_round"
    ADD CONSTRAINT "duel_round_fk_0"
    FOREIGN KEY("duelId")
    REFERENCES "duel"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "question"
    ADD CONSTRAINT "question_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "unlock_code"
    ADD CONSTRAINT "unlock_code_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "unlock_redemption"
    ADD CONSTRAINT "unlock_redemption_fk_0"
    FOREIGN KEY("codeId")
    REFERENCES "unlock_code"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20260917012312621-games-social', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260917012312621-games-social', "timestamp" = now();

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
