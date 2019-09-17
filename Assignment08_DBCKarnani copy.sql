--**********************************************************************************************--
-- Title: Assigment08 - Milestone 02
-- Author: Chandrashree Karnani
-- Desc: This file demonstrates how to design and create
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2019-05-28,Chandrashree Karnani,Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'PatientAppointmentsDB_CKarnani')
	 Begin 
	  Alter Database [PatientAppointmentsDB_CKarnani] Set Single_user With Rollback Immediate;
	  Drop Database PatientAppointmentsDB_CKarnani;
	 End
	Create Database PatientAppointmentsDB_CKarnani;
End Try
Begin Catch
	Print Error_Number();
End Catch
Go
Use PatientAppointmentsDB_CKarnani;

/**************************************************************************************************/
-- Create Tables --  

-- Create table for Clinics 
Create Table Clinics(
	ClinicID int identity(1,1) not null,
	ClinicName nvarchar(100) not null,
	ClinicPhoneNumber nvarchar(100) not null,
	ClinicAddress nvarchar(100) not null,
	ClinicCity nvarchar(100) not null,
	ClinicState nchar(2) not null,
	ClinicZipCode nvarchar(10) not null
);
Go

-- Create table for Patients
Create Table Patients(
	PatientID int identity(1,1) not null,
	PatientFirstName nvarchar(100) not null,
	PatientLastName nvarchar(100) not null,
	PatientPhoneNumber nvarchar(100) not null,
	PatientAddress nvarchar(100) not null,
	PatientCity nvarchar(100) not null,
	PatientState nchar(2) not null,
	PatientZipCode nvarchar(10) not null
);
Go

-- Create table for Doctors 
Create Table Doctors(
	DoctorID int identity(1,1) not null,
	DoctorFirstName nvarchar(100) not null,
	DoctorLastName nvarchar(100) not null,
	DoctorPhoneNumber nvarchar(100) not null,
	DoctorAddress nvarchar(100) not null,
	DoctorCity nvarchar(100) not null,
	DoctorState nchar(2) not null,
	DoctorZipCode nvarchar(10) not null
);
Go

--Create table for Appointments
Create Table Appointments(
	AppointmentID int identity(1,1) not null,
	AppointmentDateTime datetime not null,
	AppointmentPatientID int not null,
	AppointmentDoctorID int not null,
	AppointmentClinicID int not null
);
Go

 /**************************************************************************************************/
-- Add Constraints -- 

-- Add primary key constraint
Alter Table Clinics 
 Add Constraint pkClinics
  Primary Key (ClinicID);
Go

-- Add unique constraint
Alter Table Clinics 
 Add Constraint ukClinicName 
  Unique (ClinicName);
Go

-- Add check constraint
Alter Table Clinics 
 Add Constraint ckClinicPhoneNumber
  Check (ClinicPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

-- Add check constraint
Alter Table Clinics 
 Add Constraint ckClinicZipCode 
  Check (ClinicZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or ClinicZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go 

-- Add primary key constraint
Alter Table Patients 
 Add Constraint pkPatients
  Primary Key (PatientID);
Go

-- Add check constraint
Alter Table Patients
 Add Constraint ckPatientPhoneNumber
  Check (PatientPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

-- Add check constraint 
Alter Table Patients
 Add Constraint ckPatientZipCode
  Check (PatientZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or PatientZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go 

-- Add primary key constraint
Alter Table Doctors
 Add Constraint pkDoctors
  Primary Key (DoctorID);
Go

-- Add check constraint 
Alter Table Doctors
 Add Constraint ckDoctorPhoneNumber
  Check (DoctorPhoneNumber Like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

-- Add check constraint
Alter Table Doctors
 Add Constraint ckDoctorZipCode
  Check (DoctorZipCode Like '[0-9][0-9][0-9][0-9][0-9]' Or DoctorZipCode Like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go 

-- Add primary key constraint 
Alter Table Appointments
 Add Constraint pkAppointments
  Primary Key (AppointmentID);
Go

-- Add foreign key constraint
Alter Table Appointments 
 Add Constraint fkAppointmentsToPatients
  Foreign Key (AppointmentPatientID) References Patients(PatientID);
Go 

-- Add foreign key constraint
Alter Table Appointments 
 Add Constraint fkAppointmentsToDoctors
  Foreign Key (AppointmentDoctorID) References Doctors(DoctorID);
Go 

-- Add foreign key constraint
Alter Table Appointments 
 Add Constraint fkAppointmentsToClinics
  Foreign Key (AppointmentClinicID) References Clinics(ClinicID);
Go 

/**************************************************************************************************/
-- Add Views (Module 03 and 04) -- 

-- Create view for clinics table
Create View dbo.vClinics As 
Select ClinicID, 
ClinicName,
ClinicPhoneNumber,
ClinicAddress,
ClinicCity, 
ClinicState, 
ClinicZipCode
From Clinics;
Go

--Create view for patients table
Create View dbo.vPatients As 
Select PatientID,
PatientFirstName,
PatientLastName,
PatientPhoneNumber,
PatientAddress,
PatientCity,
PatientState,
PatientZipCode
From Patients; 
Go 

-- Create view for doctors table
Create View dbo.vDoctors As 
Select DoctorID,
DoctorFirstName,
DoctorLastName,
DoctorPhoneNumber,
DoctorAddress,
DoctorCity,
DoctorState,
DoctorZipCode
From Doctors; 
Go 

-- Create view for appointments table
Create View dbo.vAppointments As 
Select AppointmentID,
AppointmentDateTime,
AppointmentPatientID,
AppointmentDoctorID,
AppointmentClinicID
From Appointments;
Go 

-- Create a reporting view that combines data from all the tables 
Create View dbo.vAppointmentsByPatientsDoctorsAndClinics As 
Select A.AppointmentID,
format(A.AppointmentDateTime, 'MM/DD/YYYY') As [A.AppointmentDate],
format(A.AppointmentDateTime, 'HH:MM') As [A.AppointmentTime],
P.PatientID,
P.PatientFirstName + ' ' + P.PatientLastName As [P.PatientName],
P.PatientPhoneNumber, 
P.PatientAddress,
P.PatientCity,
P.PatientState,
P.PatientZipCode,
D.DoctorID,
D.DoctorFirstName + ' ' + D.DoctorLastName As [D.DoctorName], 
D.DoctorPhoneNumber, 
D.DoctorAddress,
D.DoctorCity,
D.DoctorState,
D.DoctorZipCode,
C.ClinicID,
C.ClinicName,
C.ClinicPhoneNumber,
C.ClinicAddress,
C.ClinicCity,
C.ClinicState,
C.ClinicZipCode
From Appointments As A 
Join Patients As P On A.AppointmentPatientID = P.PatientID
Join Doctors As D On A.AppointmentDoctorID = D.DoctorID
Join Clinics As C On A.AppointmentClinicID = C.ClinicID
Go 

/**************************************************************************************************/
-- Add Stored Procedures --

Create Procedure pInsClinics
(@ClinicName nvarchar(100), @ClinicPhoneNumber nvarchar(100), @ClinicAddress nvarchar(100), @ClinicCity nvarchar(100), @ClinicState nchar(2), @ClinicZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes insertion of data in the Clinics table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode)
   Values (@ClinicName, @ClinicPhoneNumber, @ClinicAddress, @ClinicCity, @ClinicState, @ClinicZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsPatients
(@PatientFirstName nvarchar(100), @PatientLastName nvarchar(100), @PatientPhoneNumber nvarchar(100), @PatientAddress nvarchar(100), @PatientCity nvarchar(100), @PatientState nchar(2), @PatientZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes insertion of data in the Patients table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode)
   Values (@PatientFirstName, @PatientLastName, @PatientPhoneNumber, @PatientAddress, @PatientCity, @PatientState, @PatientZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsDoctors
(@DoctorFirstName nvarchar(100), @DoctorLastName nvarchar(100), @DoctorPhoneNumber nvarchar(100), @DoctorAddress nvarchar(100), @DoctorCity nvarchar(100), @DoctorState nchar(2), @DoctorZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes insertion of data in the Doctors table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode)
   Values (@DoctorFirstName, @DoctorLastName, @DoctorPhoneNumber, @DoctorAddress, @DoctorCity, @DoctorState, @DoctorZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pInsAppointments
(@AppointmentDateTime datetime, @AppointmentPatientID int, @AppointmentDoctorID int, @AppointmentClinicID int)
/* Author: Chandrashree Karnani 
** Desc: Processes insertion of data in the Appointments table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID)
   Values (@AppointmentDateTime, @AppointmentPatientID, @AppointmentDoctorID, @AppointmentClinicID)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdClinics
(@ClinicID int, @ClinicName nvarchar(100), @ClinicPhoneNumber nvarchar(100), @ClinicAddress nvarchar(100), @ClinicCity nvarchar(100), @ClinicState nchar(2), @ClinicZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes updating of data in the Clinics table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Update Clinics 
   Set ClinicName = @ClinicName,
   ClinicPhoneNumber = @ClinicPhoneNumber, 
   ClinicAddress = @ClinicAddress, 
   ClinicCity = @ClinicCity, 
   ClinicState = @ClinicState,
   ClinicZipCode = @ClinicZipCode
   Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdPatients
(@PatientID int, @PatientFirstName nvarchar(100), @PatientLastName nvarchar(100), @PatientPhoneNumber nvarchar(100), @PatientAddress nvarchar(100), @PatientCity nvarchar(100), @PatientState nchar(2), @PatientZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes updating of data in the Patients table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Update Patients
   Set PatientFirstName = @PatientFirstName,
   PatientLastName = @PatientLastName,
   PatientPhoneNumber = @PatientPhoneNumber,
   PatientAddress = @PatientAddress, 
   PatientCity = @PatientCity, 
   PatientState = @PatientState,
   PatientZipCode = @PatientZipCode
   Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdDoctors
(@DoctorID int, @DoctorFirstName nvarchar(100), @DoctorLastName nvarchar(100), @DoctorPhoneNumber nvarchar(100), @DoctorAddress nvarchar(100), @DoctorCity nvarchar(100), @DoctorState nchar(2), @DoctorZipCode nvarchar(10))
/* Author: Chandrashree Karnani 
** Desc: Processes updating of data in the Doctors table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Update Doctors
   Set DoctorFirstName = @DoctorFirstName,
   DoctorLastName = @DoctorLastName,
   DoctorPhoneNumber = @DoctorPhoneNumber,
   DoctorAddress = @DoctorAddress, 
   DoctorCity = @DoctorCity, 
   DoctorState = @DoctorState,
   DoctorZipCode = @DoctorZipCode
   Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pUpdAppointments
(@AppointmentID int, @AppointmentDateTime datetime, @AppointmentPatientID int, @AppointmentDoctorID int, @AppointmentClinicID int)
/* Author: Chandrashree Karnani 
** Desc: Processes updating of data in the Appointments table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Update Appointments
   Set AppointmentDateTime = @AppointmentDateTime,
   AppointmentPatientID = @AppointmentPatientID,
   AppointmentDoctorID = @AppointmentDoctorID, 
   AppointmentClinicID = @AppointmentClinicID
   Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelClinics
(@ClinicID int)
/* Author: Chandrashree Karnani 
** Desc: Processes deletion of data in the Clinics table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Delete from Clinics
   Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelPatients
(@PatientID int)
/* Author: Chandrashree Karnani 
** Desc: Processes deletion of data in the Patients table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Delete from Patients
   Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelDoctors
(@DoctorID int)
/* Author: Chandrashree Karnani 
** Desc: Processes deletion of data in the Doctors table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Delete from Doctors
   Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

Create Procedure pDelAppointments
(@AppointmentID int)
/* Author: Chandrashree Karnani 
** Desc: Processes deletion of data in the Appointments table
** Change Log: When,Who,What
** 2019-05-28,Chandrashree Karnani,Created stored procedure.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   Delete from Appointments
   Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
Go

/**************************************************************************************************/
-- Set Permissions --

-- Set appropriate permissions for tables 
Deny Select, Insert, Update, Delete On Clinics To Public;
Deny Select, Insert, Update, Delete On Patients To Public;
Deny Select, Insert, Update, Delete On Doctors To Public;
Deny Select, Insert, Update, Delete On Appointments To Public;

-- Set appropriate permissions for views
Grant Select On vClinics To Public;
Grant Select On vPatients To Public;
Grant Select On vDoctors To Public;
Grant Select On vAppointmentsByPatientsDoctorsAndClinics To Public;

-- Set appropriate permissions for stored procedures 
Grant Execute On pInsClinics To Public;
Grant Execute On pInsPatients To Public;
Grant Execute On pInsDoctors To Public;
Grant Execute On pInsAppointments To Public;
Grant Execute On pUpdClinics To Public;
Grant Execute On pUpdPatients To Public;
Grant Execute On pUpdDoctors To Public;
Grant Execute On pUpdAppointments To Public;
Grant Execute On pDelClinics To Public;
Grant Execute On pDelPatients To Public;
Grant Execute On pDelDoctors To Public;
Grant Execute On pDelAppointments To Public;

/**************************************************************************************************/
--< Test Views and Sprocs >-- 

-- Testing code for insertion of data in the clinics table
Declare @Status int;
Exec @Status = pInsClinics @ClinicName = 'UW Clinic', @ClinicPhoneNumber = '206-525-7777', @ClinicAddress = '4915 25th Ave NE', @ClinicCity = 'Seattle', @ClinicState = 'WA', @ClinicZipCode = '98105'
Select Case @Status 
When +1 Then 'Insert was successful'
When -1 Then 'Insert Failed! Common Issues: Duplicate Data'
End As [Status]
Go 

-- Testing code for insertion of data in the patients table
Declare @Status int;
Exec @Status = pInsPatients @PatientFirstName = 'Amy', @PatientLastName = 'Jones', @PatientPhoneNumber = '206-979-0732', @PatientAddress = '3927 Adams Lane NE', @PatientCity = 'Seattle', @PatientState = 'WA', @PatientZipCode = '98105'
Select Case @Status 
When +1 Then 'Insert was successful'
When -1 Then 'Insert Failed! Common Issues: Duplicate Data'
End As [Status]
Go 

-- Testing code for insertion of data in the doctors table
Declare @Status int;
Exec @Status = pInsDoctors @DoctorFirstName = 'Ed', @DoctorLastName = 'West', @DoctorPhoneNumber = '206-999-0987', @DoctorAddress = '9801 Brooklyn Ave NE', @DoctorCity = 'Seattle', @DoctorState = 'WA', @DoctorZipCode = '98105'
Select Case @Status 
When +1 Then 'Insert was successful'
When -1 Then 'Insert Failed! Common Issues: Duplicate Data'
End As [Status]
Go 

-- Testing code for insertion of data in the appointments table
Declare @Status int;
Exec @Status = pInsAppointments @AppointmentDateTime = '05-10-2019 14:56', @AppointmentPatientID = 1, @AppointmentDoctorID = 1, @AppointmentClinicID = 1
Select Case @Status 
When +1 Then 'Insert was successful'
When -1 Then 'Insert Failed! Common Issues: Duplicate Data'
End As [Status]
Go 

-- Selecting from the views 
Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments

-- Testing code for updating of data in the clinics table
Declare @Status int;
Exec @Status = pUpdClinics @ClinicID = 1, @ClinicName = 'Faith Clinic', @ClinicPhoneNumber = '206-979-1614', @ClinicAddress = '3710 Melrose Ave', @ClinicCity = 'Seattle', @ClinicState = 'WA', @ClinicZipCode = '98105'
Select Case @Status 
When +1 Then 'Update was successful'
When -1 Then 'Update Failed! Common Issues: Duplicate Data or Foreign Key Violation'
End As [Status]
Go 

-- Testing code for updating of data in the patients table
Declare @Status int;
Exec @Status = pUpdPatients @PatientID = 1, @PatientFirstName = 'Macy', @PatientLastName = 'Larson', @PatientPhoneNumber = '510-888-6751', @PatientAddress = '3925 Brooklyn Lane NE', @PatientCity = 'Seattle', @PatientState = 'WA', @PatientZipCode = '98105'
Select Case @Status 
When +1 Then 'Update was successful'
When -1 Then 'Update Failed! Common Issues: Duplicate Data or Foreign Key Violation'
End As [Status]
Go 

-- Testing code for updating of data in the doctors table
Declare @Status int;
Exec @Status = pUpdDoctors @DoctorID = 1, @DoctorFirstName = 'Joe', @DoctorLastName = 'Jones', @DoctorPhoneNumber = '206-768-0981', @DoctorAddress = '12th Ave NE', @DoctorCity = 'Seattle', @DoctorState = 'WA', @DoctorZipCode = '98105'
Select Case @Status 
When +1 Then 'Update was successful'
When -1 Then 'Update Failed! Common Issues: Duplicate Data or Foreign Key Violation'
End As [Status]
Go 

-- Testing code for updating of data in the appointments table
Declare @Status int;
Exec @Status = pUpdAppointments  @AppointmentID = 1, @AppointmentDateTime = '06-13-2019 17:00', @AppointmentPatientID = 1, @AppointmentDoctorID = 1, @AppointmentClinicID = 1
Select Case @Status 
When +1 Then 'Update was successful'
When -1 Then 'Update Failed! Common Issues: Duplicate Data or Foreign Key Violation'
End As [Status]
Go 

-- Select from views 
Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments

-- Testing code for deletion of data in the appointments table
Declare @Status int;
Exec @Status = pDelAppointments @AppointmentID = 1
Select Case @Status 
When +1 Then 'Delete was successful'
When -1 Then 'Delete Failed! Common Issues: Foreign Key Violation'
End As [Status]
Go 

-- Testing code for deletion of data in the clinics table
Declare @Status int;
Exec @Status = pDelClinics @ClinicID = 1
Select Case @Status 
When +1 Then 'Delete was successful'
When -1 Then 'Delete Failed! Common Issues: Foreign Key Violation'
End As [Status]
Go 
-- Testing code for deletion of data in the doctors table
Declare @Status int;
Exec @Status = pDelDoctors @DoctorID = 1
Select Case @Status 
When +1 Then 'Delete was successful'
When -1 Then 'Delete Failed! Common Issues: Foreign Key Violation'
End As [Status]
Go 

-- Testing code for deletion of data in the patients table
Declare @Status int;
Exec @Status = pDelPatients @PatientID = 1
Select Case @Status 
When +1 Then 'Delete was successful'
When -1 Then 'Delete Failed! Common Issues: Foreign Key Violation'
End As [Status]
Go 

--Select from views 
Select * From vClinics
Select * From vPatients
Select * From vDoctors
Select * From vAppointments











