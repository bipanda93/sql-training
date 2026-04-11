-- ============================================================
-- 01 — SELECT, CASE WHEN, LIKE, ORDER BY, LIMIT
-- Schéma : contact
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================


-- ------------------------------------------------------------
-- 1.1 SELECT avec CASE WHEN — Catégorisation par âge
-- Objectif : afficher le nom, prénom, année de naissance
--            et classer les contacts en 3 catégories
-- ------------------------------------------------------------
SELECT 
    nom,
    prenom,
    EXTRACT(YEAR FROM datedenaissance)          AS annee,
    CASE 
        WHEN EXTRACT(YEAR FROM datedenaissance) > 2000  THEN 'Plutôt Jeune'
        WHEN EXTRACT(YEAR FROM datedenaissance) 
             BETWEEN 1980 AND 2000              THEN 'Adulte'
        ELSE 'Senior'
    END                                         AS statut
FROM contact.contact;


-- ------------------------------------------------------------
-- 1.2 LIKE + ORDER BY — Filtrer par initiale
-- Objectif : contacts dont le nom commence par C
--            triés par nom ASC, prénom DESC
-- ------------------------------------------------------------
SELECT 
    nom, 
    prenom, 
    email
FROM contact.contact
WHERE nom LIKE 'C%'
ORDER BY nom ASC, prenom DESC;


-- ------------------------------------------------------------
-- 1.3 LIMIT — Aperçu rapide d'une table
-- ------------------------------------------------------------
SELECT *
FROM contact.contact c
LIMIT 10;


SELECT *
FROM contact.prospectus p
LIMIT 10;
