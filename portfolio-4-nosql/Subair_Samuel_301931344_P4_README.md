# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection attendance_events for attendance_marked and attendance_corrected events. These are fictional event examples based on attendance, student, meeting, club.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related student, meeting, club details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "attendance_marked",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "attendance",
        "key": {
            "attendance_id": 401
        },
        "snapshot": {
            "attendance_id": 401,
            "student_id": 101,
            "meeting_id": 301,
            "recorded_at": "2026-10-10T18:05:00Z",
            "attended": true
        }
    },
    "embedded": {
        "student": [
            {
                "key": {
                    "student_id": 101
                },
                "snapshot": {
                    "student_id": 101,
                    "active": true,
                    "enrolled_on": "2025-09-01"
                },
                "via": [
                    "attendance.student_id → student"
                ]
            }
        ],
        "meeting": [
            {
                "key": {
                    "meeting_id": 301
                },
                "snapshot": {
                    "meeting_id": 301,
                    "club_id": 201,
                    "starts_at": "2026-10-10T18:00:00Z",
                    "location": "Synthetic Hall A",
                    "capacity": 24
                },
                "via": [
                    "attendance.meeting_id → meeting"
                ]
            }
        ],
        "club": [
            {
                "key": {
                    "club_id": 201
                },
                "snapshot": {
                    "club_id": 201,
                    "club_code": "CLUB-SYN-01",
                    "active": true
                },
                "via": [
                    "attendance.meeting_id → meeting.club_id → club"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("attendance_events").find({"eventType":"attendance_marked"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attendance_marked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "attendance_id": 401
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("attendance_events").find({"source.key.attendance_id":401}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attendance_marked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "attendance_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "attendance_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "attendance_id": 401
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("attendance_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "attendance_marked",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "attendance_id": 401
    }
  },
  {
    "_id": "event_000002",
    "eventType": "attendance_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "attendance_id": 401
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("attendance_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| attendance_corrected | 1 |
| attendance_marked | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Subair_Samuel_301931344_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Subair_Samuel_301931344_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

