# Projet Base de Données MOOC

## Contenu du Repository

Ce repository contient les fichiers pour la mise en place et la gestion de la base de données du projet:

- **Rapport.pdf**: Document contenant les détails de conception l'analyse des résultats et export des diagrammes de la base de données réalisés avec Vertabelo.
- **database_create.sql**: Script SQL pour la création de la structure de la base de données.
- **database_data.sql**: Script SQL contenant uniquement les insertions de données.
- **database_constraints.sql**: Script contenant les triggers et procédures ainsi que les tests des contraintes.
- **database_queries.sql**: Script contenant les requêtes utilisées dans le projet avec des commentaires explicatifs.
- **Un dossier de screenshot des résultats de requête.**

## Installation

### Configuration de la Base de Données

1. **Création de la structure de la base**:
   - Connectez-vous à votre base de données PostgreSQL.
   - Ouvrez le fichier `database_create.sql` avec votre éditeur SQL préféré ou via la ligne de commande.
   - Exécutez le script pour créer la structure de votre base de données (tables, index, etc.).

2. **Insertion des données**:
   - De manière similaire, ouvrez et exécutez le fichier `database_data.sql` pour insérer les données dans les tables créées précédemment.

### Tests

- Pour tester les contraintes et les fonctionnalités implémentées, vous pouvez exécuter les requêtes fournies dans `database_constraints.sql` et observer les résultats et/ou les messages d'erreur générés.

