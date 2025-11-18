CREATE VIEW SeverePatientsWithCaregiver AS
SELECT
    p.patientID,
    p.firstName  AS patientFirstName,
    p.lastName   AS patientLastName,
    p.dementiaStage,
    c.caregiverID,
    c.firstName  AS caregiverFirstName,
    c.lastName   AS caregiverLastName
FROM Patient p
JOIN Caregiver c
    ON p.caregiverID = c.caregiverID
WHERE p.dementiaStage = 'Severe';

SELECT
    patientFirstName,
    patientLastName,
    caregiverFirstName,
    caregiverLastName
FROM SeverePatientsWithCaregiver
WHERE patientLastName = 'Mojsiak';

CREATE VIEW ActiveCaregivers AS
SELECT
    caregiverID,
    firstName,
    lastName,
    email,
    phoneNumber
FROM Caregiver
WHERE isActive = TRUE;

SELECT
    caregiverID,
    firstName,
    lastName,
    email
FROM ActiveCaregivers
WHERE email LIKE '%@gmail.com';

