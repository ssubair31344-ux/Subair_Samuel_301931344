# Club Meeting Attendance — database design

My case study records student, club, meeting, attendance.

## Users

- Students checking meeting attendance
- Club coordinators reviewing meeting attendance

## Main operations

- Record a student's attendance at a meeting
- List attendees for a club meeting
- Summarize attendance by meeting

## Entities

| Entity | Information stored |
| --- | --- |
| student | Represents a student without storing a name or concrete identifying details. |
| club | Represents a club that organizes meetings. |
| meeting | Represents a scheduled meeting belonging to one club. |
| attendance | Records whether a student attended a particular meeting. |

## student

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| student_id | BIGINT | PK | Yes |
| active | BOOLEAN |  | Yes |
| enrolled_on | DATE |  | No |


## club

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| club_id | BIGINT | PK | Yes |
| club_code | TEXT | Unique | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (club_code).

## meeting

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| meeting_id | BIGINT | PK | Yes |
| club_id | BIGINT | FK | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| location | TEXT |  | Yes |
| capacity | INTEGER |  | Yes |
- club_id → club.club_id

## attendance

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| attendance_id | BIGINT | PK | Yes |
| student_id | BIGINT | FK | Yes |
| meeting_id | BIGINT | FK | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| attended | BOOLEAN |  | Yes |
- student_id → student.student_id
- meeting_id → meeting.meeting_id
- Unique key: (student_id, meeting_id).

## Relationships and business rules

- A student can have at most one attendance record for a given meeting; enforce UNIQUE(student_id, meeting_id).
- A meeting must have a capacity greater than zero; enforce a row CHECK on capacity.
- Every meeting must reference an existing club.
- Every attendance record must reference an existing student.
- Every attendance record must reference an existing meeting.

## Assumptions

- No student names or concrete student IDs are supplied; IDs are abstract schema keys, and all exercise data must be synthetic.
- Each meeting belongs to exactly one club, and each attendance record belongs to exactly one student and one meeting.
- Meeting capacity is a positive integer; the model does not enforce that attendance stays below capacity.
- For normalization, Meeting is the worked example: keep club attributes in Club rather than repeating them in Meeting to avoid update anomalies.
- The SQL attendance transaction and MongoDB event write are not assumed to be atomic across stores; event delivery reliability is a discussion topic.
- Separate benchmark plan: create 20000 synthetic attendance rows, compare the meeting-attendee filter with and without a B-tree index on meeting_id, and examine the query plans and measured performance without assuming an outcome.

