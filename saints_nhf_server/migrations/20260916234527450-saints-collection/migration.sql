BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_profile" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "lastDailyClaimDay" text,
    "starterGranted" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "player_profile_auth_user_idx" ON "player_profile" USING btree ("authUserId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "saint" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "slug" text NOT NULL,
    "title" text,
    "feastMonth" bigint,
    "feastDay" bigint,
    "bio" text NOT NULL DEFAULT ''::text,
    "prayer" text,
    "illustrationPath" text,
    "season" bigint,
    "episode" bigint,
    "youtubeUrl" text,
    "status" text NOT NULL DEFAULT 'draft'::text,
    "catequesis" bigint NOT NULL DEFAULT 50,
    "escritos" bigint NOT NULL DEFAULT 50,
    "oracion" bigint NOT NULL DEFAULT 50,
    "patronazgos" bigint NOT NULL DEFAULT 50,
    "evangelizacion" bigint NOT NULL DEFAULT 50,
    "viajes" bigint NOT NULL DEFAULT 50,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "saint__slug__unique_idx" ON "saint" USING btree ("slug");
CREATE INDEX "saint_status_idx" ON "saint" USING btree ("status");
CREATE INDEX "saint_feast_idx" ON "saint" USING btree ("feastMonth", "feastDay");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "saint_revision" (
    "id" bigserial PRIMARY KEY,
    "saintId" bigint NOT NULL,
    "snapshotJson" text NOT NULL,
    "note" text,
    "changedByEmail" text,
    "changedByAuthUserId" uuid,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "saint_revision_saint_idx" ON "saint_revision" USING btree ("saintId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_saint_card" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "saintId" bigint NOT NULL,
    "source" text NOT NULL,
    "obtainedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "user_saint_card_unique_idx" ON "user_saint_card" USING btree ("authUserId", "saintId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player_profile"
    ADD CONSTRAINT "player_profile_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "saint_revision"
    ADD CONSTRAINT "saint_revision_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "user_saint_card"
    ADD CONSTRAINT "user_saint_card_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20260916234527450-saints-collection', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260916234527450-saints-collection', "timestamp" = now();

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
