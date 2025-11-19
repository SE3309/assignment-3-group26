SELECT * FROM Reminder WHERE patientID=597; 

SELECT DISTINCT
    c.firstName,
    c.lastName
FROM Caregiver c
JOIN Reminder r
    ON c.caregiverID = r.caregiverID
JOIN Medication m
    ON r.medicationID = m.medicationID
WHERE m.dosageForm = 'Injection';

SELECT
    firstName,
    lastName,
    email
FROM Caregiver
WHERE isActive = TRUE
  AND alertsNotification = TRUE 
  AND firstName = 'Taylor';

SELECT
    p.firstName  AS patientFirstName,
    p.lastName   AS patientLastName,
    c.firstName  AS caregiverFirstName,
    c.lastName   AS caregiverLastName
FROM Patient p
JOIN Caregiver c
    ON p.caregiverID = c.caregiverID
WHERE p.dementiaStage = 'Severe'
  AND TIMESTAMPDIFF(YEAR, p.dateOfBirth, CURDATE()) > 80;

SELECT
    c.caregiverID,
    c.firstName,
    c.lastName,
    COUNT(*) AS numPatients
FROM Caregiver c
JOIN Patient p
    ON c.caregiverID = p.caregiverID
GROUP BY
    c.caregiverID,
    c.firstName,
    c.lastName
HAVING COUNT(*) > 5;

SELECT
    p.patientID,
    p.firstName,
    p.lastName,
    pr.volumeLevel,
    p.caregiverID
FROM Patient p
JOIN Preferences pr
    ON p.patientID = pr.patientID
WHERE pr.volumeLevel >= 9
  AND p.caregiverID IN (
        SELECT caregiverID
        FROM Patient
        WHERE caregiverID IS NOT NULL
        GROUP BY caregiverID
        HAVING COUNT(*) > 5
    );

SELECT
    r.reminderID,
    r.scheduledTime,
    p.firstName,
    p.lastName,
    l.city,
    l.country
FROM Reminder r
JOIN Patient p
    ON r.patientID = p.patientID
JOIN Location l
    ON p.patientID = l.patientID
WHERE r.scheduledTime BETWEEN '2024-11-01 00:00:00'
                          AND '2024-11-30 23:59:59'
  AND l.country = 'Canada'  AND city = 'Calgary';


