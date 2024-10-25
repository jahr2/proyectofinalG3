CREATE DATABASE farmas;

USE farmas;


DROP TABLE IF EXISTS [dbo].[UserLogins];
DROP TABLE IF EXISTS [dbo].[UserRoles];
DROP TABLE IF EXISTS [dbo].[Users];
DROP TABLE IF EXISTS [dbo].[Patients];
DROP TABLE IF EXISTS [dbo].[Doctors];
DROP TABLE IF EXISTS [dbo].[Roles];
DROP TABLE IF EXISTS [dbo].[Medication];
DROP TABLE IF EXISTS [dbo].[Category];
DROP TABLE IF EXISTS [dbo].[Cart];
DROP TABLE IF EXISTS [dbo].[Prescription];
DROP TABLE IF EXISTS [dbo].[PrescriptionDetail];
DROP TABLE IF EXISTS [dbo].[Diagnosis];
DROP TABLE IF EXISTS [dbo].[PaymentType];
DROP TABLE IF EXISTS [dbo].[PaymentMethod];


CREATE TABLE [dbo].[Users] (
    [Id]                   NVARCHAR (128) NOT NULL,
	[FirstName]            NVARCHAR (256) NULL,
    [LastName]             NVARCHAR (256) NULL,
	[UserName]             NVARCHAR (256) NOT NULL,
    [Email]                NVARCHAR (256) NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
   
    CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_UserName_dbo.Users] UNIQUE(UserName)
);

GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[Users]([UserName] ASC);

CREATE TABLE [dbo].[Patients] (
    [Id]          NVARCHAR (128) NOT NULL,
	[UserId]      NVARCHAR (128) NOT NULL,
    [LastName]    NVARCHAR (256) NULL,
	[DateOfBirth] DATE NULL,
    CONSTRAINT [PK_dbo.Patients] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Patients_dbo.Users] FOREIGN KEY (UserId) REFERENCES [dbo].[Users] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId_Clients]
    ON [dbo].[Clients]([UserId] ASC);

CREATE TABLE [dbo].[Doctors] (
    [Id]              NVARCHAR (128) NOT NULL,
	[UserId]          NVARCHAR (128) NOT NULL,
    [Specialization]  NVARCHAR (256) NULL,
    CONSTRAINT [PK_dbo.Doctors] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Doctors_dbo.Users] FOREIGN KEY (UserId) REFERENCES [dbo].[Users] ([Id])
);

GO
CREATE NONCLUSTERED INDEX [IX_UserId_Doctors]
    ON [dbo].[Doctors]([UserId] ASC);


CREATE TABLE [dbo].[Roles] (
    [Id]   NVARCHAR (128) NOT NULL,
    [Name] NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.Roles] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] 
	ON [dbo].[Roles]([Name] ASC);


CREATE TABLE [dbo].[UserRoles] (
    [UserId] NVARCHAR (128) NOT NULL,
    [RoleId] NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.UserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [FK_dbo.UserRoles_dbo.Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.UserRoles_dbo.Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
);

GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[UserRoles]([UserId] ASC);

GO
CREATE NONCLUSTERED INDEX [IX_RoleId]
    ON [dbo].[UserRoles]([RoleId] ASC);

CREATE TABLE [dbo].[UserLogins] (
    [LoginProvider] NVARCHAR (128) NOT NULL,
    [ProviderKey]   NVARCHAR (128) NOT NULL,
    [UserId]        NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.UserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
    CONSTRAINT [FK_dbo.UserLogins_dbo.Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
);

GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[UserLogins]([UserId] ASC);


CREATE TABLE [dbo].[Diagnosis] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [PatientId]  NVARCHAR (128) NOT NULL,
    [DoctorId]   NVARCHAR (128) NOT NULL,
    [DiagnosisDate]  DATETIME NOT NULL,
    [Description]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_dbo.Diagnosis] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Diagnosis_dbo.Patients] FOREIGN KEY (PatientId) REFERENCES [dbo].[Patients] ([Id]),
    CONSTRAINT [FK_dbo.Diagnosis_dbo.Doctors] FOREIGN KEY (DoctorId) REFERENCES [dbo].[Doctors] ([Id])
);


CREATE TABLE [dbo].[Category] (
    [Id]       INT IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.Category] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Name_dbo.Category] UNIQUE (Name)
);


CREATE TABLE [dbo].[Medication] (
    [Id]       INT IDENTITY (1, 1) NOT NULL,
    [Name]     NVARCHAR (128) NOT NULL,
    [NCD]      NVARCHAR (12) NOT NULL,
    [DosageForm]  NVARCHAR (50) NOT NULL,
    [Strength]    NVARCHAR (50) NOT NULL,
    [Manufacturer]  NVARCHAR (128) NOT NULL,
	[Price]    DECIMAL(12,4) NOT NULL,
	[Quantity] INT NOT NULL DEFAULT 0,
	[ImageUrl] NVARCHAR(256) NOT NULL,
	[CategoryId] INT NOT NULL,
    [ExpiryDate]  DATE NOT NULL,
    [PrescriptionRequired] BIT NOT NULL DEFAULT 0,
    [SideEffects] NVARCHAR(256),
    [DrugInteractions] NVARCHAR(256),
    CONSTRAINT [PK_dbo.Medication] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Name_dbo.Medication] UNIQUE (Name),
	CONSTRAINT [FK_dbo.Medication_dbo.Category] FOREIGN KEY (CategoryId) REFERENCES [dbo].[Category] ([Id]),
);

CREATE TABLE [dbo].[Cart] (
    [Id]        INT IDENTITY (1, 1) NOT NULL,
    [UserId]    NVARCHAR (128) NOT NULL,
    [MedicationId] INT NOT NULL,
	[Quantity]  INT NOT NULL,
    [Status]    NVARCHAR (128) NOT NULL,
    [CartDateTimeUTC] DATETIME NOT NULL,
    CONSTRAINT [PK_dbo.Cart] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Cart_dbo.Users] FOREIGN KEY (UserId) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.Cart_dbo.Medication] FOREIGN KEY (MedicationId) REFERENCES [dbo].[Medication] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[PaymentMethod] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
	[CardNumber]  NVARCHAR (256) NOT NULL,
	[ExpiryDate]  DATE NOT NULL,
    [Country]     NVARCHAR (256) NOT NULL,
    [CvvNumber]   INT  NOT NULL,
    [PaymentMethodTypeId] INT NOT NULL,
    [UserId]         NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.PaymentMethod] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.PaymentMethod_dbo.PaymentMethodType] FOREIGN KEY (PaymentMethodTypeId) REFERENCES [dbo].[PaymentMethodType] ([Id]),
    CONSTRAINT [FK_dbo.PaymentMethod_dbo.Users] FOREIGN KEY (UserId) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE,
);

CREATE TABLE [dbo].[Prescription] (
    [Id]          INT IDENTITY (1, 1) NOT NULL,
    [Address]     NVARCHAR (256) NOT NULL,
    [Total]       DECIMAL(12,4) NOT NULL,
    [DoctorId]    NVARCHAR (128)  NULL,
    [PatientId]  NVARCHAR (128) NOT NULL,
    [PaymentMethodId]   INT NOT NULL,
    [PrescriptionDateTimeUTC]   DATETIME NOT NULL,
    CONSTRAINT [PK_dbo.Prescription] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.Prescription_dbo.UsersDoctor] FOREIGN KEY (DoctorId) REFERENCES [dbo].[Doctors] ([Id]),
    CONSTRAINT [FK_dbo.Prescription_dbo.UsersPatient] FOREIGN KEY (PatientId) REFERENCES [dbo].[Patients] ([Id]),
    CONSTRAINT [FK_dbo.Prescription_dbo.PaymentMethod] FOREIGN KEY (PaymentMethodId) REFERENCES [dbo].[PaymentMethod] ([Id]) 
);

CREATE TABLE [dbo].[PrescriptionDetail] (
    [Id]            INT IDENTITY (1, 1) NOT NULL,
	[PrescriptionId]       INT NOT NULL,
    [MedicationId]   INT NOT NULL,
    [PatientId]     NVARCHAR(128) NOT NULL,
    [Quantity]      INT NOT NULL,
    [UnitPrice]     DECIMAL(12,4) NOT NULL,
    CONSTRAINT [PK_dbo.PrescriptionDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_dbo.PrescriptionDetail_dbo.Prescription] FOREIGN KEY (PrescriptionId) REFERENCES [dbo].[Prescription] ([Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_dbo.PrescriptionDetail_dbo.Medication] FOREIGN KEY (MedicationId) REFERENCES [dbo].[Medication] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.PrescriptionDetail_dbo.Patients] FOREIGN KEY (PatientId) REFERENCES [dbo].[Patients] ([Id])
); 

CREATE TABLE [dbo].[PaymentMethodType] (
    [Id]  INT IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.PaymentMethodType] PRIMARY KEY CLUSTERED ([Id] ASC)
);



