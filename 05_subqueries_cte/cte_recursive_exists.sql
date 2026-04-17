-- ============================================================
-- 05b — CTE RÉCURSIVE, EXISTS, NOT EXISTS, VIEWS
-- Schémas : contact, inscription, stage, public
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================


-- ------------------------------------------------------------
-- 5.6 CTE RÉCURSIVE — Hiérarchie employés
-- ------------------------------------------------------------
WITH RECURSIVE cte AS (
    SELECT e1.employeid, e1.nom, e1.chefid, 0 AS niveau
    FROM public.employe e1
    WHERE e1.employeid = 1

    UNION ALL

    SELECT e2.employeid, e2.nom, e2.chefid, cte.niveau + 1
    FROM public.employe e2
    JOIN cte ON cte.employeid = e2.chefid
)
SELECT *
FROM cte
ORDER BY niveau, nom;


-- ------------------------------------------------------------
-- 5.7 EXISTS — Contacts inscrits en 2019
-- ------------------------------------------------------------
SELECT COUNT(*) AS nb_contacts
FROM contact.contact cc
WHERE EXISTS (
    SELECT *
    FROM inscription.inscription ii
    JOIN stage.session ss ON ss.sessionid = ii.sessionid
    WHERE ii.contactid = cc.contactid
    AND EXTRACT(YEAR FROM ss.datedebut) = 2019
);


-- ------------------------------------------------------------
-- 5.8 EXISTS + NOT EXISTS — Inscrits 2019 pas en 2020
-- Version 1 : avec les tables directement
-- ------------------------------------------------------------
SELECT COUNT(*) AS nb_contacts
FROM contact.contact cc
WHERE EXISTS (
    SELECT *
    FROM inscription.inscription ii
    JOIN stage.session ss ON ss.sessionid = ii.sessionid
    WHERE ii.contactid = cc.contactid
    AND EXTRACT(YEAR FROM ss.datedebut) = 2019
)
AND NOT EXISTS (
    SELECT *
    FROM inscription.inscription ii
    JOIN stage.session ss ON ss.sessionid = ii.sessionid
    WHERE ii.contactid = cc.contactid
    AND EXTRACT(YEAR FROM ss.datedebut) = 2020
);


-- ------------------------------------------------------------
-- 5.9 EXISTS + NOT EXISTS — Version 2 : avec vue_session
-- Objectif : même résultat mais plus lisible
-- ------------------------------------------------------------
SELECT COUNT(*) AS nb_contacts
FROM contact.contact cc
WHERE EXISTS (
    SELECT *
    FROM vue_session vs
    WHERE EXTRACT(YEAR FROM vs.datedebut) = 2019
    AND vs.contactid = cc.contactid
)
AND NOT EXISTS (
    SELECT *
    FROM vue_session vs
    WHERE EXTRACT(YEAR FROM vs.datedebut) = 2020
    AND vs.contactid = cc.contactid
);


-- ------------------------------------------------------------
-- 5.10 EXCEPT — Alternative à EXISTS + NOT EXISTS
-- ------------------------------------------------------------
SELECT COUNT(*) AS nb_contacts
FROM (
    SELECT nom, prenom, email
    FROM vcontact2
    WHERE datecreation BETWEEN '2019-01-01' AND '2019-12-31'
    GROUP BY nom, prenom, email

    EXCEPT

    SELECT nom, prenom, email
    FROM vcontact2
    WHERE datecreation BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY nom, prenom, email
) resultat;
