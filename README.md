# Hospital Database — Stored Procedures, Triggers & Transactions

This project is part of the **ASP.NET Backend Development Course — SQL Server Module**.

The assignment extends the Hospital database by implementing reusable **stored procedures**, different parameter types, error handling, auditing, triggers, and database transactions.

The assignment contains **50 questions**, progressing from basic stored procedures to complete transactional and audit-based database workflows.

---

## Technologies Used

- Microsoft SQL Server
- T-SQL
- Docker
- Visual Studio Code
- MSSQL Extension for VS Code
- Git
- GitHub

The SQL Server instance runs locally inside Docker.

```text
Server: localhost,1433
Database: Hospital
```

---

# Database Schema

The assignment uses the existing `Hospital` database.

Main tables:

```text
Hospital
│
├── Patients
├── Wards
├── Consultants
├── Nurses
├── DrugAdministrations
├── Drugs
├── DrugBrands
├── PatientExaminations
└── PatientConsultantAssignments
```

Important relationships include:

```text
Patients
   │
   └── WardId ──────────────> Wards

PatientExaminations
   ├── PatientId ───────────> Patients
   └── ConsultantId ────────> Consultants

PatientConsultantAssignments
   ├── PatientId ───────────> Patients
   └── ConsultantId ────────> Consultants

DrugAdministrations
   ├── PatientId ───────────> Patients
   ├── NurseId ─────────────> Nurses
   └── DrugCode ────────────> Drugs

Nurses
   └── ServesInWardId ──────> Wards
```

---

# Assignment Overview

The 50 questions cover:

| Questions | Main Topic                                 |
| --------- | ------------------------------------------ |
| Q1–Q6     | Basic Stored Procedures & Input Parameters |
| Q7–Q9     | OUTPUT Parameters                          |
| Q10–Q12   | Input-Output Parameters                    |
| Q13–Q15   | TRY-CATCH Error Handling                   |
| Q16–Q24   | CRUD Stored Procedures                     |
| Q25–Q27   | INSERT INTO ... EXEC                       |
| Q28–Q36   | AFTER Triggers & Auditing                  |
| Q37–Q42   | INSTEAD OF Triggers & Validation           |
| Q43–Q45   | Stored Procedures + Triggers               |
| Q46       | Transactions + TRY-CATCH                   |
| Q47       | Complete Audit System                      |
| Q48–Q50   | Advanced Stored Procedures                 |

---

# 1. Basic Stored Procedures

The first section introduces stored procedures for retrieving hospital data.

Examples include:

- Displaying all patients
- Displaying consultants and salaries
- Displaying patients with their wards
- Finding a patient by ID
- Filtering consultants by minimum salary
- Finding patients by ward

Example:

```sql
CREATE OR ALTER PROCEDURE dbo.GetPatientById
    @PatientId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id, Name, DOB, WardId
    FROM Patients
    WHERE Id = @PatientId;
END;
```

Execution:

```sql
EXEC dbo.GetPatientById @PatientId = 202;
```

---

# 2. Stored Procedure Parameters

The assignment practices three parameter patterns.

## Input Parameters

Values are supplied to a procedure.

```sql
@PatientId INT
```

Example:

```sql
EXEC dbo.GetPatientsByWard @WardId = 1;
```

---

## OUTPUT Parameters

OUTPUT parameters allow a stored procedure to return a calculated value through a variable.

Examples include:

- Total patient count
- Average consultant salary
- Total medication quantity for a patient

Example:

```sql
DECLARE @Count INT;

EXEC dbo.GetPatientCount
    @PatientCount = @Count OUTPUT;

SELECT @Count AS TotalPatients;
```

---

## Input-Output Parameters

A parameter can receive an initial value, modify it, and return the new value.

This is used for:

- Increasing salary
- Increasing medication quantity
- Converting monthly salary to annual salary

Example concept:

```text
Monthly Salary
      │
      ▼
Stored Procedure
      │
      × 12
      ▼
Annual Salary
```

---

# 3. Error Handling with TRY-CATCH

Several procedures use SQL Server's:

```sql
BEGIN TRY
    ...
END TRY

BEGIN CATCH
    ...
END CATCH
```

This allows database errors to be handled safely.

The assignment applies error handling to:

- Patient insertion
- Consultant salary updates
- Patient deletion
- Medication calculations
- Patient summary procedures

Custom errors are also raised using:

```sql
THROW;
```

or:

```sql
THROW 50001, 'Custom error message.', 1;
```

---

# 4. CRUD Stored Procedures

The assignment implements stored procedures for the main database operations.

## CREATE

Examples:

```text
AddPatient
AddConsultant
RecordMedicationAdministration
```

## READ

Examples:

```text
GetAllPatients
GetAllConsultants
GetPatientById
GetPatientsByWard
```

## UPDATE

Examples:

```text
UpdatePatient
UpdateConsultantSalary
IncreaseNurseSalary
```

## DELETE

Examples:

```text
DeletePatient
DeleteConsultant
DeleteMedicationAdministration
```

This demonstrates how application code can interact with the database through stored procedures rather than directly executing SQL statements.

---

# 5. INSERT INTO ... EXEC

The assignment practices storing the result returned from a stored procedure inside another table.

General syntax:

```sql
INSERT INTO DestinationTable
EXEC StoredProcedure;
```

Examples include storing:

- All patients
- High-salary consultants
- Patients from a specific ward

Example:

```sql
INSERT INTO StoredPatients
EXEC dbo.GetAllPatients;
```

This allows stored procedure results to be reused and persisted.

---

# 6. SQL Server Triggers

A major part of the assignment focuses on database triggers.

The two main trigger types used are:

```text
AFTER
INSTEAD OF
```

---

# 7. AFTER Triggers

An `AFTER` trigger executes after the original operation succeeds.

The assignment uses AFTER triggers for:

- Auditing inserted patients
- Recording consultant salary changes
- Recording patient ward changes
- Archiving deleted patients
- Auditing deleted consultants
- Comparing old and new values
- Handling multiple inserted rows

Example structure:

```sql
CREATE TRIGGER ...
ON Patients
AFTER INSERT
AS
BEGIN

    INSERT INTO PatientAudit (...)
    SELECT ...
    FROM inserted;

END;
```

---

# 8. inserted and deleted Tables

SQL Server triggers provide two special logical tables:

```text
inserted
deleted
```

They contain the affected rows.

### INSERT

```text
inserted → new rows
```

### DELETE

```text
deleted → deleted rows
```

### UPDATE

Both are available:

```text
deleted             inserted
   │                    │
   ▼                    ▼
Old Values    →     New Values
```

For example, consultant salary changes can be compared using:

```sql
SELECT
    d.Salary AS OldSalary,
    i.Salary AS NewSalary
FROM inserted i
INNER JOIN deleted d
    ON i.Id = d.Id;
```

---

# 9. Multi-Row Trigger Design

Triggers are written using **set-based operations** rather than assuming only one row is affected.

For example:

```sql
INSERT INTO PatientAudit (...)
SELECT ...
FROM inserted;
```

works for:

```sql
INSERT INTO Patients (...)
VALUES (...);
```

as well as:

```sql
INSERT INTO Patients (...)
VALUES
    (...),
    (...),
    (...);
```

This is important because SQL Server triggers execute once per statement, not once per row.

---

# 10. Audit Tables

Several audit tables are created during the assignment.

Examples include:

```text
PatientAudit
ConsultantSalaryAudit
PatientWardAudit
DeletedPatients
DeletedConsultants
```

These tables preserve information about database modifications.

A typical audit flow is:

```text
Application
     │
     ▼
UPDATE Consultants
     │
     ▼
AFTER UPDATE Trigger
     │
     ▼
ConsultantSalaryAudit
     │
     ├── Old Salary
     ├── New Salary
     └── Change Date
```

---

# 11. INSTEAD OF Triggers

An `INSTEAD OF` trigger replaces the original database operation.

The trigger decides whether the requested operation should actually occur.

The assignment uses these triggers to:

- Prevent patients without wards
- Reject future dates of birth
- Prevent consultant salary reductions
- Prevent changing patient IDs
- Prevent direct patient deletion
- Archive patients before deletion

Example validation flow:

```text
INSERT Patient
     │
     ▼
INSTEAD OF INSERT
     │
     ├── Invalid → THROW Error
     │
     └── Valid
           │
           ▼
      INSERT Patient
```

---

## Important Trigger Limitation

SQL Server allows only one `INSTEAD OF` trigger for the same operation on a table.

For example, two separate:

```text
INSTEAD OF INSERT
```

triggers cannot both be active on `Patients`.

Therefore some assignment questions are implemented and tested as **alternative exercises**.

For example:

```text
Q37 → INSTEAD OF INSERT — Ward validation

Q38 → INSTEAD OF INSERT — DOB validation
```

One should be removed or replaced before testing the other.

The same applies to the alternative `INSTEAD OF DELETE` exercises.

---

# 12. Transactions

The assignment introduces transactions for operations that must succeed or fail together.

The main transactional workflow:

```text
BEGIN TRANSACTION
       │
       ├── Update Patient Ward
       │
       └── Insert Medication Administration
       │
       ▼
   Everything OK?
     /       \
   Yes        No
    │          │
 COMMIT     ROLLBACK
```

Example structure:

```sql
BEGIN TRY

    BEGIN TRANSACTION;

    -- Operation 1
    -- Operation 2

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
```

This protects the database from partial updates.

---

# 13. Complete Patient Audit System

The assignment eventually combines multiple triggers into a complete audit system for the `Patients` table.

The audit system records:

```text
INSERT
UPDATE
DELETE
```

along with information such as:

```text
Patient ID
Patient Name
Operation Type
Operation Date
```

This creates a historical record of changes made to patient data.

---

# 14. Stored Procedures + Triggers

Several final exercises demonstrate how stored procedures and triggers work together.

For example:

```text
AddPatient Procedure
        │
        ▼
INSERT Patients
        │
        ▼
AFTER INSERT Trigger
        │
        ▼
PatientAudit
```

The application only needs to execute the procedure.

The trigger automatically performs the audit operation.

---

# 15. Medication Quantity Handling

The provided Hospital database stores medication dosage as text.

Examples:

```text
2 tablets
1 tablet
```

There is no separate numeric `Quantity` column.

Therefore, when the assignment requires medication quantity, the numeric portion is extracted using:

```sql
TRY_CAST(
    LEFT(
        Dosage,
        CHARINDEX(' ', Dosage + ' ') - 1
    )
    AS INT
)
```

This converts:

```text
"2 tablets" → 2
"1 tablet"  → 1
```

The resulting values can then be used with:

```sql
SUM()
AVG()
```

and OUTPUT parameters.

---

# 16. Final Stored Procedures

The final questions combine several concepts.

## Hospital Statistics

A stored procedure returns:

```text
Total Patients
Total Consultants
Average Consultant Salary
Total Medication Quantity
```

---

## Safe Medication Summary

A procedure combines:

```text
Input Parameter
      +
OUTPUT Parameter
      +
TRY-CATCH
```

to safely calculate a patient's total medication quantity.

---

## Final Patient Summary

The final procedure accepts a patient ID and returns:

```text
Patient ID
Patient Name
Date of Birth
Ward ID
Ward Name
Medication Administration Count
Total Medication Quantity
```

It combines:

- Stored procedures
- Parameters
- JOINs
- Aggregation
- Error handling

---

# Project Structure

```text
Hospital-Database-Assignment/
│
├── README.md
│
├── HospitalQueries.sql
│
├── Hospital_Aggregates_Functions.sql
└── Hospital_StoredProcedures_Triggers.sql
```

### `HospitalQueries.sql`

Contains the JOIN and window-function assignment.

### `Hospital_Aggregates_Functions.sql`

Contains aggregation, subqueries, `SELECT INTO`, scalar functions, and table-valued functions.

### `Hospital_StoredProcedures_Triggers.sql`

Contains the current 50-question assignment covering:

- Stored procedures
- Parameters
- Error handling
- CRUD operations
- `INSERT INTO ... EXEC`
- Triggers
- Auditing
- Transactions

---

# Key Concepts Practiced

```text
Stored Procedures
│
├── Input Parameters
├── OUTPUT Parameters
├── Input-Output Parameters
├── CRUD Operations
└── TRY-CATCH
        │
        ▼
INSERT INTO ... EXEC
        │
        ▼
Triggers
│
├── AFTER INSERT
├── AFTER UPDATE
├── AFTER DELETE
├── INSTEAD OF INSERT
├── INSTEAD OF UPDATE
└── INSTEAD OF DELETE
        │
        ▼
inserted / deleted
        │
        ▼
Audit Systems
        │
        ▼
Transactions
│
├── BEGIN TRANSACTION
├── COMMIT
└── ROLLBACK
```

---

# Running the Project

Start the SQL Server container:

```bash
docker start sqlserver
```

Open the project in VS Code and connect using the MSSQL extension:

```text
Server: localhost,1433
Database: Hospital
```

The SQL scripts begin with:

```sql
USE Hospital;
GO
```

Run the assignment sections individually when testing triggers, especially the `INSTEAD OF` trigger exercises.

---

# Learning Outcomes

After completing this assignment, the main skills practiced include:

- Creating reusable stored procedures
- Passing input parameters
- Returning values through OUTPUT parameters
- Using input-output parameters
- Implementing CRUD operations through procedures
- Handling SQL errors with TRY-CATCH
- Raising custom errors with THROW
- Capturing procedure results with `INSERT INTO ... EXEC`
- Creating AFTER and INSTEAD OF triggers
- Understanding `inserted` and `deleted`
- Writing triggers that support multiple rows
- Creating database audit systems
- Validating data at the database level
- Archiving deleted records
- Using transactions for atomic operations
- Rolling back failed operations
- Combining stored procedures, triggers, joins, and aggregation

---

## Course

**ASP.NET Backend Development Course — SQL Server Module**

This project demonstrates the progression from basic SQL querying to reusable database programming, automated auditing, validation, and transactional data operations.
