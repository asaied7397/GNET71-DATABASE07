USE Hospital;
GO


-- /* ============================================================
--    Q1 — Display All Patients
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetAllPatients
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT Id, Name, DOB, WardId
--     FROM dbo.Patients;
-- END;
-- GO


-- /* ============================================================
--    Q2 — Display All Consultants
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetAllConsultants
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT Id, Name, Salary
--     FROM dbo.Consultants;
-- END;
-- GO


-- /* ============================================================
--    Q3 — Display Patients with Their Wards
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientsWithWards
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT
--         p.Id AS PatientId,
--         p.Name AS PatientName,
--         p.DOB,
--         w.Id AS WardId,
--         w.Name AS WardName
--     FROM dbo.Patients p
--     LEFT JOIN dbo.Wards w
--         ON p.WardId = w.Id;
-- END;
-- GO


-- /* ============================================================
--    Q4 — Get Patient by ID
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientById
--     @PatientId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT Id, Name, DOB, WardId
--     FROM dbo.Patients
--     WHERE Id = @PatientId;
-- END;
-- GO


-- /* ============================================================
--    Q5 — Get Consultants by Minimum Salary
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetConsultantsByMinimumSalary
--     @MinimumSalary DECIMAL(18,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT Id, Name, Salary
--     FROM dbo.Consultants
--     WHERE Salary >= @MinimumSalary;
-- END;
-- GO


-- /* ============================================================
--    Q6 — Get Patients by Ward
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientsByWard
--     @WardId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT Id, Name, DOB, WardId
--     FROM dbo.Patients
--     WHERE WardId = @WardId;
-- END;
-- GO


-- /* ============================================================
--    Q7 — Return Patient Count through OUTPUT
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientCount
--     @PatientCount INT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT @PatientCount = COUNT(*)
--     FROM dbo.Patients;
-- END;
-- GO

-- -- Test
-- DECLARE @Count INT;
-- EXEC dbo.GetPatientCount @PatientCount = @Count OUTPUT;
-- SELECT @Count AS TotalPatients;
-- GO


-- /* ============================================================
--    Q8 — Return Average Consultant Salary through OUTPUT
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetAverageConsultantSalary
--     @AverageSalary DECIMAL(18,2) OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT @AverageSalary = AVG(Salary)
--     FROM dbo.Consultants;
-- END;
-- GO

-- -- Test
-- DECLARE @AvgSalary DECIMAL(18,2);
-- EXEC dbo.GetAverageConsultantSalary
--     @AverageSalary = @AvgSalary OUTPUT;

-- SELECT @AvgSalary AS AverageConsultantSalary;
-- GO


-- /* ============================================================
--    Q9 — Return Patient Medication Quantity through OUTPUT
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientMedicationQuantity
--     @PatientId INT,
--     @TotalQuantity INT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT @TotalQuantity =
--         COALESCE(
--             SUM(
--                 TRY_CAST(
--                     LEFT(Dosage, CHARINDEX(' ', Dosage + ' ') - 1)
--                     AS INT
--                 )
--             ),
--             0
--         )
--     FROM dbo.DrugAdministrations
--     WHERE PatientId = @PatientId;
-- END;
-- GO


-- /* ============================================================
--    Q10 — Increase a Salary
--    Input-Output parameter
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.IncreaseSalary
--     @Salary DECIMAL(18,2) OUTPUT,
--     @Percentage DECIMAL(5,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SET @Salary = @Salary + (@Salary * @Percentage / 100.0);
-- END;
-- GO

-- -- Test
-- DECLARE @Salary DECIMAL(18,2) = 50000;

-- EXEC dbo.IncreaseSalary
--     @Salary = @Salary OUTPUT,
--     @Percentage = 10;

-- SELECT @Salary AS NewSalary;
-- GO


-- /* ============================================================
--    Q11 — Increase Medication Quantity
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.IncreaseMedicationQuantity
--     @Quantity INT OUTPUT,
--     @AdditionalQuantity INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SET @Quantity = @Quantity + @AdditionalQuantity;
-- END;
-- GO


-- /* ============================================================
--    Q12 — Monthly Salary to Annual Salary
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.ConvertToAnnualSalary
--     @Salary DECIMAL(18,2) OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SET @Salary = @Salary * 12;
-- END;
-- GO


-- /* ============================================================
--    Q13 — Insert Patient with TRY-CATCH
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.InsertPatientWithErrorHandling
--     @Id INT,
--     @Name NVARCHAR(255),
--     @DOB DATE,
--     @WardId INT = NULL
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     BEGIN TRY

--         INSERT INTO dbo.Patients (Id, Name, DOB, WardId)
--         VALUES (@Id, @Name, @DOB, @WardId);

--     END TRY
--     BEGIN CATCH

--         SELECT
--             ERROR_NUMBER() AS ErrorNumber,
--             ERROR_MESSAGE() AS ErrorMessage;

--     END CATCH;
-- END;
-- GO


-- /* ============================================================
--    Q14 — Update Consultant with Error Handling
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.UpdateConsultantSalaryWithErrorHandling
--     @ConsultantId INT,
--     @NewSalary DECIMAL(18,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     BEGIN TRY

--         UPDATE dbo.Consultants
--         SET Salary = @NewSalary
--         WHERE Id = @ConsultantId;

--         IF @@ROWCOUNT = 0
--             THROW 50001, 'Consultant not found.', 1;

--     END TRY
--     BEGIN CATCH

--         SELECT
--             ERROR_NUMBER() AS ErrorNumber,
--             ERROR_MESSAGE() AS ErrorMessage;

--     END CATCH;
-- END;
-- GO


-- /* ============================================================
--    Q15 — Delete Patient with Error Handling
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.DeletePatientWithErrorHandling
--     @PatientId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     BEGIN TRY

--         DELETE FROM dbo.Patients
--         WHERE Id = @PatientId;

--         IF @@ROWCOUNT = 0
--             THROW 50002, 'Patient not found.', 1;

--     END TRY
--     BEGIN CATCH

--         SELECT
--             ERROR_NUMBER() AS ErrorNumber,
--             ERROR_MESSAGE() AS ErrorMessage;

--     END CATCH;
-- END;
-- GO


-- /* ============================================================
--    Q16 — Add a New Patient
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.AddPatient
--     @Id INT,
--     @Name NVARCHAR(255),
--     @DOB DATE,
--     @WardId INT = NULL
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.Patients (Id, Name, DOB, WardId)
--     VALUES (@Id, @Name, @DOB, @WardId);
-- END;
-- GO


-- /* ============================================================
--    Q17 — Add a New Consultant
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.AddConsultant
--     @Id INT,
--     @Name NVARCHAR(255),
--     @Salary DECIMAL(18,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.Consultants (Id, Name, Salary)
--     VALUES (@Id, @Name, @Salary);
-- END;
-- GO


-- /* ============================================================
--    Q18 — Record Medication Administration
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.RecordMedicationAdministration
--     @NurseId INT,
--     @DrugCode INT,
--     @PatientId INT,
--     @Dosage NVARCHAR(255),
--     @Date DATE,
--     @Time TIME
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.DrugAdministrations
--         (NurseId, DrugCode, PatientId, Dosage, [DATE], [Time])
--     VALUES
--         (@NurseId, @DrugCode, @PatientId, @Dosage, @Date, @Time);
-- END;
-- GO


-- /* ============================================================
--    Q19 — Update Patient Information
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.UpdatePatient
--     @PatientId INT,
--     @Name NVARCHAR(255),
--     @DOB DATE,
--     @WardId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     UPDATE dbo.Patients
--     SET
--         Name = @Name,
--         DOB = @DOB,
--         WardId = @WardId
--     WHERE Id = @PatientId;
-- END;
-- GO


-- /* ============================================================
--    Q20 — Update Consultant Salary
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.UpdateConsultantSalary
--     @ConsultantId INT,
--     @NewSalary DECIMAL(18,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     UPDATE dbo.Consultants
--     SET Salary = @NewSalary
--     WHERE Id = @ConsultantId;
-- END;
-- GO


-- /* ============================================================
--    Q21 — Increase Nurse Salary by Percentage
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.IncreaseNurseSalary
--     @NurseNumber INT,
--     @Percentage DECIMAL(5,2)
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     UPDATE dbo.Nurses
--     SET Salary = Salary + (Salary * @Percentage / 100.0)
--     WHERE Number = @NurseNumber;
-- END;
-- GO


-- /* ============================================================
--    Q22 — Delete a Patient
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.DeletePatient
--     @PatientId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DELETE FROM dbo.Patients
--     WHERE Id = @PatientId;
-- END;
-- GO


-- /* ============================================================
--    Q23 — Delete a Consultant
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.DeleteConsultant
--     @ConsultantId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DELETE FROM dbo.Consultants
--     WHERE Id = @ConsultantId;
-- END;
-- GO


-- /* ============================================================
--    Q24 — Delete Medication Administration

--    DrugAdministrations has no single ID, so use identifying
--    columns.
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.DeleteMedicationAdministration
--     @NurseId INT,
--     @DrugCode INT,
--     @PatientId INT,
--     @Date DATE,
--     @Time TIME
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DELETE FROM dbo.DrugAdministrations
--     WHERE NurseId = @NurseId
--       AND DrugCode = @DrugCode
--       AND PatientId = @PatientId
--       AND [DATE] = @Date
--       AND [Time] = @Time;
-- END;
-- GO


-- /* ============================================================
--    Q25 — Store All Patients Returned by Procedure
--    ============================================================ */

-- IF OBJECT_ID('dbo.StoredPatients', 'U') IS NOT NULL
--     DROP TABLE dbo.StoredPatients;
-- GO

-- CREATE TABLE dbo.StoredPatients
-- (
--     Id INT,
--     Name NVARCHAR(255),
--     DOB DATE,
--     WardId INT NULL
-- );
-- GO

-- INSERT INTO dbo.StoredPatients
-- EXEC dbo.GetAllPatients;
-- GO

-- SELECT * FROM dbo.StoredPatients;
-- GO


-- /* ============================================================
--    Q26 — Store High-Salary Consultants
--    ============================================================ */

-- IF OBJECT_ID('dbo.HighSalaryConsultantsSP', 'U') IS NOT NULL
--     DROP TABLE dbo.HighSalaryConsultantsSP;
-- GO

-- CREATE TABLE dbo.HighSalaryConsultantsSP
-- (
--     Id INT,
--     Name NVARCHAR(255),
--     Salary DECIMAL(18,2)
-- );
-- GO

-- INSERT INTO dbo.HighSalaryConsultantsSP
-- EXEC dbo.GetConsultantsByMinimumSalary
--     @MinimumSalary = 50000;
-- GO

-- SELECT * FROM dbo.HighSalaryConsultantsSP;
-- GO


-- /* ============================================================
--    Q27 — Store Patients from Specific Ward
--    ============================================================ */

-- IF OBJECT_ID('dbo.WardPatientsSP', 'U') IS NOT NULL
--     DROP TABLE dbo.WardPatientsSP;
-- GO

-- CREATE TABLE dbo.WardPatientsSP
-- (
--     Id INT,
--     Name NVARCHAR(255),
--     DOB DATE,
--     WardId INT
-- );
-- GO

-- INSERT INTO dbo.WardPatientsSP
-- EXEC dbo.GetPatientsByWard @WardId = 1;
-- GO

-- SELECT * FROM dbo.WardPatientsSP;
-- GO


-- /* ============================================================
--    Q28 — Create Patient Audit Table
--    ============================================================ */

-- IF OBJECT_ID('dbo.PatientAudit', 'U') IS NULL
-- BEGIN
--     CREATE TABLE dbo.PatientAudit
--     (
--         AuditId INT IDENTITY(1,1) PRIMARY KEY,
--         PatientId INT,
--         PatientName NVARCHAR(255),
--         DOB DATE,
--         WardId INT NULL,
--         OperationType NVARCHAR(20),
--         OperationDate DATETIME2 DEFAULT SYSDATETIME()
--     );
-- END;
-- GO


-- /* ============================================================
--    Q29 — AFTER INSERT Patient Audit Trigger
--    Handles multiple inserted rows.
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_AfterInsert_Audit
-- ON dbo.Patients
-- AFTER INSERT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.PatientAudit
--         (PatientId, PatientName, DOB, WardId,
--          OperationType, OperationDate)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId,
--         'INSERT',
--         SYSDATETIME()
--     FROM inserted;
-- END;
-- GO


-- /* ============================================================
--    Q30 — Audit Consultant Salary Changes
--    ============================================================ */

-- IF OBJECT_ID('dbo.ConsultantSalaryAudit', 'U') IS NULL
-- BEGIN
--     CREATE TABLE dbo.ConsultantSalaryAudit
--     (
--         AuditId INT IDENTITY(1,1) PRIMARY KEY,
--         ConsultantId INT,
--         OldSalary DECIMAL(18,2),
--         NewSalary DECIMAL(18,2),
--         ChangeDate DATETIME2 DEFAULT SYSDATETIME()
--     );
-- END;
-- GO

-- CREATE OR ALTER TRIGGER dbo.trg_Consultants_SalaryAudit
-- ON dbo.Consultants
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.ConsultantSalaryAudit
--         (ConsultantId, OldSalary, NewSalary, ChangeDate)
--     SELECT
--         i.Id,
--         d.Salary,
--         i.Salary,
--         SYSDATETIME()
--     FROM inserted i
--     INNER JOIN deleted d
--         ON i.Id = d.Id
--     WHERE
--         i.Salary <> d.Salary
--         OR (i.Salary IS NULL AND d.Salary IS NOT NULL)
--         OR (i.Salary IS NOT NULL AND d.Salary IS NULL);
-- END;
-- GO


-- /* ============================================================
--    Q31 — Audit Patient Ward Changes
--    ============================================================ */

-- IF OBJECT_ID('dbo.PatientWardAudit', 'U') IS NULL
-- BEGIN
--     CREATE TABLE dbo.PatientWardAudit
--     (
--         AuditId INT IDENTITY(1,1) PRIMARY KEY,
--         PatientId INT,
--         OldWardId INT NULL,
--         NewWardId INT NULL,
--         ChangeDate DATETIME2 DEFAULT SYSDATETIME()
--     );
-- END;
-- GO

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_WardAudit
-- ON dbo.Patients
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.PatientWardAudit
--         (PatientId, OldWardId, NewWardId, ChangeDate)
--     SELECT
--         i.Id,
--         d.WardId,
--         i.WardId,
--         SYSDATETIME()
--     FROM inserted i
--     INNER JOIN deleted d
--         ON i.Id = d.Id
--     WHERE
--         i.WardId <> d.WardId
--         OR (i.WardId IS NULL AND d.WardId IS NOT NULL)
--         OR (i.WardId IS NOT NULL AND d.WardId IS NULL);
-- END;
-- GO


-- /* ============================================================
--    Q32 — Archive Deleted Patients
--    ============================================================ */

-- IF OBJECT_ID('dbo.DeletedPatients', 'U') IS NULL
-- BEGIN
--     CREATE TABLE dbo.DeletedPatients
--     (
--         ArchiveId INT IDENTITY(1,1) PRIMARY KEY,
--         PatientId INT,
--         Name NVARCHAR(255),
--         DOB DATE,
--         WardId INT NULL,
--         DeletedAt DATETIME2 DEFAULT SYSDATETIME()
--     );
-- END;
-- GO

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_AfterDelete_Archive
-- ON dbo.Patients
-- AFTER DELETE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.DeletedPatients
--         (PatientId, Name, DOB, WardId, DeletedAt)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId,
--         SYSDATETIME()
--     FROM deleted;
-- END;
-- GO


-- /* ============================================================
--    Q33 — Audit Deleted Consultants
--    ============================================================ */

-- IF OBJECT_ID('dbo.DeletedConsultants', 'U') IS NULL
-- BEGIN
--     CREATE TABLE dbo.DeletedConsultants
--     (
--         AuditId INT IDENTITY(1,1) PRIMARY KEY,
--         ConsultantId INT,
--         Name NVARCHAR(255),
--         Salary DECIMAL(18,2),
--         DeletedAt DATETIME2 DEFAULT SYSDATETIME()
--     );
-- END;
-- GO

-- CREATE OR ALTER TRIGGER dbo.trg_Consultants_AfterDelete_Audit
-- ON dbo.Consultants
-- AFTER DELETE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.DeletedConsultants
--         (ConsultantId, Name, Salary, DeletedAt)
--     SELECT
--         Id,
--         Name,
--         Salary,
--         SYSDATETIME()
--     FROM deleted;
-- END;
-- GO


-- /* ============================================================
--    Q34 — Compare Old and New Consultant Salary
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Consultants_DisplaySalaryChange
-- ON dbo.Consultants
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT
--         i.Id AS ConsultantId,
--         i.Name AS ConsultantName,
--         d.Salary AS OldSalary,
--         i.Salary AS NewSalary
--     FROM inserted i
--     INNER JOIN deleted d
--         ON i.Id = d.Id
--     WHERE
--         i.Salary <> d.Salary
--         OR (i.Salary IS NULL AND d.Salary IS NOT NULL)
--         OR (i.Salary IS NOT NULL AND d.Salary IS NULL);
-- END;
-- GO


-- /* ============================================================
--    Q35 — Compare Old and New Patient Ward
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_DisplayWardChange
-- ON dbo.Patients
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT
--         i.Id AS PatientId,
--         i.Name AS PatientName,
--         d.WardId AS OldWardId,
--         i.WardId AS NewWardId
--     FROM inserted i
--     INNER JOIN deleted d
--         ON i.Id = d.Id
--     WHERE
--         i.WardId <> d.WardId
--         OR (i.WardId IS NULL AND d.WardId IS NOT NULL)
--         OR (i.WardId IS NOT NULL AND d.WardId IS NULL);
-- END;
-- GO


-- /* ============================================================
--    Q36 — Handle Multiple Inserted Rows

--    The Q29 trigger already uses "FROM inserted" and therefore
--    handles all rows inserted by one statement.

--    Test with three patients.
--    ============================================================ */

-- -- Use valid WardIds from your database before running.
-- -- Example only:


-- INSERT INTO dbo.Patients (Id, Name, DOB, WardId)
-- VALUES
--     (9001, 'Test Patient 1', '2000-01-01', 1),
--     (9002, 'Test Patient 2', '2001-02-02', 1),
--     (9003, 'Test Patient 3', '2002-03-03', 2);

-- SELECT *
-- FROM dbo.PatientAudit
-- WHERE PatientId IN (9001, 9002, 9003);
-- GO


/* ============================================================
   IMPORTANT FOR Q37-Q38

   SQL Server permits one INSTEAD OF INSERT trigger on Patients.

   Therefore Q37 and Q38 are shown as separate exercises.
   Do NOT enable both simultaneously.
   ============================================================ */


/* ============================================================
   Q37 — Prevent Patients Without a Ward
   ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_RequireWard
-- ON dbo.Patients
-- INSTEAD OF INSERT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     IF EXISTS
--     (
--         SELECT 1
--         FROM inserted
--         WHERE WardId IS NULL
--     )
--     BEGIN
--         THROW 50010, 'Patient must be assigned to a ward.', 1;
--     END;

--     INSERT INTO dbo.Patients (Id, Name, DOB, WardId)
--     SELECT Id, Name, DOB, WardId
--     FROM inserted;
-- END;
-- GO


/* ============================================================
   Q38 — Validate Patient Date of Birth

   Q37 must be removed first because both are
   INSTEAD OF INSERT triggers.
   ============================================================ */


-- DROP TRIGGER dbo.trg_Patients_RequireWard;
-- GO

-- CREATE TRIGGER dbo.trg_Patients_ValidateDOB
-- ON dbo.Patients
-- INSTEAD OF INSERT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     IF EXISTS
--     (
--         SELECT 1
--         FROM inserted
--         WHERE DOB > CAST(GETDATE() AS DATE)
--     )
--     BEGIN
--         THROW 50011, 'Patient date of birth cannot be in the future.', 1;
--     END;

--     INSERT INTO dbo.Patients (Id, Name, DOB, WardId)
--     SELECT Id, Name, DOB, WardId
--     FROM inserted;
-- END;
-- GO


-- /* ============================================================
--    Q39 — Prevent Consultant Salary Reduction
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Consultants_PreventSalaryReduction
-- ON dbo.Consultants
-- INSTEAD OF UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     IF EXISTS
--     (
--         SELECT 1
--         FROM inserted i
--         INNER JOIN deleted d
--             ON i.Id = d.Id
--         WHERE i.Salary < d.Salary
--     )
--     BEGIN
--         THROW 50012, 'Consultant salary cannot be reduced.', 1;
--     END;

--     UPDATE c
--     SET
--         c.Name = i.Name,
--         c.Salary = i.Salary
--     FROM dbo.Consultants c
--     INNER JOIN inserted i
--         ON c.Id = i.Id;
-- END;
-- GO


-- /* ============================================================
--    Q40 — Control Patient Updates

--    This is an ALTERNATIVE INSTEAD OF UPDATE exercise.
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_ControlUpdate
-- ON dbo.Patients
-- INSTEAD OF UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     IF UPDATE(Id)
--     BEGIN
--         THROW 50013, 'Patient ID cannot be changed.', 1;
--     END;

--     UPDATE p
--     SET
--         p.Name = i.Name,
--         p.DOB = i.DOB,
--         p.WardId = i.WardId
--     FROM dbo.Patients p
--     INNER JOIN inserted i
--         ON p.Id = i.Id;
-- END;
-- GO


-- /* ============================================================
--    IMPORTANT FOR Q41-Q42

--    Both require INSTEAD OF DELETE on Patients.
--    Treat them as alternative exercises.
--    ============================================================ */


-- /* ============================================================
--    Q41 — Prevent Patient Deletion
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_PreventDelete
-- ON dbo.Patients
-- INSTEAD OF DELETE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     THROW 50014, 'Direct patient deletion is not allowed.', 1;
-- END;
-- GO


-- /* ============================================================
--    Q42 — Archive Before Delete

--    Run this after dropping Q41's trigger.
--    ============================================================ */


-- DROP TRIGGER dbo.trg_Patients_PreventDelete;
-- GO

-- CREATE TRIGGER dbo.trg_Patients_ArchiveBeforeDelete
-- ON dbo.Patients
-- INSTEAD OF DELETE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.DeletedPatients
--         (PatientId, Name, DOB, WardId, DeletedAt)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId,
--         SYSDATETIME()
--     FROM deleted;

--     DELETE p
--     FROM dbo.Patients p
--     INNER JOIN deleted d
--         ON p.Id = d.Id;
-- END;
-- GO



/* ============================================================
   Q43 — Add Patient with Audit Trigger

   dbo.AddPatient already exists from Q16.
   PatientAudit trigger already exists from Q29.

   Example execution:
   ============================================================ */


-- EXEC dbo.AddPatient
--     @Id = 9100,
--     @Name = 'Audit Test Patient',
--     @DOB = '2000-05-10',
--     @WardId = 1;

-- SELECT *
-- FROM dbo.PatientAudit
-- WHERE PatientId = 9100;

-- GO


-- /* ============================================================
--    Q44 — Update Consultant with Salary Audit

--    dbo.UpdateConsultantSalary exists from Q20.
--    Salary audit trigger exists from Q30.
--    ============================================================ */


-- EXEC dbo.UpdateConsultantSalary
--     @ConsultantId = 1,
--     @NewSalary = 65000;

-- SELECT *
-- FROM dbo.ConsultantSalaryAudit
-- WHERE ConsultantId = 1;

-- GO


-- /* ============================================================
--    Q45 — Delete Patient and Archive Record

--    Uses DeletePatient + deleted patient archive trigger.

--    IMPORTANT:
--    Q41 PreventDelete must NOT be active when testing this.
--    ============================================================ */


-- EXEC dbo.DeletePatient @PatientId = 9100;

-- SELECT *
-- FROM dbo.DeletedPatients
-- WHERE PatientId = 9100;

-- GO


-- /* ============================================================
--    Q46 — TRY-CATCH + TRANSACTION

--    Update patient's ward and insert medication administration.
--    Roll back both operations if either fails.
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.UpdateWardAndAddMedication
--     @PatientId INT,
--     @NewWardId INT,
--     @NurseId INT,
--     @DrugCode INT,
--     @Dosage NVARCHAR(255),
--     @Date DATE,
--     @Time TIME
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     SET XACT_ABORT ON;

--     BEGIN TRY

--         BEGIN TRANSACTION;

--         UPDATE dbo.Patients
--         SET WardId = @NewWardId
--         WHERE Id = @PatientId;

--         IF @@ROWCOUNT = 0
--             THROW 50020, 'Patient not found.', 1;

--         INSERT INTO dbo.DrugAdministrations
--             (NurseId, DrugCode, PatientId,
--              Dosage, [DATE], [Time])
--         VALUES
--             (@NurseId, @DrugCode, @PatientId,
--              @Dosage, @Date, @Time);

--         COMMIT TRANSACTION;

--     END TRY
--     BEGIN CATCH

--         IF XACT_STATE() <> 0
--             ROLLBACK TRANSACTION;

--         THROW;

--     END CATCH;
-- END;
-- GO


-- /* ============================================================
--    Q47 — Complete Patient Modification Audit System

--    PatientAudit was created in Q28.
--    Q29 already handles INSERT.

--    Add UPDATE and DELETE audit triggers.
--    ============================================================ */

-- CREATE OR ALTER TRIGGER dbo.trg_Patients_AfterUpdate_Audit
-- ON dbo.Patients
-- AFTER UPDATE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.PatientAudit
--         (PatientId, PatientName, DOB, WardId,
--          OperationType, OperationDate)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId,
--         'UPDATE',
--         SYSDATETIME()
--     FROM inserted;
-- END;
-- GO


-- CREATE OR ALTER TRIGGER dbo.trg_Patients_AfterDelete_Audit
-- ON dbo.Patients
-- AFTER DELETE
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     INSERT INTO dbo.PatientAudit
--         (PatientId, PatientName, DOB, WardId,
--          OperationType, OperationDate)
--     SELECT
--         Id,
--         Name,
--         DOB,
--         WardId,
--         'DELETE',
--         SYSDATETIME()
--     FROM deleted;
-- END;
-- GO


-- /* ============================================================
--    Q48 — Stored Procedure Returning Multiple Statistics
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetHospitalStatistics
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     SELECT
--         (SELECT COUNT(*)
--          FROM dbo.Patients)
--             AS TotalPatients,

--         (SELECT COUNT(*)
--          FROM dbo.Consultants)
--             AS TotalConsultants,

--         (SELECT AVG(Salary)
--          FROM dbo.Consultants)
--             AS AverageConsultantSalary,

--         (
--             SELECT
--                 COALESCE(
--                     SUM(
--                         TRY_CAST(
--                             LEFT(
--                                 Dosage,
--                                 CHARINDEX(' ', Dosage + ' ') - 1
--                             )
--                             AS INT
--                         )
--                     ),
--                     0
--                 )
--             FROM dbo.DrugAdministrations
--         ) AS TotalMedicationQuantity;
-- END;
-- GO


-- /* ============================================================
--    Q49 — OUTPUT + TRY-CATCH
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientMedicationQuantitySafe
--     @PatientId INT,
--     @TotalQuantity INT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     BEGIN TRY

--         IF NOT EXISTS
--         (
--             SELECT 1
--             FROM dbo.Patients
--             WHERE Id = @PatientId
--         )
--         BEGIN
--             THROW 50030, 'Patient not found.', 1;
--         END;

--         SELECT
--             @TotalQuantity =
--                 COALESCE(
--                     SUM(
--                         TRY_CAST(
--                             LEFT(
--                                 Dosage,
--                                 CHARINDEX(' ', Dosage + ' ') - 1
--                             )
--                             AS INT
--                         )
--                     ),
--                     0
--                 )
--         FROM dbo.DrugAdministrations
--         WHERE PatientId = @PatientId;

--     END TRY
--     BEGIN CATCH

--         SET @TotalQuantity = NULL;
--         THROW;

--     END CATCH;
-- END;
-- GO


-- /* ============================================================
--    Q50 — Final Hospital Patient Summary
--    ============================================================ */

-- CREATE OR ALTER PROCEDURE dbo.GetPatientSummary
--     @PatientId INT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     BEGIN TRY

--         IF NOT EXISTS
--         (
--             SELECT 1
--             FROM dbo.Patients
--             WHERE Id = @PatientId
--         )
--         BEGIN
--             THROW 50040, 'Patient not found.', 1;
--         END;

--         SELECT
--             p.Id AS PatientId,
--             p.Name AS PatientName,
--             p.DOB,
--             p.WardId,
--             w.Name AS WardName,

--             COUNT(da.PatientId)
--                 AS MedicationAdministrationCount,

--             COALESCE(
--                 SUM(
--                     TRY_CAST(
--                         LEFT(
--                             da.Dosage,
--                             CHARINDEX(' ', da.Dosage + ' ') - 1
--                         )
--                         AS INT
--                     )
--                 ),
--                 0
--             ) AS TotalMedicationQuantity

--         FROM dbo.Patients p

--         LEFT JOIN dbo.Wards w
--             ON p.WardId = w.Id

--         LEFT JOIN dbo.DrugAdministrations da
--             ON p.Id = da.PatientId

--         WHERE p.Id = @PatientId

--         GROUP BY
--             p.Id,
--             p.Name,
--             p.DOB,
--             p.WardId,
--             w.Name;

--     END TRY
--     BEGIN CATCH

--         THROW;

--     END CATCH;
-- END;
-- GO