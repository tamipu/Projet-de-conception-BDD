-- LES CONTRAINTES --

--1. Contraintes sur la table Evaluation
-- Les notes sont bien entre 1 et 5
ALTER TABLE Evaluation
ADD CONSTRAINT encadrement_note
CHECK (Note BETWEEN 1 and 5);
-- Un étudiant ne peut noter et commenter un cours qu'une seule fois
ALTER TABLE Evaluation
ADD CONSTRAINT unique_evaluation
UNIQUE (Utilisateur_ID, Cours_ID);
-- La description et les prérequis ne sont pas vides
ALTER TABLE Cours
ADD CONSTRAINT check_description_not_empty
CHECK (TRIM(Description) != '');

ALTER TABLE Cours
ADD CONSTRAINT check_prerequis_not_empty
CHECK (TRIM(Prerequis) != '');

--2. Contraintes sur la table Cours
-- La date de début est antérieure à la date de fin
ALTER TABLE Cours 
ADD CONSTRAINT check_dates 
CHECK (DateDebut <= DateFin);
-- Le titre du cours ne doit pas être vide et ne doit pas dépasser 50 caractères
ALTER TABLE Cours
ADD CONSTRAINT check_intitule_not_empty
CHECK (TRIM(Intitule) != '');

ALTER TABLE Cours
ADD CONSTRAINT check_intitule_length
CHECK (LENGTH(Intitule) <= 50);

--3. Contraintes sur la table Session_Direct
-- Vérifier que la date de début est avant la date de fin pour les sessions
ALTER TABLE "session_direct"
ADD CONSTRAINT check_heures
CHECK (DateDebut < DateFin);

--4. Contrainte et trigger sur la table Tentative
-- Vérifie que le score est entre 0 et 100
ALTER TABLE tentative  
ADD CONSTRAINT score_valid
CHECK (Score BETWEEN 0 AND 100);
-- Création ou remplacement de la fonction pour définir le statut de réussite basé sur le score
CREATE OR REPLACE FUNCTION set_statut_de_reussite()
RETURNS TRIGGER AS $$
BEGIN
    -- Si le score est égal ou supérieur à 40, marquer la tentative comme réussie (true)
    IF NEW.Score >= 40 THEN
        NEW.Statut_de_reussite := TRUE;
    ELSE
        NEW.Statut_de_reussite := FALSE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Créer un trigger pour appliquer cette fonction lors de chaque insertion ou mise à jour sur la table tentative
CREATE TRIGGER set_statut_de_reussite_trigger
BEFORE INSERT OR UPDATE ON tentative
FOR EACH ROW
EXECUTE FUNCTION set_statut_de_reussite();

--5. Trigger pour vérifier l'inscription aux sessions
-- Vérifier si un étudiant est déjà inscrit à une session qui se chevauche
CREATE OR REPLACE FUNCTION check_inscription_session()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inscription_Cours IC
        JOIN Session_Direct SD ON IC.Session_Direct_ID = SD.ID
        WHERE IC.Utilisateur_ID = NEW.Utilisateur_ID AND SD.DateDebut <= NEW.DateFin AND SD.DateFin >= NEW.DateDebut
    ) THEN
        RAISE EXCEPTION 'L''étudiant est déjà inscrit à une autre session au même moment.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_inscription_session_trigger
BEFORE INSERT OR UPDATE ON Inscription_Cours
FOR EACH ROW
EXECUTE FUNCTION check_inscription_session();

--6. Procédure pour la création de cours par des rôles spécifiques
-- Procédure pour créer des cours basée sur le rôle de l'utilisateur
CREATE OR REPLACE FUNCTION create_course(user_id INT, course_details JSONB) RETURNS void AS $$
DECLARE
    user_role TEXT;
BEGIN
    -- Récupération du rôle de l'utilisateur
    SELECT R.Libelle INTO user_role
    FROM Role_Utilisateur RU
    JOIN Role R ON RU.Roles_ID = R.ID
    WHERE RU.Utilisateur_ID = user_id;

    -- Vérification si l'utilisateur a le droit de créer un cours
    IF user_role NOT IN ('Admin', 'Formateur', 'Créateur') THEN
        RAISE EXCEPTION 'Cet utilisateur n''a pas le droit de créer un cours.';
    END IF;

    -- Insertion des détails du cours si l'utilisateur est autorisé
    INSERT INTO Cours (Intitule, Description, Prerequis, Prix, Accessibilite, DateDebut, DateFin)
    VALUES (course_details->>'Intitule', course_details->>'Description', course_details->>'Prerequis', (course_details->>'Prix')::numeric, (course_details->>'Accessibilite')::boolean, (course_details->>'DateDebut')::date, (course_details->>'DateFin')::date);

    RAISE NOTICE 'Cours créé avec succès par l''utilisateur %', user_id;
END;
$$ LANGUAGE plpgsql;

--7. Contraintes sur la table Utilisateur
-- Assurer que l'email est unique pour chaque utilisateur
ALTER TABLE Utilisateur
ADD CONSTRAINT unique_email
UNIQUE (Email);
-- Assurer que le nom et prénom ne sont pas vides
ALTER TABLE Utilisateur
ADD CONSTRAINT check_nom_prenom_not_empty
CHECK (TRIM(Nom) != '' AND TRIM(Prenom) != '');

--8. Gestion de l'inscription aux cours
-- Procédure pour vérifier le paiement avant l'inscription à un cours payant
CREATE OR REPLACE FUNCTION verify_payment_before_enrollment()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier si le cours est payant et si le paiement a été effectué
    IF (SELECT Payant FROM Cours WHERE ID = NEW.Cours_ID) AND NEW.DatePayant IS NULL THEN
        RAISE EXCEPTION 'L''inscription à un cours payant nécessite un paiement préalable.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verify_payment_trigger
BEFORE INSERT ON Inscription_Cours
FOR EACH ROW
EXECUTE FUNCTION verify_payment_before_enrollment();

--9. Procédure pour la correction des tentatives
-- Procédure pour marquer automatiquement les tentatives comme réussies si le score atteint le minimum requis
CREATE OR REPLACE FUNCTION auto_correct_attempts()
RETURNS void AS $$
BEGIN
    UPDATE Tentative
    SET Statut_de_reussite = TRUE
    WHERE Score >= (SELECT ScoreMin FROM Examen WHERE ID = Tentative.Examen_ID);
    RAISE NOTICE 'Tentatives corrigées et marquées comme réussies.';
END;
$$ LANGUAGE plpgsql;




-- LES TESTS --
--Pour tester les contraintes, on va écrire des requêtes SQL qui tentent d'insérer ou de modifier des données de manière à violer ces contraintes. La base de données devrait rejeter ces tentatives et renvoyer une erreur.

--1. Test pour la contrainte de note dans Evaluation
INSERT INTO Evaluation (Utilisateur_ID, Cours_ID, Note, Commentaire)
VALUES (1, 1, 6, 'Excellent');

--2. Test pour les contraintes sur les dates dans Cours
INSERT INTO Cours (Intitule, Description, Prerequis, Prix, Accessibilite, DateDebut, DateFin)
VALUES ('SQL Advanced', 'Deep dive into SQL', 'Basic SQL', 299.99, TRUE, '2023-12-01', '2023-01-01');

--3. Test pour la contrainte sur les heures dans Session_Direct
INSERT INTO "session_direct" (TypeSession, DateDebut, DateFin, PlacesMaximum, Cours_ID)
VALUES ('Online', '2024-12-31 10:00:00', '2024-12-30 10:00:00', 100, 1);

--4. Test pour la contrainte sur les scores dans Tentative
INSERT INTO Tentative ("date", score, "procedure", examen_id, inscription_cours_id, Statut_de_reussite)
VALUES ('2023-10-01', 101, 'Test Procédure', 1, 1, TRUE);

--5. Test pour les contraintes sur Utilisateur
INSERT INTO Utilisateur (Nom, Prenom, Email, DateNaissance, NumeroTelephone, "location", Username, "password")
VALUES ('Test', 'User', 'invalidemail', '1990-01-01', '1234567890', 'Test City', 'testuser', 'testpass');

--6. Test pour l'inscription à une session avec paiement préalable dans Inscription_Cours
INSERT INTO Inscription_Cours (DateInscription, DatePayant, Payant, TypeStatut, Utilisateur_ID, Session_Direct_ID)
VALUES ('2023-10-02', NULL, TRUE, 'Enrolled', 1, 1);

--7. Test pour la procédure de correction des tentatives
SELECT * FROM Tentative WHERE Examen_ID = 1;
SELECT auto_correct_attempts();

