-- Club Meeting Attendance: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."student" (
  "student_id" bigint NOT NULL,
  "active" boolean NOT NULL,
  "enrolled_on" date,
  CONSTRAINT "pk_student" PRIMARY KEY ("student_id")
);
CREATE TABLE portfolio."club" (
  "club_id" bigint NOT NULL,
  "club_code" text NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_club" PRIMARY KEY ("club_id"),
  CONSTRAINT "uq_club_0" UNIQUE ("club_code")
);
CREATE TABLE portfolio."meeting" (
  "meeting_id" bigint NOT NULL,
  "club_id" bigint NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "location" text NOT NULL,
  "capacity" bigint NOT NULL,
  CONSTRAINT "pk_meeting" PRIMARY KEY ("meeting_id")
);
CREATE TABLE portfolio."attendance" (
  "attendance_id" bigint NOT NULL,
  "student_id" bigint NOT NULL,
  "meeting_id" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "attended" boolean NOT NULL,
  CONSTRAINT "pk_attendance" PRIMARY KEY ("attendance_id"),
  CONSTRAINT "uq_attendance_0" UNIQUE ("student_id", "meeting_id")
);
ALTER TABLE portfolio."meeting" ADD CONSTRAINT "fk_meeting_0" FOREIGN KEY ("club_id") REFERENCES portfolio."club" ("club_id");
ALTER TABLE portfolio."attendance" ADD CONSTRAINT "fk_attendance_0" FOREIGN KEY ("student_id") REFERENCES portfolio."student" ("student_id");
ALTER TABLE portfolio."attendance" ADD CONSTRAINT "fk_attendance_1" FOREIGN KEY ("meeting_id") REFERENCES portfolio."meeting" ("meeting_id");
ALTER TABLE portfolio."meeting" ADD CONSTRAINT "positive_capacity" CHECK ("capacity" > 0);
COMMIT;
