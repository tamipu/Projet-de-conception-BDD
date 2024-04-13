-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-03-14 10:40:00.218

-- tables
-- Table: Assignation
CREATE TABLE Assignation (
    Cours_ID int  NOT NULL,
    Utilisateur_ID int  NOT NULL,
    CONSTRAINT Assignation_pk PRIMARY KEY (Cours_ID,Utilisateur_ID)
);

-- Table: Chapitre
CREATE TABLE Chapitre (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    OrdreChapitre int  NOT NULL,
    ChapitreNom varchar(100)  NOT NULL,
    Cours_ID int  NOT NULL,
    CONSTRAINT Chapitre_pk PRIMARY KEY (ID)
);

-- Table: Cours
CREATE TABLE Cours (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    Intitule varchar(255)  NOT NULL,
    Description Text  NOT NULL,
    Prerequis Text  NOT NULL,
    Prix decimal(5,2)  NOT NULL,
    Accessibilite boolean  NOT NULL,
    DateDebut date  NULL,
    DateFin date  NULL,
    CONSTRAINT Cours_pk PRIMARY KEY (ID)
);

-- Table: Creation
CREATE TABLE Creation (
    Cours_ID int  NOT NULL,
    Utilisateur_ID int  NOT NULL,
    Date date  NOT NULL,
    CONSTRAINT Creation_pk PRIMARY KEY (Cours_ID,Utilisateur_ID)
);

-- Table: Evaluation
CREATE TABLE Evaluation (
    Utilisateur_ID int  NOT NULL,
    Cours_ID int  NOT NULL,
    Note decimal(1,1)  NULL,
    Commentaire Text  NULL,
    CONSTRAINT Evaluation_pk PRIMARY KEY (Utilisateur_ID,Cours_ID)
);

-- Table: Examen
CREATE TABLE Examen (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    TitreExamen varchar(70)  NOT NULL,
    Contenu Text  NOT NULL,
    ScoreMin decimal(3,3)  NOT NULL,
    Partie_ID int  NOT NULL,
    CONSTRAINT Examen_pk PRIMARY KEY (ID)
);

-- Table: Inscription_Cours
CREATE TABLE Inscription_Cours (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    DateInscription date  NOT NULL,
    DatePayant date  NULL,
    Payant boolean  NOT NULL,
    TypeStatut varchar(25)  NOT NULL,
    Utilisateur_ID int  NOT NULL,
    Session_Direct_ID int  NOT NULL,
    CONSTRAINT Inscription_Cours_pk PRIMARY KEY (ID)
);

-- Table: Partie
CREATE TABLE Partie (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    OrdrePartie int  NOT NULL,
    TitrePartie varchar(70)  NOT NULL,
    Contenu Text  NOT NULL,
    Chapitre_ID int  NOT NULL,
    CONSTRAINT Partie_pk PRIMARY KEY (ID)
);

-- Table: Progression
CREATE TABLE Progression (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    Termine boolean  NOT NULL,
    Date date  NOT NULL,
    Partie_ID int  NOT NULL,
    Inscription_Cours_ID int  NOT NULL,
    CONSTRAINT Progression_pk PRIMARY KEY (ID)
);

-- Table: Role
CREATE TABLE Role (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    Libelle varchar(30)  NOT NULL,
    CONSTRAINT Roles_pk PRIMARY KEY (ID)
);

-- Table: Role_Utilisateur
CREATE TABLE Role_Utilisateur (
    Utilisateur_ID int  NOT NULL,
    Roles_ID int  NOT NULL,
    CONSTRAINT Role_Utilisateur_pk PRIMARY KEY (Utilisateur_ID,Roles_ID)
);

-- Table: Session_Direct
CREATE TABLE Session_Direct (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    TypeSession varchar(30)  NOT NULL,
    DateDebut timestamp  NOT NULL,
    DateFin timestamp  NOT NULL,
    PlacesMaximum int  NOT NULL,
    Cours_ID int  NOT NULL,
    CONSTRAINT Session_Direct _pk PRIMARY KEY (ID)
);

-- Table: Tentative
CREATE TABLE Tentative (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    Date date  NOT NULL,
    Score decimal(3,2)  NOT NULL,
    Procedure varchar(70)  NOT NULL,
    Examen_ID int  NOT NULL,
    Inscription_Cours_ID int  NOT NULL,
    CONSTRAINT Tentative_pk PRIMARY KEY (ID)
);

-- Table: Utilisateur
CREATE TABLE Utilisateur (
    ID int  NOT NULL GENERATED ALWAYS AS IDENTITY,
    Nom varchar(100)  NOT NULL,
    Prenom varchar(100)  NOT NULL,
    Email varchar(50)  NOT NULL,
    DateNaissance date  NOT NULL,
    NumeroTelephone varchar(15)  NOT NULL,
    Location varchar(8)  NOT NULL,
    Username varchar(50)  NOT NULL,
    Password varchar(50)  NOT NULL,
    CONSTRAINT Utilisateur_pk PRIMARY KEY (ID)
);

-- foreign keys
-- Reference: Avoir (table: Progression)
ALTER TABLE Progression ADD CONSTRAINT Avoir
    FOREIGN KEY (Inscription_Cours_ID)
    REFERENCES Inscription_Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Chapitres_Cours (table: Chapitre)
ALTER TABLE Chapitre ADD CONSTRAINT Chapitres_Cours
    FOREIGN KEY (Cours_ID)
    REFERENCES Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Cours_association_1 (table: Creation)
ALTER TABLE Creation ADD CONSTRAINT Cours_association_1
    FOREIGN KEY (Cours_ID)
    REFERENCES Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Cours_association_2 (table: Assignation)
ALTER TABLE Assignation ADD CONSTRAINT Cours_association_2
    FOREIGN KEY (Cours_ID)
    REFERENCES Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: De (table: Inscription_Cours)
ALTER TABLE Inscription_Cours ADD CONSTRAINT De
    FOREIGN KEY (Session_Direct_ID)
    REFERENCES Session_Direct (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Evaluation_Cours (table: Evaluation)
ALTER TABLE Evaluation ADD CONSTRAINT Evaluation_Cours
    FOREIGN KEY (Cours_ID)
    REFERENCES Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Examen_Partie (table: Examen)
ALTER TABLE Examen ADD CONSTRAINT Examen_Partie
    FOREIGN KEY (Partie_ID)
    REFERENCES Partie (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Inscription_Tentative (table: Tentative)
ALTER TABLE Tentative ADD CONSTRAINT Inscription_Tentative
    FOREIGN KEY (Inscription_Cours_ID)
    REFERENCES Inscription_Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Inscrire (table: Inscription_Cours)
ALTER TABLE Inscription_Cours ADD CONSTRAINT Inscrire
    FOREIGN KEY (Utilisateur_ID)
    REFERENCES Utilisateur (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partie_Chapitre (table: Partie)
ALTER TABLE Partie ADD CONSTRAINT Partie_Chapitre
    FOREIGN KEY (Chapitre_ID)
    REFERENCES Chapitre (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Progression_Partie (table: Progression)
ALTER TABLE Progression ADD CONSTRAINT Progression_Partie
    FOREIGN KEY (Partie_ID)
    REFERENCES Partie (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Roles_Role_Utilisateur (table: Role_Utilisateur)
ALTER TABLE Role_Utilisateur ADD CONSTRAINT Roles_Role_Utilisateur
    FOREIGN KEY (Roles_ID)
    REFERENCES Role (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Session_Cours (table: Session_Direct)
ALTER TABLE Session_Direct ADD CONSTRAINT Session_Cours
    FOREIGN KEY (Cours_ID)
    REFERENCES Cours (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Tentative_Examen (table: Tentative)
ALTER TABLE Tentative ADD CONSTRAINT Tentative_Examen
    FOREIGN KEY (Examen_ID)
    REFERENCES Examen (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Utilisateur_Assignation (table: Assignation)
ALTER TABLE Assignation ADD CONSTRAINT Utilisateur_Assignation
    FOREIGN KEY (Utilisateur_ID)
    REFERENCES Utilisateur (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Utilisateur_Creation (table: Creation)
ALTER TABLE Creation ADD CONSTRAINT Utilisateur_Creation
    FOREIGN KEY (Utilisateur_ID)
    REFERENCES Utilisateur (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Utilisateur_Evaluation (table: Evaluation)
ALTER TABLE Evaluation ADD CONSTRAINT Utilisateur_Evaluation
    FOREIGN KEY (Utilisateur_ID)
    REFERENCES Utilisateur (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Utilisateur_Role_Utilisateur (table: Role_Utilisateur)
ALTER TABLE Role_Utilisateur ADD CONSTRAINT Utilisateur_Role_Utilisateur
    FOREIGN KEY (Utilisateur_ID)
    REFERENCES Utilisateur (ID)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- sequences
-- Sequence: Chapitre_seq
CREATE SEQUENCE Chapitre_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Cours_seq
CREATE SEQUENCE Cours_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Examen_seq
CREATE SEQUENCE Examen_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Inscription_Cours_seq
CREATE SEQUENCE Inscription_Cours_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Partie_seq
CREATE SEQUENCE Partie_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Progression_seq
CREATE SEQUENCE Progression_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Roles_seq
CREATE SEQUENCE Roles_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Session_Direct_seq
CREATE SEQUENCE Session_Direct_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Tentative_seq
CREATE SEQUENCE Tentative_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- Sequence: Utilisateur_seq
CREATE SEQUENCE Utilisateur_seq
      INCREMENT BY 1
      NO MINVALUE
      NO MAXVALUE
      START WITH 1
      NO CYCLE
;

-- End of file.

