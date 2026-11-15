-- Fictional sample records for Club Meeting Attendance.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."student" ("student_id", "active", "enrolled_on") VALUES (101, TRUE, '2025-09-01');
INSERT INTO portfolio."student" ("student_id", "active", "enrolled_on") VALUES (102, TRUE, '2025-09-02');
INSERT INTO portfolio."club" ("club_id", "club_code", "active") VALUES (201, 'CLUB-SYN-01', TRUE);
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity") VALUES (301, 201, '2026-10-10T18:00:00Z', 'Synthetic Hall A', 24);
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity") VALUES (302, 201, '2026-10-17T18:00:00Z', 'Synthetic Hall B', 20);
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended") VALUES (401, 101, 301, '2026-10-10T18:05:00Z', TRUE);
COMMIT;
