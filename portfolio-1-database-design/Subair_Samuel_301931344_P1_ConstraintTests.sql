-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. student pk. Expected: pk_student, SQLSTATE 23505.
INSERT INTO portfolio."student" ("student_id", "active", "enrolled_on")
VALUES (101, TRUE, '2025-09-02');

-- 2. student nn id. Expected: student_id, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "active", "enrolled_on")
VALUES (NULL, TRUE, '2025-09-03');

-- 3. student nn active. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."student" ("student_id", "active", "enrolled_on")
VALUES (1002, NULL, '2025-09-03');

-- 4. club pk. Expected: pk_club, SQLSTATE 23505.
INSERT INTO portfolio."club" ("club_id", "club_code", "active")
VALUES (201, 'CLUB-SYN-02', TRUE);

-- 5. club unique. Expected: uq_club_0, SQLSTATE 23505.
INSERT INTO portfolio."club" ("club_id", "club_code", "active")
VALUES (1003, 'CLUB-SYN-01', TRUE);

-- 6. club nn id. Expected: club_id, SQLSTATE 23502.
INSERT INTO portfolio."club" ("club_id", "club_code", "active")
VALUES (NULL, 'CLUB-SYN-03', TRUE);

-- 7. club nn code. Expected: club_code, SQLSTATE 23502.
INSERT INTO portfolio."club" ("club_id", "club_code", "active")
VALUES (1004, NULL, TRUE);

-- 8. club nn active. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."club" ("club_id", "club_code", "active")
VALUES (1005, 'CLUB-SYN-04', NULL);

-- 9. meeting pk. Expected: pk_meeting, SQLSTATE 23505.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (301, 201, '2026-10-18T18:00:00Z', 'Synthetic Hall C', 22);

-- 10. meeting fk club. Expected: fk_meeting_0, SQLSTATE 23503.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1006, 9001, '2026-10-18T18:00:00Z', 'Synthetic Hall C', 22);

-- 11. meeting nn id. Expected: meeting_id, SQLSTATE 23502.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (NULL, 201, '2026-10-18T18:00:00Z', 'Synthetic Hall C', 22);

-- 12. meeting nn club. Expected: club_id, SQLSTATE 23502.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1007, NULL, '2026-10-18T18:00:00Z', 'Synthetic Hall C', 22);

-- 13. meeting nn starts. Expected: starts_at, SQLSTATE 23502.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1008, 201, NULL, 'Synthetic Hall C', 22);

-- 14. meeting nn location. Expected: location, SQLSTATE 23502.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1009, 201, '2026-10-18T18:00:00Z', NULL, 22);

-- 15. meeting nn capacity. Expected: capacity, SQLSTATE 23502.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1010, 201, '2026-10-18T18:00:00Z', 'Synthetic Hall C', NULL);

-- 16. meeting check capacity. Expected: positive_capacity, SQLSTATE 23514.
INSERT INTO portfolio."meeting" ("meeting_id", "club_id", "starts_at", "location", "capacity")
VALUES (1011, 201, '2026-10-18T18:00:00Z', 'Synthetic Hall C', 0);

-- 17. attendance pk. Expected: pk_attendance, SQLSTATE 23505.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (401, 102, 302, '2026-10-17T18:05:00Z', TRUE);

-- 18. attendance unique. Expected: uq_attendance_0, SQLSTATE 23505.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1012, 101, 301, '2026-10-10T18:07:00Z', FALSE);

-- 19. attendance fk student. Expected: fk_attendance_0, SQLSTATE 23503.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1013, 9002, 301, '2026-10-10T18:08:00Z', TRUE);

-- 20. attendance fk meeting. Expected: fk_attendance_1, SQLSTATE 23503.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1014, 101, 9003, '2026-10-10T18:09:00Z', TRUE);

-- 21. attendance nn id. Expected: attendance_id, SQLSTATE 23502.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (NULL, 101, 301, '2026-10-10T18:10:00Z', TRUE);

-- 22. attendance nn student. Expected: student_id, SQLSTATE 23502.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1015, NULL, 301, '2026-10-10T18:11:00Z', TRUE);

-- 23. attendance nn meeting. Expected: meeting_id, SQLSTATE 23502.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1016, 101, NULL, '2026-10-10T18:12:00Z', TRUE);

-- 24. attendance nn recorded. Expected: recorded_at, SQLSTATE 23502.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1017, 101, 301, NULL, TRUE);

-- 25. attendance nn attended. Expected: attended, SQLSTATE 23502.
INSERT INTO portfolio."attendance" ("attendance_id", "student_id", "meeting_id", "recorded_at", "attended")
VALUES (1018, 101, 301, '2026-10-10T18:13:00Z', NULL);
