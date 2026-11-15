// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("attendance_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("attendance_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "attendance_marked",
                    "attendance_corrected"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "attendance"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "attendance_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("attendance_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "attendance_corrected",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "correction_reason": "illustrative correction_reason",
                "client_metadata": "illustrative client_metadata"
            }
        }
    }
]));
  await db.getCollection("attendance_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("attendance_events").find({"eventType":"attendance_marked"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("attendance_events").find({"source.key.attendance_id":401}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("attendance_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("attendance_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("attendance_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("attendance_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("attendance_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
