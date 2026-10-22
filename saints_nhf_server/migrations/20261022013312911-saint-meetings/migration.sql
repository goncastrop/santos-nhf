BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "saint_meeting" (
    "id" bigserial PRIMARY KEY,
    "saintAId" bigint NOT NULL,
    "saintBId" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "saint_meeting_pair_idx" ON "saint_meeting" USING btree ("saintAId", "saintBId");
CREATE INDEX "saint_meeting_b_idx" ON "saint_meeting" USING btree ("saintBId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "saint_meeting"
    ADD CONSTRAINT "saint_meeting_fk_0"
    FOREIGN KEY("saintAId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "saint_meeting"
    ADD CONSTRAINT "saint_meeting_fk_1"
    FOREIGN KEY("saintBId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20261022013312911-saint-meetings', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261022013312911-saint-meetings', "timestamp" = now();

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
