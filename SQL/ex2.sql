CREATE TABLE Caregiver (
    caregiverID INT AUTO_INCREMENT PRIMARY KEY,
    isActive BOOLEAN DEFAULT FALSE,
    phoneNumber CHAR(10),
    email VARCHAR(255) UNIQUE,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    alertsNotification BOOLEAN DEFAULT FALSE
);

DESCRIBE Caregiver;

Creating Patient Table 
CREATE TABLE Patient (
    patientID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    dateOfBirth DATE,
    phone CHAR(10),
    allergies VARCHAR(255),
    emergencyContactName VARCHAR(255),
    emergencyContactPhone CHAR(10),
    dementiaStage VARCHAR(20)
        CHECK (dementiaStage IN ('Mild', 'Moderate', 'Severe')),
    caregiverID INT,
    FOREIGN KEY (caregiverID) REFERENCES Caregiver(caregiverID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

DESCRIBE Patient; 

CREATE TABLE Preferences (
    patientID INT PRIMARY KEY,
    communicationLanguage VARCHAR(20) DEFAULT 'English'
        CHECK (communicationLanguage IN ('English', 'French', 'Spanish')),
    voiceType CHAR(1) DEFAULT 'F'
        CHECK (voiceType IN ('M', 'F')),
    volumeLevel TINYINT
        CHECK (volumeLevel BETWEEN 1 AND 10),
    FOREIGN KEY (patientID) REFERENCES Patient(patientID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE Preferences; 

CREATE TABLE Device (
    patientID INT PRIMARY KEY,
    batteryLevel TINYINT
        CHECK (batteryLevel BETWEEN 1 AND 100),
    hasEmergencyButton BOOLEAN DEFAULT TRUE,
    healthConcernAlert BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patientID) REFERENCES Patient(patientID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE Device; 

CREATE TABLE Location (
    patientID INT PRIMARY KEY,
    streetAddress VARCHAR(255),
    postalCode CHAR(6),
    country VARCHAR(255),
    city VARCHAR(255),
    province VARCHAR(255),
    FOREIGN KEY (patientID) REFERENCES Device(patientID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE Location; 

CREATE TABLE Medication (
    medicationID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description VARCHAR(1000),
    strength VARCHAR(50),
    dosageForm VARCHAR(20)
        CHECK (dosageForm IN ('Oral', 'Injection', 'Suppository')),
    directions VARCHAR(1000)
);


DESCRIBE Medication; 

CREATE TABLE Reminder (
    reminderID INT AUTO_INCREMENT PRIMARY KEY,
    patientID INT NOT NULL,
    caregiverID INT,
    eventTime DATETIME NOT NULL,
    medicationID  INT,
    eventDescription VARCHAR(255),
    scheduledTime DATETIME,
    notes VARCHAR(1000),
    isComplete BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patientID) REFERENCES Patient(patientID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (caregiverID) REFERENCES Caregiver(caregiverID)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (medicationID) REFERENCES Medication(medicationID)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

DESCRIBE Reminder; 

CREATE TABLE Availability (
    caregiverID INT,
    dayOfWeek VARCHAR(3)
        CHECK (dayOfWeek IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')),
    startTime TIME,
    endTime TIME,
    PRIMARY KEY (caregiverID, dayOfWeek),
    FOREIGN KEY (caregiverID) REFERENCES Caregiver(caregiverID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (startTime < endTime)
);

DESCRIBE Availability; 
