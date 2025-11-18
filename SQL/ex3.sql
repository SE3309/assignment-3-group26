INSERT INTO Caregiver (isActive, phoneNumber, email, firstName, lastName)
    VALUES (TRUE, '1234567890', 'ostapMojsiak67@gmail.com', 'Ostap', 'Mojsiak');

INSERT INTO Medication (
    name,
    description,
    strength,
    dosageForm,
    directions
)
VALUES (
    'Donepezil',
    'Used to treat symptoms of Alzheimer''s disease.',
    '5 mg',
    'Oral',
    'Take once daily at bedtime with or without food.'
);

INSERT INTO Patient (
    firstName,
    lastName,
    dateOfBirth,
    phone,
    allergies,
    emergencyContactName,
    emergencyContactPhone,
    dementiaStage,
    caregiverID
)
SELECT
    'Julian',
    'Mojsiak',
    '2004-10-24',
    '0987654321',
    'Peanuts',
    'Ostap Mojsiak',
    '1234567890',
    'Severe',
    c.caregiverID
FROM Caregiver c
WHERE c.firstName = 'Ostap'
  AND c.lastName = 'Mojsiak'; 

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
    '2025-11-20 09:00:00',
    m.medicationID,
    CONCAT('Morning dose of ', m.name),
    '2025-11-20 09:00:00',
    CONCAT(
        'Auto-created reminder for ',
        p.firstName, ' ', p.lastName,
        ' (caregiver: ', c.firstName, ' ', c.lastName, ').'
    ),
    FALSE
FROM Patient p
JOIN Caregiver c
    ON p.caregiverID = c.caregiverID
JOIN Medication m
    ON m.medicationID = 1
WHERE p.firstName = 'Julian'
  AND p.lastName = 'Mojsiak'; 

