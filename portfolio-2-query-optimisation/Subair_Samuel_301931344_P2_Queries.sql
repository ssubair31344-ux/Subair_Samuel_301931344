-- Show related attendance, student, meeting, club records (up to 20).
SELECT t0."attendance_id" AS "attendance_attendance_id",
       t0."recorded_at" AS "attendance_recorded_at",
       t1."student_id" AS "student_student_id",
       t1."active" AS "student_active",
       t2."meeting_id" AS "meeting_meeting_id",
       t2."starts_at" AS "meeting_starts_at",
       t3."club_id" AS "club_club_id",
       t3."club_code" AS "club_club_code"
FROM portfolio."attendance" t0
JOIN portfolio."student" t1 ON t0."student_id" = t1."student_id"
JOIN portfolio."meeting" t2 ON t0."meeting_id" = t2."meeting_id"
JOIN portfolio."club" t3 ON t2."club_id" = t3."club_id"
ORDER BY t0."attendance_id", t1."student_id", t2."meeting_id", t3."club_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."attendance_id" AS "attendance_attendance_id",
       t0."recorded_at" AS "attendance_recorded_at",
       t1."student_id" AS "student_student_id",
       t1."active" AS "student_active",
       t2."meeting_id" AS "meeting_meeting_id",
       t2."starts_at" AS "meeting_starts_at",
       t3."club_id" AS "club_club_id",
       t3."club_code" AS "club_club_code"
FROM portfolio."attendance" t0
JOIN portfolio."student" t1 ON t0."student_id" = t1."student_id"
JOIN portfolio."meeting" t2 ON t0."meeting_id" = t2."meeting_id"
JOIN portfolio."club" t3 ON t2."club_id" = t3."club_id"
ORDER BY t0."attendance_id", t1."student_id", t2."meeting_id", t3."club_id"
LIMIT 20;

-- Find meeting records where club_id matches 201 (up to 20).
SELECT * FROM portfolio."meeting"
WHERE "club_id" IS NOT DISTINCT FROM 201
ORDER BY "meeting_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."meeting"
WHERE "club_id" IS NOT DISTINCT FROM 201
ORDER BY "meeting_id"
LIMIT 20;

-- Count attendance records for each student_id (up to 20 groups).
SELECT "student_id", count(*) AS record_count
FROM portfolio."attendance"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "student_id", count(*) AS record_count
FROM portfolio."attendance"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;
