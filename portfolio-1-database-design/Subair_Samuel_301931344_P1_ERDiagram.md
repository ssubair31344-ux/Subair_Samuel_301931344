# Club Meeting Attendance — ER diagram

```mermaid
erDiagram
    direction LR
    student {
        bigint student_id PK
        boolean active
        date enrolled_on "Optional"
    }
    club {
        bigint club_id PK
        text club_code UK
        boolean active
    }
    meeting {
        bigint meeting_id PK
        bigint club_id FK
        timestamptz starts_at
        text location
        integer capacity
    }
    attendance {
        bigint attendance_id PK
        bigint student_id FK
        bigint meeting_id FK
        timestamptz recorded_at
        boolean attended
    }
    club ||--o{ meeting : "club_id"
    student ||--o{ attendance : "student_id"
    meeting ||--o{ attendance : "meeting_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Subair_Samuel_301931344_ERDiagram.png)
