﻿--DROP DATABASE [ IF EXISTS ] { database_name | database_snapshot_name } [ ,...n ] [;]
IF EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'HalfTimeDB'
)
    BEGIN

	    -- Delete Database Backup and Restore History from MSDB System Database
    EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'HalfTimeDB'

    -- GO
    -- Close Connections
    USE [master]

    -- GO
    ALTER DATABASE [HalfTimeDB]

    SET SINGLE_USER
    WITH

    ROLLBACK IMMEDIATE

    -- GO
    -- Drop Database in SQL Server
    DROP DATABASE [HalfTimeDB]
-- GO
END

-- Create a new database called 'HalfTimeDB'
-- Connect to the 'master' database to run this snippet
USE master
GO

-- Create the new database if it does not exist already
IF NOT EXISTS (
        SELECT [name]
FROM sys.databases
WHERE [name] = N'HalfTimeDB'
        )
    CREATE DATABASE HalfTimeDB
GO

USE HalfTimeDB
GO

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/vgnBil
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
SET XACT_ABORT ON

BEGIN TRANSACTION HALFTIMEDB_CREATE

CREATE TABLE [User] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [FireBaseUid] nvarchar(255)  NULL ,
    [FirstName] nvarchar(255)  NOT NULL ,
    [LastName] nvarchar(255)  NOT NULL ,
    [Street] nvarchar(255)  NOT NULL ,
    [City] nvarchar(255)  NOT NULL ,
    [State] nvarchar(255)  NOT NULL ,
    [ZipCode] int  NOT NULL ,
    [PhoneNumber] nvarchar(255)  NOT NULL ,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [Student] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [FirstName] nvarchar(255)  NOT NULL ,
    [LastName] nvarchar(255)  NOT NULL ,
    [Street] nvarchar(255)  NOT NULL ,
    [City] nvarchar(255)  NOT NULL ,
    [State] nvarchar(255)  NOT NULL ,
    [ZipCode] int  NOT NULL ,
    [PhoneNumber] nvarchar(255)  NULL ,
    [Gender] nvarchar(255)  NULL ,
    [Size] nvarchar(255)  NULL ,
    [Grade] nvarchar(255)  NULL ,
	[Chair] nvarchar(255) NULL,
	[IsDeleted] BIT NULL ,
    CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [Event] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [Name] nvarchar(255)  NOT NULL ,
    [Description] nvarchar(255)  NOT NULL ,
    [Type] nvarchar(255)  NOT NULL ,
    [Date] dateTime  NOT NULL ,
    [Time] time(7)  NULL ,
    [Street] nvarchar(255)  NOT NULL ,
    [City] nvarchar(255)  NOT NULL ,
    [State] nvarchar(255)  NOT NULL ,
    [ZipCode] int  NOT NULL ,
	[IsDeleted] BIT NULL ,
    CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [Instrument] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [Name] nvarchar(255)  NOT NULL ,
    [Condition] nvarchar(255)  NOT NULL ,
    [Category] nvarchar(255)  NOT NULL ,
    [StudentId] int  NULL ,
    [DatePurchased] datetime  NULL ,
    [YearPurchased] int  NULL ,
    [Description] nvarchar(255)  NOT NULL ,
    [Quantity] int  NULL ,
    [Brand] nvarchar(255)  NOT NULL ,
    [ModelNumber] nvarchar(255)  NULL ,
    [AmountPaid] numeric(10,2)  NULL ,
    [EstimatedValue] numeric(10,2)  NULL ,
	[IsDeleted] BIT NULL ,
    CONSTRAINT [PK_Instrument] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [Uniform] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [Size] nvarchar(255)  NOT NULL ,
    [Condition] nvarchar(255)  NOT NULL ,
    [StudentId] int  NULL ,
    [DatePurchased] datetime  NULL ,
    [YearPurchased] int  NULL ,
	[IsDeleted] BIT NULL ,
    CONSTRAINT [PK_Uniform] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [Volunteer] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [FirstName] nvarchar(255)  NOT NULL ,
    [LastName] nvarchar(255)  NOT NULL ,
    [Street] nvarchar(255)  NOT NULL ,
    [City] nvarchar(255)  NOT NULL ,
    [State] nvarchar(255)  NOT NULL ,
    [ZipCode] int  NOT NULL ,
    [PhoneNumber] nvarchar(255)  NOT NULL ,
	[IsDeleted] BIT NULL ,
    CONSTRAINT [PK_Volunteer] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [UserStudentJoin] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [UserId] int  NOT NULL ,
    [StudentId] int  NOT NULL ,
    CONSTRAINT [PK_UserStudentJoin] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [UserEventJoin] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [UserId] int  NOT NULL ,
    [EventId] int  NOT NULL ,
    CONSTRAINT [PK_UserEventJoin] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [UserInstrumentJoin] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [UserId] int  NOT NULL ,
    [InstrumentId] int  NOT NULL ,
    CONSTRAINT [PK_UserInstrumentJoin] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [UserUniformJoin] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [UserId] int  NOT NULL ,
    [UniformId] int  NOT NULL ,
    CONSTRAINT [PK_UserUniformJoin] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

CREATE TABLE [UserVolunteerJoin] (
    [Id] int IDENTITY(1,1) NOT NULL ,
    [UserId] int  NOT NULL ,
    [VolunteerId] int  NOT NULL ,
    CONSTRAINT [PK_UserVolunteerJoin] PRIMARY KEY CLUSTERED (
        [Id] ASC
    )
)

ALTER TABLE [Instrument] WITH CHECK ADD CONSTRAINT [FK_Instrument_StudentId] FOREIGN KEY([StudentId])
REFERENCES [Student] ([Id])

ALTER TABLE [Instrument] CHECK CONSTRAINT [FK_Instrument_StudentId]

ALTER TABLE [Uniform] WITH CHECK ADD CONSTRAINT [FK_Uniform_StudentId] FOREIGN KEY([StudentId])
REFERENCES [Student] ([Id])

ALTER TABLE [Uniform] CHECK CONSTRAINT [FK_Uniform_StudentId]

ALTER TABLE [UserStudentJoin] WITH CHECK ADD CONSTRAINT [FK_UserStudentJoin_UserId] FOREIGN KEY([UserId])
REFERENCES [User] ([Id])

ALTER TABLE [UserStudentJoin] CHECK CONSTRAINT [FK_UserStudentJoin_UserId]

ALTER TABLE [UserStudentJoin] WITH CHECK ADD CONSTRAINT [FK_UserStudentJoin_StudentId] FOREIGN KEY([StudentId])
REFERENCES [Student] ([Id])

ALTER TABLE [UserStudentJoin] CHECK CONSTRAINT [FK_UserStudentJoin_StudentId]

ALTER TABLE [UserEventJoin] WITH CHECK ADD CONSTRAINT [FK_UserEventJoin_UserId] FOREIGN KEY([UserId])
REFERENCES [User] ([Id])

ALTER TABLE [UserEventJoin] CHECK CONSTRAINT [FK_UserEventJoin_UserId]

ALTER TABLE [UserEventJoin] WITH CHECK ADD CONSTRAINT [FK_UserEventJoin_EventId] FOREIGN KEY([EventId])
REFERENCES [Event] ([Id])

ALTER TABLE [UserEventJoin] CHECK CONSTRAINT [FK_UserEventJoin_EventId]

ALTER TABLE [UserInstrumentJoin] WITH CHECK ADD CONSTRAINT [FK_UserInstrumentJoin_UserId] FOREIGN KEY([UserId])
REFERENCES [User] ([Id])

ALTER TABLE [UserInstrumentJoin] CHECK CONSTRAINT [FK_UserInstrumentJoin_UserId]

ALTER TABLE [UserInstrumentJoin] WITH CHECK ADD CONSTRAINT [FK_UserInstrumentJoin_InstrumentId] FOREIGN KEY([InstrumentId])
REFERENCES [Instrument] ([Id])

ALTER TABLE [UserInstrumentJoin] CHECK CONSTRAINT [FK_UserInstrumentJoin_InstrumentId]

ALTER TABLE [UserUniformJoin] WITH CHECK ADD CONSTRAINT [FK_UserUniformJoin_UserId] FOREIGN KEY([UserId])
REFERENCES [User] ([Id])

ALTER TABLE [UserUniformJoin] CHECK CONSTRAINT [FK_UserUniformJoin_UserId]

ALTER TABLE [UserUniformJoin] WITH CHECK ADD CONSTRAINT [FK_UserUniformJoin_UniformId] FOREIGN KEY([UniformId])
REFERENCES [Uniform] ([Id])

ALTER TABLE [UserUniformJoin] CHECK CONSTRAINT [FK_UserUniformJoin_UniformId]

ALTER TABLE [UserVolunteerJoin] WITH CHECK ADD CONSTRAINT [FK_UserVolunteerJoin_UserId] FOREIGN KEY([UserId])
REFERENCES [User] ([Id])

ALTER TABLE [UserVolunteerJoin] CHECK CONSTRAINT [FK_UserVolunteerJoin_UserId]

ALTER TABLE [UserVolunteerJoin] WITH CHECK ADD CONSTRAINT [FK_UserVolunteerJoin_VolunteerId] FOREIGN KEY([VolunteerId])
REFERENCES [Volunteer] ([Id])

ALTER TABLE [UserVolunteerJoin] CHECK CONSTRAINT [FK_UserVolunteerJoin_VolunteerId]

COMMIT TRANSACTION HALFTIMEDB_CREATE

USE [master]
GO

ALTER DATABASE [HalfTimeDB]

SET READ_WRITE
GO

BEGIN TRANSACTION HALFTIMEDB_SEED

-- User
BEGIN
    USE [HalfTimeDB]
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('03985307-16c3-43e9-865e-843fd76ba7b6', 'Colin', 'White', '2206 Erin Ln', 'Nashville', 'TN', '37221', '+1 205 227 8229');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('03985307-16c3-43e9-865e-843fd76ba7b6', 'Volunteer', 'Account', 'Twilio Test', 'Nashville', 'TN', '37221', '+1 205 227 8229');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('03985307-16c3-43e9-865e-88a707eba7b3', 'Galina', 'Winterson', '991 Orin Junction', 'Worcester', 'MA', '01654', '+1 508 603 7117');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('89142645-4e81-4493-864b-923a5b2741c2', 'Phaidra', 'Egglestone', '9 Farwell Plaza', 'San Antonio', 'TX', '78225', '+1 210 447 3597');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('76834709-5524-4438-9daf-3fde09ab3a43', 'Giacomo', 'Abrahamson', '741 1st Hill', 'Colorado Springs', 'CO', '80925', '+1 719 192 4776');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('658be3d3-0f87-4ef2-bfd2-4ac6765e4062', 'Edithe', 'Batha', '3 Fremont Street', 'Charlotte', 'NC', '28205', '+1 704 682 3957');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('271df83d-4457-4530-9b26-4c80fec0a118', 'Miguelita', 'Rosenfelder', '6914 Summerview Drive', 'Sioux Falls', 'SD', '57193', '+1 605 597 9320');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('370930fa-c343-48bc-8bf1-074bd02938a5', 'Babb', 'Balsom', '033 Del Mar Park', 'Pittsburgh', 'PA', '15266', '+1  216 5989');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('a8850cd4-df06-4e0b-a39c-f3560bdd5ae4', 'Vanessa', 'Vannikov', '83 Gateway Point', 'Washington', 'DC', '20067', '+1 202 302 7907');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('0e9d6c82-4d11-4bb6-901e-c09df87e7d30', 'Lucita', 'Livzey', '85 Lunder Plaza', 'Chandler', 'AZ', '85246', '+1 480 345 6270');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('715751a1-73ce-45c1-8745-be7ab7ca460b', 'Kellyann', 'Basile', '09828 Cardinal Pass', 'Lexington', 'KY', '40524', '+1 859 347 8173');
	INSERT INTO [dbo].[User] ([FireBaseUid], [FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber]) VALUES ('b29f2691-e5d0-4277-a098-c5ecde58be66', 'Sheilah', 'Heintze', '58401 Hollow Ridge Road', 'Lexington', 'KY', '40546', '+1 859 721 9970');
	END

-- Event
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('UA vs. Duke', 'Chick-fil-a Classic', 'Sporting Event', '2019-08-31 02:30:00', '6:02', '1 AMB Dr NW', 'Atlanta', 'GA', '30313', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('Jazz Band Auditions', 'For basketball season', 'Auditions', '2019-09-04 07:30:00', '6:02', '810 2nd Ave', 'Tuscaloosa', 'AL', '35401', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('Wednesday Night Sectionals', 'Drumline excluded', 'Rehearsal', '2019-09-04 07:30:00', '6:02', '810 2nd Ave', 'Tuscaloosa', 'AL', '35401', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('Band of America', 'Exhibition performance', 'Competition', '2019-09-04 07:30:00', '6:02', '810 2nd Ave', 'Tuscaloosa', 'AL', '35401', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('New Mexico State', 'Home Opener', 'Sporting Event', '2019-09-07 03:00:00', '11:55', '920 Paul W Bryant Dr', 'Tuscaloosa', 'AL', '35401', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('@ South Carolina', 'First Away Game', 'Sporting Event', '2019-11-19 22:39:50', '15:25', '67693 Fairfield Point', 'Gainesville', 'FL', '32627', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('vs. Southern Miss', 'HS Band Day too', 'Sporting Event', '2019-09-22 21:18:25', '21:56', '594 Cody Way', 'New York City', 'NY', '10029', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('vs. Ole Miss', 'Joint National Anthem', 'Sporting Event', '2019-12-01 12:27:00', '7:33', '418 Shelley Parkway', 'Des Moines', 'IA', '50393', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('@ Texas A&M', 'Full Band Attending', 'Sporting Event', '2019-09-28 16:35:45', '7:08', '464 Sloan Drive', 'Indianapolis', 'IN', '46221', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('vs. Tennessee', 'Rivalry Game', 'Sporting Event', '2019-12-05 05:16:25', '4:01', '03143 Loftsgordon Trail', 'Jacksonville', 'FL', '32209', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('Homecoming Parade', '10 miles', 'Parade', '2019-12-04 14:41:12', '8:10', '506 Wayridge Court', 'Austin', 'TX', '78732', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('Homecoming Pep Rally', '@ The Quad and Library Steps', 'Community', '2019-09-05 11:37:19', '2:44', '45809 Hoffman Park', 'Shawnee Mission', 'KS', '66210', 0);
INSERT INTO [dbo].[Event] ([Name], [Description], [Type], [Date], [Time], [Street], [City], [State], [ZipCode], [IsDeleted]) VALUES ('vs. Arkansas', 'Homecoming Game', 'Sporting Event', '2019-10-08 14:51:46', '14:27', '6 Gale Junction', 'Dayton', 'OH', '45414', 0);
	END


-- Student
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Lorna', 'Mindenhall', '85 American Ash Trail', 'Saint Louis', 'MO', '63126', '+1 314 217 5982', 'Female', 'M', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Ellynn', 'Neillans', '60241 4th Trail', 'San Antonio', 'TX', '78265', '+1 210 729 1897', 'Female', 'XL', 'Sophomore', '3rd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Joellyn', 'Capon', '577 Moulton Hill', 'Richmond', 'VA', '23277', '+1 804 250 2442', 'Female', 'XS', 'Freshman', '5th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Garner', 'Leyshon', '781 Linden Junction', 'Boise', 'ID', '83757', '+1 208 407 5275', 'Male', 'XL', 'Junior', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Filberte', 'Saffe', '6 Ronald Regan Parkway', 'Littleton', 'CO', '80126', '+1 303 826 8855', 'Male', 'XL', 'Junior', '4th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Mariana', 'Rooze', '99 Schurz Alley', 'Honolulu', 'HI', '96845', '+1 808 636 2260', 'Female', 'XL', 'Sophomore', '3rd', 1);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Bald', 'Antoni', '7641 Sullivan Center', 'Dallas', 'TX', '75323', '+1 214 365 9091', 'Male', 'L', 'Junior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Penelopa', 'Rossoni', '38491 Mallory Circle', 'Reno', 'NV', '89550', '+1 775 934 5165', 'Female', '2XL', 'Freshman', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Jilleen', 'Huntley', '68 Mayer Road', 'Washington', 'DC', '20530', '+1 202 560 4034', 'Female', 'XL', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Howey', 'Swalteridge', '3 Quincy Plaza', 'Jackson', 'MS', '39204', '+1 601 258 4218', 'Male', 'M', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Wilmette', 'Geerling', '619 Fulton Point', 'Fairbanks', 'AK', '99709', '+1 907 361 7824', 'Female', '2XL', 'Junior', '5th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Taffy', 'Croney', '174 Ridge Oak Parkway', 'Tulsa', 'OK', '74141', '+1 918 280 4147', 'Female', '2XL', 'Sophomore', '3rd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Erin', 'Elce', '738 Fairfield Center', 'Cleveland', 'OH', '44111', '+1 216 406 1628', 'Female', 'XS', 'Freshman', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Farrell', 'Sowood', '473 Kedzie Hill', 'Madison', 'WI', '53785', '+1 608 210 8645', 'Male', 'XL', 'Freshman', '5th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Gussi', 'Rielly', '1154 Steensland Crossing', 'Billings', 'MT', '59105', '+1 406 382 2532', 'Female', 'S', 'Junior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Klarika', 'Fricker', '61 Onsgard Pass', 'Madison', 'WI', '53705', '+1 608 716 0311', 'Female', '3XL', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Rhianna', 'Blasetti', '18 Colorado Way', 'Brooklyn', 'NY', '11215', '+1 646 290 2774', 'Female', 'S', 'Junior', '3rd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Nikki', 'Blasius', '5 Clemons Plaza', 'Youngstown', 'OH', '44555', '+1 330 259 8030', 'Female', 'M', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Farra', 'Anyene', '4 Northport Center', 'Atlanta', 'GA', '30306', '+1 678 394 0065', 'Female', 'XS', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Glenden', 'Wanka', '65 Oxford Place', 'Des Moines', 'IA', '50305', '+1 515 153 3130', 'Male', 'L', 'Sophomore', '4th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Glen', 'Caruba', '65 Oxford Place', 'Des Moines', 'IA', '50305', '+1 205 153 3130', 'Female', 'XL', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Peter', 'Wolf', 'Holly Hill', 'Huntsville', 'AL', '77305', '+1 256 153 6540', 'Male', 'S', 'Freshman', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Colin', 'Wanka', '1245 Cindy Dr', 'Des Moines', 'IA', '50305', '+1 515 153 3130', 'Male', 'M', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Russ', 'Saunders', '6565 Lane', 'Pell City', 'AL', '50305', '+1 515 153 3130', 'Female', 'L', 'Freshman', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Brian', 'Wolf', '65 Oxford Place', 'Des Moines', 'IA', '50305', '+1 515 153 3730', 'Male', 'XXL', 'Junior', '3rd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Ben', 'Wanka', '4013 Park Place', 'Des Moines', 'IA', '50305', '+1 515 153 3130', 'Male', 'L', 'Sophomore', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Laura', 'Wanka', '65 Oxford Place', 'Des Moines', 'IA', '57605', '+1 515 153 3138', 'Male', 'S', 'Sophomore', '4th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Kim', 'Cervantez', '65 Oxford Place', 'Des Moines', 'IA', '50305', '+1 707 153 3130', 'Male', 'L', 'Junior', '5th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Lisa', 'Wanka', '65 Oxford Place', 'Birmingham', 'AL', '50305', '+1 515 153 3530', 'Male', 'S', 'Senior', '1st', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Ron', 'Read', '65 Oxford Place', 'Nashville', 'IA', '07305', '+1 515 153 3130', 'Male', 'M', 'Freshman', '5th', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Ray', 'Gonzales', '65 Oxford Place', 'Atlanta', 'GA', '50305', '+1 515 153 3540', 'Female', 'L', 'Sophomore', '2nd', 0);
INSERT INTO [dbo].[Student] ([FirstName], [LastName], [Street], [City], [State], [ZipCode], [PhoneNumber], [Gender], [Size], [Grade], [Chair], [IsDeleted]) VALUES ('Chris', 'Flatt', '65 Oxford Place', 'Cheatem', 'TN', '50305', '+1 515 153 3130', 'Male', 'L', 'Junior', '1st', 0);
	END

-- Instrument
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Tuba', 'Brand New', 'Brass', 7, 'Championship Series', 1, 'Adams', 'FFX1412M/C124', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Piccolo', 'Used', 'Woodwind', 1, 'Proline Series', 1, 'Pearl', 'MQ8300', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Clarinet', 'Brand New', 'Woodwind', 2, 'Competitor Series', 1, 'Yamaha', 'PMTM8456', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Saxophone', 'Brand New', 'Brass', 3, 'Student Series', 1, 'Jupiter', 'MS9300', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Trumpet', 'Brand New', 'Brass', 10, 'Championship Series', 1, 'Adams', 'DMP925', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Mellophone', 'Brand New', 'Brass', 4, 'Proline Series', 1, 'KHS America', 'FFXm1412M/C', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Trombone', 'Brand New', 'Brass', 5, 'Competitor Series', 1, 'Yamaha', 'TB800', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Baritone', 'Brand New', 'Brass', 6, 'Championship Series', 1, 'Adams', 'BB340', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Tuba', 'Brand New', 'Brass', 7, 'Flagship Series', 1, 'Adams', 'TB8250', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Brand New', 'Percussion', 8, 'Championship Series', 1, 'Pearl', '764', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Flute', 'Used', 'Percussion', 11, 'Competitor Series', 1, 'Yamaha', 'MW2414BX', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Brand New', 'Percussion', 12, 'Championship Series', 1, 'Mapex', 'RD2700', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Brass', 'Brand New', 'Percussion', 13, 'Competitor Series', 1, 'Dynasty', 'FFX1412M/C124', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Brand New', 'Percussion', 14, 'Competitor Series', 1, 'Adams', 'MDCG13', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Clarinet', 'Like New', 'Percussion', 15, 'Proline Series', 1, 'Conn-Selmer', '765RBE', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Brand New', 'Percussion', 16, 'Competitor Series', 1, 'Pearl', 'MUS1480', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Mallets', 'Used', 'Front Ensemble', 17, 'Proline Series', 1, 'Yamaha', 'FFX1412M/C103', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Brand New', 'Percussion', 18, 'Competitor Series', 1, 'Jupiter', 'RS525SC', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Trombone', 'Used', 'Percussion', 19, 'Flagship Series', 1, 'KHS', 'DC1465S', 0);
INSERT INTO [dbo].[Instrument] ([Name], [Condition], [Category], [StudentId], [Description], [Quantity], [Brand], [ModelNumber], [IsDeleted]) VALUES ('Snare Drum', 'Like New', 'Percussion', 20, 'Student Series', 1, 'Mapex', 'YMP204MS', 0);

	END

-- Uniform
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'New', 1, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'Like New', 2, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Double Extra Large', 'Used', 3, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'New', 4, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Medium', 'Like New', 5, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Double Extra Large', 'Used', 6, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'New', 7, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'Like New', 8, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'Used', 9, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'New', 10, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Small', 'Like New', 11, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Small', 'Used', 12, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Small', 'New', 13, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Triple Extra Large', 'Like New', 14, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'Used', 15, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Small', 'Used', 16, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'Like New', 17, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'Used', 18, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Double Extra Large', 'Like New', 19, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'Used', 20, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Medium', 'Like New', 21, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Small', 'Used', 22, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Double Extra Large', 'Used', 23, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Large', 'Like New', 24, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Medium', 'Like New', 25, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Triple Extra Large', 'New', 26, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Medium', 'Used', 27, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Extra Small', 'New', 28, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Double Extra Large', 'Like Used', 29, 0);
INSERT INTO [dbo].[Uniform] ([Size], [Condition], [StudentId], [IsDeleted]) VALUES ('Large', 'New', 30, 0);

	END

	-- Volunteer
BEGIN
    USE [HalfTimeDB]
	INSERT INTO [dbo].[Volunteer] ([FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber], [IsDeleted]) VALUES ('Lance', 'Greshman', '200 Erin Ln', 'Nashville', 'TN', '37221', '+12052278229', 0);
	INSERT INTO [dbo].[Volunteer] ([FirstName], [LastName], [Street], [City], [State], [Zipcode], [PhoneNumber], [IsDeleted]) VALUES ('Laura', 'Billings', '5641 Astoria Ln', 'Nashville', 'TN', '37221', '+12054057575', 0);
	END

-- UserEventJoin
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,1);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,2);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,3);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,4);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,5);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,6);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,7);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,8);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,9);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,10);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,11);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,12);
INSERT INTO [dbo].[UserEventJoin] ([UserId], [EventId]) VALUES (1,13);

	END

-- UserInstrumentJoin
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,1);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,2);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,3);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,4);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,5);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,6);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,7);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,8);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,9);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,10);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,11);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,12);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,13);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,14);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,15);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,16);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,17);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,18);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,19);
INSERT INTO [dbo].[UserInstrumentJoin] ([UserId], [InstrumentId]) VALUES (1,20);

	END

-- UserStudentJoin
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,1);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,2);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,3);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,4);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,5);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,6);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,7);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,8);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,9);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,10);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,11);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,12);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,13);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,14);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,15);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,16);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,17);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,18);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,19);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,20);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,21);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,22);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,23);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,24);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,25);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,26);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,27);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,28);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,29);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,30);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,31);
INSERT INTO [dbo].[UserStudentJoin] ([UserId], [StudentId]) VALUES (1,32);

	END

-- UserUniformJoin
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,1);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,2);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,3);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,4);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,5);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,6);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,1);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,2);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,3);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,4);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,5);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,6);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,7);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,8);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,9);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,10);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,11);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,12);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,13);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,14);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,15);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,16);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,17);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,18);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,19);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,20);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,21);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,22);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,23);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,24);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,25);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,26);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,27);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,28);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,29);
INSERT INTO [dbo].[UserUniformJoin] ([UserId], [UniformId]) VALUES (1,30);

END

-- UserVolunteerJoin
BEGIN
    USE [HalfTimeDB]
INSERT INTO [dbo].[UserVolunteerJoin] ([UserId], [VolunteerId]) VALUES (1,1);
INSERT INTO [dbo].[UserVolunteerJoin] ([UserId], [VolunteerId]) VALUES (1,2);

END

COMMIT TRANSACTION HALFTIMEDB_SEED