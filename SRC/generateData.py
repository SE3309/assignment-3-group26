import random
import string
from datetime import datetime, timedelta

# Sizes
N_CAREGIVERS = 500
N_PATIENTS = 1000
N_MEDICATIONS = 400
N_REMINDERS = 2000

DB_NAME = "medicalDevice"

random.seed(42)

first_names = [
    "Alex", "Taylor", "Jordan", "Morgan", "Casey", "Jamie", "Riley", "Sam",
    "Drew", "Quinn", "Avery", "Logan", "Harper", "Rowan", "Peyton"
]
last_names = [
    "Smith", "Johnson", "Brown", "Taylor", "Lee", "Wilson", "Clark", "Hall",
    "Young", "King", "Wright", "Scott", "Green", "Baker", "Adams"
]
countries = ["Canada", "USA"]
provinces = ["Ontario", "Quebec", "BC", "Alberta", "Manitoba", "Nova Scotia"]
cities = ["Toronto", "London", "Ottawa", "Vancouver", "Montreal", "Calgary"]
dosage_forms = ["Oral", "Injection", "Suppository"]
dementia_stages = ["Mild", "Moderate", "Severe"]
days_of_week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]


def rand_phone10():
    return "".join(random.choices("0123456789", k=10))


def rand_postal6():
    letters = string.ascii_uppercase
    digits = "0123456789"
    return (
        random.choice(letters) + random.choice(digits) +
        random.choice(letters) + random.choice(digits) +
        random.choice(letters) + random.choice(digits)
    )


def rand_dob():
    start = datetime(1940, 1, 1)
    end = datetime(2020, 12, 31)
    delta_days = (end - start).days
    offset = random.randint(0, delta_days)
    return (start + timedelta(days=offset)).strftime("%Y-%m-%d")


def rand_datetime_2024():
    start = datetime(2024, 1, 1)
    end = datetime(2024, 12, 31, 23, 59, 59)
    delta_seconds = int((end - start).total_seconds())
    offset = random.randint(0, delta_seconds)
    dt = start + timedelta(seconds=offset)
    return dt.strftime("%Y-%m-%d %H:%M:%S")


def rand_time_between(start_hour=8, end_hour=20):
    hour = random.randint(start_hour, end_hour - 1)
    minute = random.choice([0, 15, 30, 45])
    return f"{hour:02d}:{minute:02d}:00"


def sql_str(s: str) -> str:
    return "'" + s.replace("'", "''") + "'"


def main():
    print(f"USE {DB_NAME};")
    print()

    # CAREGIVER
    for _ in range(N_CAREGIVERS):
        fn = random.choice(first_names)
        ln = random.choice(last_names)
        email = f"{fn.lower()}.{ln.lower()}{random.randint(100,9999)}@example.com"
        phone = rand_phone10()
        is_active = random.choice([0, 1])
        alerts = random.choice([0, 1])

        print(
            "INSERT INTO Caregiver "
            "(isActive, phoneNumber, email, firstName, lastName, alertsNotification) "
            f"VALUES ({is_active}, {sql_str(phone)}, {sql_str(email)}, "
            f"{sql_str(fn)}, {sql_str(ln)}, {alerts});"
        )
    print()

    # PATIENT 
    for _ in range(N_PATIENTS):
        fn = random.choice(first_names)
        ln = random.choice(last_names)
        dob = rand_dob()
        phone = rand_phone10()
        allergies = random.choice(
            ["None", "Peanuts", "Penicillin", "Latex", "Pollen", "Shellfish", "Dust"]
        )
        efn = random.choice(first_names)
        eln = random.choice(last_names)
        emergency_name = f"{efn} {eln}"
        emergency_phone = rand_phone10()
        stage = random.choice(dementia_stages)
        caregiver_id = random.randint(1, N_CAREGIVERS + 1)  # +1 for your manual caregiver

        print(
            "INSERT INTO Patient "
            "(firstName, lastName, dateOfBirth, phone, allergies, "
            "emergencyContactName, emergencyContactPhone, dementiaStage, caregiverID) "
            f"VALUES ({sql_str(fn)}, {sql_str(ln)}, {sql_str(dob)}, "
            f"{sql_str(phone)}, {sql_str(allergies)}, "
            f"{sql_str(emergency_name)}, {sql_str(emergency_phone)}, "
            f"{sql_str(stage)}, {caregiver_id});"
        )
    print()

    # PREFERENCES
    print("-- Insert preferences")
    languages = ["English", "French", "Spanish"]
    for pid in range(1, N_PATIENTS + 2):
        lang = random.choice(languages)
        voice = random.choice(["M", "F"])
        volume = random.randint(1, 10)

        print(
            "INSERT INTO Preferences "
            "(patientID, communicationLanguage, voiceType, volumeLevel) "
            f"VALUES ({pid}, {sql_str(lang)}, {sql_str(voice)}, {volume});"
        )
    print()

    # DEVICE 
    for pid in range(1, N_PATIENTS + 2):
        battery = random.randint(1, 100)
        has_button = random.choice([0, 1])
        health_alert = random.choice([0, 1])

        print(
            "INSERT INTO Device "
            "(patientID, batteryLevel, hasEmergencyButton, healthConcernAlert) "
            f"VALUES ({pid}, {battery}, {has_button}, {health_alert});"
        )
    print()

    # LOCATION 
    for pid in range(1, N_PATIENTS + 2):
        street_num = random.randint(1, 9999)
        street_name = random.choice(
            ["Main St", "King St", "Queen St", "Elm St", "Maple Ave", "Oak St"]
        )
        street_addr = f"{street_num} {street_name}"
        postal = rand_postal6()
        country = random.choice(countries)
        province = random.choice(provinces)
        city = random.choice(cities)

        print(
            "INSERT INTO Location "
            "(patientID, streetAddress, postalCode, country, city, province) "
            f"VALUES ({pid}, {sql_str(street_addr)}, {sql_str(postal)}, "
            f"{sql_str(country)}, {sql_str(city)}, {sql_str(province)});"
        )
    print()

    # MEDICATION 
    for mid in range(1, N_MEDICATIONS + 1):
        name = f"Medication {mid}"
        desc = f"Description for medication {mid}"
        strength = random.choice(["5 mg", "10 mg", "20 mg", "50 mg", "10 mL", "5 mL"])
        dform = random.choice(dosage_forms)
        directions = random.choice(
            [
                "Take once daily",
                "Take twice daily",
                "Take with food",
                "Take before bed",
                "Take every 8 hours",
            ]
        )
        print(
            "INSERT INTO Medication "
            "(name, description, strength, dosageForm, directions) "
            f"VALUES ({sql_str(name)}, {sql_str(desc)}, {sql_str(strength)}, "
            f"{sql_str(dform)}, {sql_str(directions)});"
        )
    print()

    # REMINDER
    for _ in range(N_REMINDERS):
        patient_id = random.randint(1, N_PATIENTS + 1)
        caregiver_id = random.randint(1, N_CAREGIVERS + 1)
        med_id = random.randint(1, N_MEDICATIONS + 1)

        scheduled_time = rand_datetime_2024()
        sched_dt = datetime.strptime(scheduled_time, "%Y-%m-%d %H:%M:%S")
        offset_minutes = random.randint(-120, 120)
        event_dt = sched_dt + timedelta(minutes=offset_minutes)
        event_time = event_dt.strftime("%Y-%m-%d %H:%M:%S")

        description = random.choice(
            [
                "Morning medication",
                "Evening medication",
                "Doctor appointment",
                "Check-in call",
                "Vitals check",
            ]
        )
        notes = random.choice(
            [
                "Caregiver confirmed.",
                "Patient reported mild dizziness.",
                "No issues.",
                "Follow up in one week.",
                "Refill needed soon.",
            ]
        )
        is_complete = random.choice([0, 1])

        print(
            "INSERT INTO Reminder "
            "(patientID, caregiverID, eventTime, medicationID, "
            "eventDescription, scheduledTime, notes, isComplete) "
            f"VALUES ({patient_id}, {caregiver_id}, {sql_str(event_time)}, "
            f"{med_id}, {sql_str(description)}, {sql_str(scheduled_time)}, "
            f"{sql_str(notes)}, {is_complete});"
        )
    print()

    # AVAILABILITY 
    for cid in range(1, N_CAREGIVERS + 2):
        num_days = random.randint(3, 6)
        days = random.sample(days_of_week, num_days)
        for d in days:
            start = rand_time_between(8, 16)
            h, m, s = map(int, start.split(":"))
            duration_hours = random.randint(1, 4)
            end_hour = min(h + duration_hours, 20)
            end = f"{end_hour:02d}:{m:02d}:00"

            print(
                "INSERT INTO Availability "
                "(caregiverID, dayOfWeek, startTime, endTime) "
                f"VALUES ({cid}, {sql_str(d)}, {sql_str(start)}, {sql_str(end)});"
            )


if __name__ == "__main__":
    main()
