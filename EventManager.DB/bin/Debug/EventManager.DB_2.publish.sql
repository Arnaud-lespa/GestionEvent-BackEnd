/*
Script de déploiement pour EventDB

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "EventDB"
:setvar DefaultFilePrefix "EventDB"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Création de la base de données $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Création de Table [dbo].[Activity]...';


GO
CREATE TABLE [dbo].[Activity] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Name]        NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (500) NULL,
    [StartDate]   DATETIME2 (7)  NOT NULL,
    [EndDate]     DATETIME2 (7)  NOT NULL,
    [ImageName]   NVARCHAR (100) NULL,
    [ImageSrc]    VARCHAR (50)   NULL,
    [MaxGuest]    INT            NULL,
    [CreatorId]   INT            NOT NULL,
    [IsCancel]    BIT            NULL,
    [CreateDate]  DATETIME2 (7)  NULL,
    [UpdateDate]  DATETIME2 (7)  NULL,
    CONSTRAINT [PK_Activity] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Création de Table [dbo].[Member]...';


GO
CREATE TABLE [dbo].[Member] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Pseudo]    NVARCHAR (50)  NOT NULL,
    [Email]     NVARCHAR (250) NOT NULL,
    [HashPwd]   CHAR (97)      NOT NULL,
    [Firstname] NVARCHAR (50)  NULL,
    [Lastname]  NVARCHAR (50)  NULL,
    [Birthdate] DATE           NULL,
    CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Member__Email] UNIQUE NONCLUSTERED ([Email] ASC),
    CONSTRAINT [UK_Member__Pseudo] UNIQUE NONCLUSTERED ([Pseudo] ASC)
);


GO
PRINT N'Création de Table [dbo].[Registration]...';


GO
CREATE TABLE [dbo].[Registration] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [ActivityId] INT NOT NULL,
    [MemberId]   INT NOT NULL,
    [NbGuest]    INT NOT NULL,
    CONSTRAINT [PK_Registration] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Activity]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD DEFAULT 0 FOR [IsCancel];


GO
PRINT N'Création de Contrainte par défaut contrainte sans nom sur [dbo].[Activity]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD DEFAULT (GETDATE()) FOR [CreateDate];


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Activity__Creator]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD CONSTRAINT [FK_Activity__Creator] FOREIGN KEY ([CreatorId]) REFERENCES [dbo].[Member] ([Id]);


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Registration__Activity]...';


GO
ALTER TABLE [dbo].[Registration]
    ADD CONSTRAINT [FK_Registration__Activity] FOREIGN KEY ([ActivityId]) REFERENCES [dbo].[Activity] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Création de Clé étrangère [dbo].[FK_Registration__Member]...';


GO
ALTER TABLE [dbo].[Registration]
    ADD CONSTRAINT [FK_Registration__Member] FOREIGN KEY ([MemberId]) REFERENCES [dbo].[Member] ([Id]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Activity__EventDate]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD CONSTRAINT [CK_Activity__EventDate] CHECK ([StartDate] < [EndDate]);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Activity__MaxGuest]...';


GO
ALTER TABLE [dbo].[Activity]
    ADD CONSTRAINT [CK_Activity__MaxGuest] CHECK ([MaxGuest] > 0);


GO
PRINT N'Création de Contrainte de validation [dbo].[CK_Registration__NbGuest]...';


GO
ALTER TABLE [dbo].[Registration]
    ADD CONSTRAINT [CK_Registration__NbGuest] CHECK ([NbGuest] > 0);


GO
PRINT N'Création de Déclencheur [dbo].[ActivityUpdateTrigger]...';


GO
CREATE TRIGGER [ActivityUpdateTrigger] ON [Activity]
AFTER UPDATE
AS
BEGIN
	UPDATE [Activity]
	 SET [UpdateDate] = GETDATE()
	WHERE [Id] IN (SELECT [Id] FROM [inserted])
END
GO
PRINT N'Création de Vue [dbo].[V_Activity]...';


GO
CREATE VIEW [dbo].[V_Activity]
	AS SELECT * FROM [Activity]
GO
PRINT N'Création de Vue [dbo].[V_Member]...';


GO
CREATE VIEW [dbo].[V_Member]
	AS SELECT [Id], [Pseudo], [Email], [Firstname], [Lastname], [Birthdate] FROM [Member]
GO
PRINT N'Création de Vue [dbo].[V_Registration]...';


GO
CREATE VIEW [dbo].[V_Registration]
	AS SELECT * FROM [Registration]
GO
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'fac2a5f6-ba5c-4dae-a1e6-d3938e3e8221')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('fac2a5f6-ba5c-4dae-a1e6-d3938e3e8221')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '445adfd7-6e6e-4030-adf2-28d23a13403b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('445adfd7-6e6e-4030-adf2-28d23a13403b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '1073db2d-8666-4873-9602-3352e50d403a')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('1073db2d-8666-4873-9602-3352e50d403a')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'be433e50-64dd-41e5-9044-ae0741102dde')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('be433e50-64dd-41e5-9044-ae0741102dde')

GO

GO
-- Member
SET IDENTITY_INSERT [Member] ON;

INSERT INTO [dbo].[Member] ([Id], [Pseudo],[Email],[HashPwd],[Firstname],[Lastname],[Birthdate])
 VALUES (1, 'Della', 'della.duck@demo.be','$argon2id$v=19$m=65536,t=3,p=1$w2oAgHGMcXgXnBdHeACX3Q$1wbionGgGQ8509Ve5O6A4APighPd456mYl64OiT+Pbc','Della','Duck','1990-03-13')

INSERT INTO [dbo].[Member] ([Id],[Pseudo],[Email],[HashPwd],[Firstname],[Lastname],[Birthdate])
 VALUES (2, 'Zaza', 'zaza.vanderquak@demo.be','$argon2id$v=19$m=65536,t=3,p=1$TcHcBA9TF6Ld8CEbGe/7IQ$kjJfQytTFpJni/aoXt8CMwdRy9dc8JgfvjmHW+Ly/WM','Zaza', NULL, NULL)

SET IDENTITY_INSERT [Member] OFF;
GO

-- Activity
SET IDENTITY_INSERT [Activity] ON;

INSERT INTO [dbo].[Activity]([Id], [Name], [Description], [StartDate], [EndDate], [ImageName], [ImageSrc], [MaxGuest], [CreatorId], [IsCancel], [CreateDate], [UpdateDate])
 VALUES(1, 'Event Exemple', NULL, '2023-01-02 11:30', '2023-01-02 16:00', NULL, NULL, 42, 1, 0, '2022-11-30 14:28:22.130', NULL)

SET IDENTITY_INSERT [Activity] OFF;

-- Registration 
SET IDENTITY_INSERT [Registration] ON;

INSERT INTO [dbo].[Registration] ([Id],[ActivityId],[MemberId],[NbGuest])
 VALUES (1, 1, 2, 10)

SET IDENTITY_INSERT [Registration] OFF;
GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Mise à jour terminée.';


GO
