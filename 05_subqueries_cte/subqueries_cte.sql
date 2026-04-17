-- ============================================================
-- 05 — SOUS-REQUÊTES & CTEs (WITH)
-- Schémas : contact, inscription, stage
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================


-- ------------------------------------------------------------
-- 5.1 Sous-requête scalaire — Session avec la date la plus récente
-- Objectif : trouver la dernière session ouverte
-- ------------------------------------------------------------
SELECT *
FROM stage.session ss
WHERE ss.datedebut = (
    SELECT MAX(datedebut)
    FROM stage.session
);


-- ------------------------------------------------------------
-- 5.2 NOT IN — Contacts sans aucune inscription
-- ⚠️  Attention : retourne 0 résultat si contactid contient des NULL
-- ------------------------------------------------------------
SELECT *
FROM contact.contact cc
WHERE cc.contactid NOT IN (
    SELECT ii.contactid
    FROM inscription.inscription ii
);


-- ------------------------------------------------------------
-- 5.3 NOT EXISTS — Version sûre de NOT IN (recommandée)
-- Objectif : contacts sans aucune inscription
-- Avantage : gère correctement les NULL
-- ------------------------------------------------------------
SELECT *
FROM contact.contact cc
WHERE NOT EXISTS (
    SELECT *
    FROM inscription.inscription ii
    WHERE cc.contactid = ii.contactid
);


-- ------------------------------------------------------------
-- 5.4 CTE simple (WITH) — Contacts hors sessions avec note = 20
-- Objectif : trouver les contacts qui n'ont jamais participé
--            à une session notée 20
-- Note     : la colonne "note" est dans stage.session
-- ------------------------------------------------------------
WITH s AS (
    -- Sessions où quelqu'un a eu 20
    SELECT ss.sessionid
    FROM stage.session ss
    WHERE ss.note = 20
),
i AS (
    -- Contacts qui ne sont dans aucune de ces sessions
    SELECT ii.contactid
    FROM inscription.inscription ii
    WHERE NOT EXISTS (
        SELECT 1 FROM s
        WHERE s.sessionid = ii.sessionid
    )
)
SELECT *
FROM contact.contact cc
WHERE cc.contactid IN (SELECT contactid FROM i)
ORDER BY cc.nom;


-- ------------------------------------------------------------
-- 5.5 CTE chaînée — Version avec NOT IN (plus lisible mais risquée)
-- ⚠️  Utiliser NOT EXISTS si sessionid peut être NULL
-- ------------------------------------------------------------
WITH s AS (
    SELECT ss.sessionid
    FROM stage.session ss
    WHERE ss.note = 20
),
i AS (
    SELECT ii.contactid
    FROM inscription.inscription ii
    WHERE sessionid NOT IN (SELECT sessionid FROM s)
)
SELECT *
FROM contact.contact cc
WHERE cc.contactid IN (SELECT contactid FROM i)
ORDER BY cc.nom;

-- Règle : préférer NOT EXISTS à NOT IN en production


-- ------------------------------------------------------------
-- 5.6 EXISTS + NOT EXISTS combinés
-- Objectif : contacts inscrits en 2019 mais PAS en 2020
-- ------------------------------------------------------------
SELECT COUNT(*) AS nb_contacts
FROM contact.contact cc
WHERE EXISTS (
    SELECT *
    FROM inscription.inscription ii
    JOIN stage.session ss ON ss.sessionid = ii.sessionid
    WHERE EXTRACT(YEAR FROM ss.datedebut) = 2019
    AND ii.contactid = cc.contactid
)
AND NOT EXISTS (
    SELECT *
    FROM inscription.inscription ii
    JOIN stage.session ss ON ss.sessionid = ii.sessionid
    WHERE EXTRACT(YEAR FROM ss.datedebut) = 2020
    AND ii.contactid = cc.contactid
);


-- ------------------------------------------------------------
-- 5.7 CTE RECURSIVE — Hiérarchie employé / chef
-- Objectif : parcourir l'arbre hiérarchique depuis l'employé 1
-- Note     : RECURSIVE obligatoire sur PostgreSQL
-- ------------------------------------------------------------
WITH RECURSIVE cte AS (

    -- Ancre : point de départ
    SELECT
        e1.employeid,
        e1.nom,
        e1.chefid,
        0 AS niveau
    FROM public.employe e1
    WHERE e1.employeid = 1

    UNION ALL

    -- Récursion : descendre d'un niveau à chaque itération
    SELECT
        e2.employeid,
        e2.nom,
        e2.chefid,
        cte.niveau + 1
    FROM public.employe e2
    JOIN cte ON cte.employeid = e2.chefid
    WHERE cte.niveau < 10       -- sécurité anti boucle infinie
)
SELECT *
FROM cte
ORDER BY niveau, nom;
