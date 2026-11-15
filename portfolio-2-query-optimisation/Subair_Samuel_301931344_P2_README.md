# Club Meeting Attendance — SQL queries

## 1. Show related attendance, student, meeting, club records (up to 20).

```sql
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
```

| attendance_attendance_id | attendance_recorded_at | student_student_id | student_active | meeting_meeting_id | meeting_starts_at | club_club_id | club_club_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 2026-10-10T18:05:00+00:00 | 101 | true | 301 | 2026-10-10T18:00:00+00:00 | 201 | CLUB-SYN-01 |

## 2. Find meeting records where club_id matches 201 (up to 20).

```sql
SELECT * FROM portfolio."meeting"
WHERE "club_id" IS NOT DISTINCT FROM 201
ORDER BY "meeting_id"
LIMIT 20;
```

| meeting_id | club_id | starts_at | location | capacity |
| --- | --- | --- | --- | --- |
| 301 | 201 | 2026-10-10T18:00:00+00:00 | Synthetic Hall A | 24 |
| 302 | 201 | 2026-10-17T18:00:00+00:00 | Synthetic Hall B | 20 |

## 3. Count attendance records for each student_id (up to 20 groups).

```sql
SELECT "student_id", count(*) AS record_count
FROM portfolio."attendance"
GROUP BY "student_id"
ORDER BY record_count DESC, "student_id" NULLS LAST
LIMIT 20;
```

| student_id | record_count |
| --- | --- |
| 101 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.865 | 0.865, 0.887, 0.85 | Sort → Seq Scan | 112 |
| After index | 0.237 | 0.191, 0.237, 1.293 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.865 ms to 0.237 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.84..0.841 rows=20 loops=1)
  Seq Scan on attendance (actual time=0.015..0.803 rows=20 loops=1)
Planning Time: 0.338 ms
Execution Time: 0.865 ms
```

### Before index, run 2

```text
Sort (actual time=0.86..0.862 rows=20 loops=1)
  Seq Scan on attendance (actual time=0.014..0.821 rows=20 loops=1)
Planning Time: 0.367 ms
Execution Time: 0.887 ms
```

### Before index, run 3

```text
Sort (actual time=0.826..0.828 rows=20 loops=1)
  Seq Scan on attendance (actual time=0.015..0.791 rows=20 loops=1)
Planning Time: 0.327 ms
Execution Time: 0.85 ms
```

### After index, run 1

```text
Sort (actual time=0.135..0.137 rows=20 loops=1)
  Bitmap Heap Scan on attendance (actual time=0.029..0.098 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=20 loops=1)
Planning Time: 0.557 ms
Execution Time: 0.191 ms
```

### After index, run 2

```text
Sort (actual time=0.171..0.173 rows=20 loops=1)
  Bitmap Heap Scan on attendance (actual time=0.035..0.121 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.646 ms
Execution Time: 0.237 ms
```

### After index, run 3

```text
Sort (actual time=1.214..1.217 rows=20 loops=1)
  Bitmap Heap Scan on attendance (actual time=0.036..1.164 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.687 ms
Execution Time: 1.293 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Subair_Samuel_301931344_P2_Queries.sql, then Subair_Samuel_301931344_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Subair_Samuel_301931344_P2_QueryResults.png) · [Index comparison](screenshots/Subair_Samuel_301931344_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

