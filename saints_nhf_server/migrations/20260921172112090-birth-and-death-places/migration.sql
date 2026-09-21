BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "saint" ADD COLUMN "birthPlace" text;
ALTER TABLE "saint" ADD COLUMN "birthLat" double precision;
ALTER TABLE "saint" ADD COLUMN "birthLng" double precision;
ALTER TABLE "saint" ADD COLUMN "deathPlace" text;
ALTER TABLE "saint" ADD COLUMN "deathLat" double precision;
ALTER TABLE "saint" ADD COLUMN "deathLng" double precision;

--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20260921172112090-birth-and-death-places', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260921172112090-birth-and-death-places', "timestamp" = now();

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
