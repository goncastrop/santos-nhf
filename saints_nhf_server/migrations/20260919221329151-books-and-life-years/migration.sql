BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "saint" ADD COLUMN "birthYear" bigint;
ALTER TABLE "saint" ADD COLUMN "birthApprox" boolean NOT NULL DEFAULT false;
ALTER TABLE "saint" ADD COLUMN "deathYear" bigint;
ALTER TABLE "saint" ADD COLUMN "deathApprox" boolean NOT NULL DEFAULT false;
CREATE INDEX "saint_death_year_idx" ON "saint" USING btree ("deathYear");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "saint_book" (
    "id" bigserial PRIMARY KEY,
    "saintId" bigint NOT NULL,
    "title" text NOT NULL,
    "author" text,
    "kind" text NOT NULL,
    "year" bigint,
    "publisher" text,
    "note" text,
    "url" text,
    "position" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "saint_book_saint_idx" ON "saint_book" USING btree ("saintId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "saint_book"
    ADD CONSTRAINT "saint_book_fk_0"
    FOREIGN KEY("saintId")
    REFERENCES "saint"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR saints_nhf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('saints_nhf', '20260919221329151-books-and-life-years', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260919221329151-books-and-life-years', "timestamp" = now();

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
