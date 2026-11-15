# Club Meeting Attendance — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| club_id | meeting records (list) |
| --- | --- |
| 201 | [301,302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| meeting.meeting_id | meeting.club_id | meeting.location | club.club_id | club.club_code |
| --- | --- | --- | --- | --- |
| 301 | 201 | Synthetic Hall A | 201 | CLUB-SYN-01 |
| 302 | 201 | Synthetic Hall B | 201 | CLUB-SYN-01 |

Key: meeting_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## meeting_example

| meeting.meeting_id | meeting.club_id | meeting.location | club.club_id | club.club_code |
| --- | --- | --- | --- | --- |
| 301 | 201 | Synthetic Hall A | 201 | CLUB-SYN-01 |
| 302 | 201 | Synthetic Hall B | 201 | CLUB-SYN-01 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## student

| student_id | active | enrolled_on |
| --- | --- | --- |
| 101 | true | 2025-09-01 |
| 102 | true | 2025-09-02 |

## club

| club_id | club_code | active |
| --- | --- | --- |
| 201 | CLUB-SYN-01 | true |

## meeting

| meeting_id | club_id | starts_at | location | capacity |
| --- | --- | --- | --- | --- |
| 301 | 201 | 2026-10-10T18:00:00+00:00 | Synthetic Hall A | 24 |
| 302 | 201 | 2026-10-17T18:00:00+00:00 | Synthetic Hall B | 20 |

## attendance

| attendance_id | student_id | meeting_id | recorded_at | attended |
| --- | --- | --- | --- | --- |
| 401 | 101 | 301 | 2026-10-10T18:05:00+00:00 | true |

## Dependencies

- student: (student_id) → active, enrolled_on
- club: (club_id) → club_code, active
- meeting: (meeting_id) → club_id, starts_at, location, capacity
- attendance: (attendance_id) → student_id, meeting_id, recorded_at, attended

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
