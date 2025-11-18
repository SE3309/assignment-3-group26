DELETE FROM Availability
WHERE caregiverID IN (
    SELECT caregiverID
    FROM Caregiver
    WHERE isActive = FALSE
); 

UPDATE Preferences pr
JOIN Patient p
  ON pr.patientID = p.patientID
JOIN Location l
  ON p.patientID = l.patientID
SET pr.volumeLevel = LEAST(pr.volumeLevel + 2, 10)
WHERE l.country = 'Canada'
  AND pr.volumeLevel <= 8
  AND l.city = 'Toronto'; 

INSERT INTO Reminder (
    patientID,
    caregiverID,
    eventTime,
    medicationID,
    eventDescription,
    scheduledTime,
    notes,
    isComplete
)
SELECT
    p.patientID,
    p.caregiverID,
    '2025-12-01 09:00:00',
    m.medicationID,
    CONCAT('Morning dose of ', m.name),
    '2025-12-01 09:00:00',
    CONCAT('Auto-created bulk reminder for ', p.firstName, ' ', p.lastName),
    FALSE
FROM Patient p
JOIN Medication m
  ON m.medicationID = (
        SELECT MIN(m2.medicationID)
        FROM Medication m2
        WHERE m2.dosageForm = 'Oral'
     )
WHERE p.dementiaStage = 'Severe'
  AND p.caregiverID IS NOT NULL
  AND p.firstName = 'Taylor';