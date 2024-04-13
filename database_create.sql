-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-03-20 14:21:03.617

-- Tables
-- Table: Assignation
CREATE TABLE Assignation (
    Cours_ID int NOT NULL,
    Utilisateur_ID int NOT NULL,
    CONSTRAINT Assignation_pk PRIMARY KEY (Cours_ID, Utilisateur_ID)
);

-- Table: Chapitre
CREATE TABLE Chapitre (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    OrdreChapitre int NOT NULL,
    ChapitreNom varchar(100) NOT NULL,
    Cours_ID int NOT NULL,
    CONSTRAINT Chapitre_pk PRIMARY KEY (ID)
);

-- Table: Cours
CREATE TABLE Cours (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    Intitule varchar(255) NOT NULL,
    Description Text NOT NULL,
    Prerequis Text NOT NULL,
    Prix decimal(5,2) NOT NULL,
    Accessibilite boolean NOT NULL,
    DateDebut date NULL,
    DateFin date NULL,
    CONSTRAINT Cours_pk PRIMARY KEY (ID)
);

-- Table: Creation
CREATE TABLE Creation (
    Cours_ID int NOT NULL,
    Utilisateur_ID int NOT NULL,
    Date date NOT NULL,
    CONSTRAINT Creation_pk PRIMARY KEY (Cours_ID, Utilisateur_ID)
);

-- Table: Evaluation
CREATE TABLE Evaluation (
    Utilisateur_ID int NOT NULL,
    Cours_ID int NOT NULL,
    Note decimal(10,1) NULL,
    Commentaire Text NULL,
    CONSTRAINT Evaluation_pk PRIMARY KEY (Utilisateur_ID, Cours_ID)
);

-- Table: Examen
CREATE TABLE Examen (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    TitreExamen varchar(70) NOT NULL,
    Contenu Text NOT NULL,
    ScoreMin decimal(10,2) NOT NULL,
    Partie_ID int NOT NULL,
    CONSTRAINT Examen_pk PRIMARY KEY (ID)
);

-- Table: Inscription_Cours
CREATE TABLE Inscription_Cours (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    DateInscription date NOT NULL,
    DatePayant date NULL,
    Payant boolean NOT NULL,
    TypeStatut varchar(25) NOT NULL,
    Utilisateur_ID int NOT NULL,
    Session_Direct_ID int NOT NULL,
    CONSTRAINT Inscription_Cours_pk PRIMARY KEY (ID)
);

-- Table: Partie
CREATE TABLE Partie (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    OrdrePartie int NOT NULL,
    TitrePartie varchar(70) NOT NULL,
    Contenu Text NOT NULL,
    Chapitre_ID int NOT NULL,
    CONSTRAINT Partie_pk PRIMARY KEY (ID)
);

-- Table: Progression
CREATE TABLE Progression (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    Termine boolean NOT NULL,
    Date date NOT NULL,
    Partie_ID int NOT NULL,
    Inscription_Cours_ID int NOT NULL,
    CONSTRAINT Progression_pk PRIMARY KEY (ID)
);

-- Table: Role
CREATE TABLE Role (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    Libelle varchar(30) NOT NULL,
    CONSTRAINT Roles_pk PRIMARY KEY (ID)
);

-- Table: Role_Utilisateur
CREATE TABLE Role_Utilisateur (
    Utilisateur_ID int NOT NULL,
    Roles_ID int NOT NULL,
    CONSTRAINT Role_Utilisateur_pk PRIMARY KEY (Utilisateur_ID, Roles_ID)
);

-- Table: Session_Direct
CREATE TABLE Session_Direct (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    TypeSession varchar(30) NOT NULL,
    DateDebut timestamp NOT NULL,
    DateFin timestamp NOT NULL,
    PlacesMaximum int NOT NULL,
    Cours_ID int NOT NULL,
    CONSTRAINT Session_Direct_pk PRIMARY KEY (ID)
);

-- Table: Tentative
CREATE TABLE Tentative (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    Date date NOT NULL,
    Score decimal(10,2) NOT NULL,
    Procedure varchar(70) NOT NULL,
    Examen_ID int NOT NULL,
    Inscription_Cours_ID int NOT NULL,
    Statut_de_Reussite boolean, -- This allows for NULL values, indicating unknown status
    CONSTRAINT Tentative_pk PRIMARY KEY (ID)
);

-- Table: Utilisateur
CREATE TABLE Utilisateur (
    ID int NOT NULL GENERATED ALWAYS AS IDENTITY,
    Nom varchar(100) NOT NULL,
    Prenom varchar(100) NOT NULL,
    Email varchar(50) NOT NULL,
    DateNaissance date NOT NULL,
    NumeroTelephone varchar(15) NOT NULL,
    Location varchar(50) NOT NULL,
    Username varchar(50) NOT NULL,
    Password varchar(50) NOT NULL,
    CONSTRAINT Utilisateur_pk PRIMARY KEY (ID)
);

-- End of file.
