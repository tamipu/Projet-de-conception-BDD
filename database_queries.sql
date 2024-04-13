
-- 1a. Afficher les cours par ordre de popularité par nombre d’utilisateurs inscrits
SELECT C.ID, C.Intitule, COUNT(IC.Utilisateur_ID) AS NombreInscrits
FROM Cours C
JOIN Session_Direct SD ON C.ID = SD.Cours_ID
JOIN Inscription_Cours IC ON SD.ID = IC.Session_Direct_ID
GROUP BY C.ID, C.Intitule
ORDER BY NombreInscrits DESC;

-- 1b. Afficher les cours par ordre de popularité par meilleures évaluations (notes sur 5 données par les utilisateurs d’un cours)
SELECT C.ID, C.Intitule, AVG(E.Note) AS NoteMoyenne
FROM Cours C
JOIN Evaluation E ON C.ID = E.Cours_ID
GROUP BY C.ID, C.Intitule
ORDER BY NoteMoyenne DESC;


-- 2a. Afficher les utilisateurs qui ont terminé toutes les parties du cours donné
SELECT DISTINCT U.ID, U.Nom, U.Prenom
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Progression P ON IC.ID = P.Inscription_Cours_ID
JOIN Partie Pa ON P.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 6 AND P.Termine = TRUE
GROUP BY U.ID, U.Nom, U.Prenom;

-- 2b. Afficher les utilisateurs qui ont tenté au moins une fois tous les examens du cours donné
SELECT U.ID, U.Nom, U.Prenom
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Tentative T ON IC.ID = T.Inscription_Cours_ID
JOIN Examen E ON T.Examen_ID = E.ID
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 6
GROUP BY U.ID, U.Nom, U.Prenom;

-- 2c. Afficher les utilisateurs qui ont réussi tous les examens du cours donné
SELECT U.ID, U.Nom, U.Prenom
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Tentative T ON IC.ID = T.Inscription_Cours_ID
JOIN Examen E ON T.Examen_ID = E.ID
JOIN Partie Pa ON E.Partie_ID = Pa.ID
JOIN Chapitre Ch ON Pa.Chapitre_ID = Ch.ID
WHERE Ch.Cours_ID = 1 AND T.Score >= E.ScoreMin
GROUP BY U.ID, U.Nom, U.Prenom;


--3. Afficher la liste des utilisateurs par ordre de dépenses (les utilisateurs qui ont dépensé le plus d’argent en achetant des cours payants. On doit voir le montant dépensé dans le résultat de la requête)
-- On calcule la dépense totale de chaque utilisateur sur les cours payants et on les trie par dépense décroissante.
SELECT 
    U.ID, 
    U.Nom, 
    U.Prenom, 
    SUM(C.Prix) AS TotalDepense
FROM Utilisateur U
JOIN Inscription_Cours IC ON U.ID = IC.Utilisateur_ID
JOIN Session_Direct SD ON IC.Session_Direct_ID = SD.ID
JOIN Cours C ON SD.Cours_ID = C.ID
WHERE IC.Payant = TRUE
GROUP BY U.ID, U.Nom, U.Prenom
ORDER BY TotalDepense DESC;

--4. Afficher les parties d’un cours, ordonnées par chapitres et ordre dans les chapitres
-- Liste toutes les parties d'un cours, classées par ordre des chapitres et des parties au sein des chapitres.
SELECT 
    Ch.Cours_ID,
    Ch.OrdreChapitre,
    Ch.ChapitreNom,
    Pa.OrdrePartie,
    Pa.TitrePartie,
    Pa.Contenu
FROM Chapitre Ch
JOIN Partie Pa ON Ch.ID = Pa.Chapitre_ID
WHERE Ch.Cours_ID = 1  
ORDER BY Ch.OrdreChapitre, Pa.OrdrePartie;

--5. Afficher tous les cours ainsi que les créateurs de cours et formateurs qui y sont rattachés
-- Joint les tables pour afficher l'information sur les créateurs et les formateurs liés à chaque cours.
SELECT 
    C.ID AS ID_Cours,
    C.Intitule AS Titre_Cours,
    U.Nom AS Nom_Utilisateur,
    U.Prenom AS Prenom_Utilisateur,
    'Créateur' AS Role
FROM Cours C
JOIN Creation Cr ON C.ID = Cr.Cours_ID
JOIN Utilisateur U ON Cr.Utilisateur_ID = U.ID
UNION ALL
SELECT 
    C.ID AS ID_Cours,
    C.Intitule AS Titre_Cours,
    U.Nom AS Nom_Utilisateur,
    U.Prenom AS Prenom_Utilisateur,
    'Assigné' AS Role
FROM Cours C
JOIN Assignation A ON C.ID = A.Cours_ID
JOIN Utilisateur U ON A.Utilisateur_ID = U.ID

ORDER BY ID_Cours, Role;


--6. Pour un utilisateur donné, affiché les cours auxquels il est inscrit, ainsi que son pourcentage de progression de chaque cours (nombre de parties marquées comme terminées par rapport au nombre de parties totales du cours)
SELECT 
    IC.Utilisateur_ID AS ID_Utilisateur,
    C.ID AS ID_Cours,
    C.Intitule AS Titre_Cours,
    COALESCE(CAST(COUNT(DISTINCT CASE WHEN P.Termine THEN Pa.ID END) AS FLOAT) / NULLIF(COUNT(DISTINCT PartieTotale.ID), 0) * 100, 0) AS Pourcentage_Progression
FROM Inscription_Cours IC
JOIN Session_Direct SD ON IC.Session_Direct_ID = SD.ID
JOIN Cours C ON SD.Cours_ID = C.ID
LEFT JOIN Chapitre Ch ON C.ID = Ch.Cours_ID
LEFT JOIN Partie PartieTotale ON Ch.ID = PartieTotale.Chapitre_ID -- Jointure pour toutes les parties, terminées ou non
LEFT JOIN Progression P ON IC.ID = P.Inscription_Cours_ID AND P.Termine = TRUE
LEFT JOIN Partie Pa ON P.Partie_ID = Pa.ID -- Seulement pour les parties terminées
WHERE IC.Utilisateur_ID = 2
GROUP BY IC.Utilisateur_ID, C.ID, C.Intitule
ORDER BY C.ID;
   
 
