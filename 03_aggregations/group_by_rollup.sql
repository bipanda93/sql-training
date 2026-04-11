-- ============================================================
-- 03 — AGRÉGATIONS : GROUP BY, HAVING, ROLLUP
-- Schémas : contact, inscription
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================


-- ------------------------------------------------------------
-- 3.1 COUNT simple
-- ------------------------------------------------------------
SELECT COUNT(*)
FROM contact.contact;

SELECT COUNT(*)
FROM contact.contact
WHERE nom LIKE 'C%';


-- ------------------------------------------------------------
-- 3.2 Fonctions d'agrégation combinées
-- Objectif : statistiques sur les noms commençant par C
-- ------------------------------------------------------------
SELECT 
    COUNT(*)            AS nb,
    MIN(nom)            AS premier_nom,
    MAX(nom)            AS dernier_nom,
    AVG(LENGTH(nom))    AS longueur_moyenne,
    SUM(LENGTH(nom))    AS longueur_totale
FROM contact.contact
WHERE nom LIKE 'C%';


-- ------------------------------------------------------------
-- 3.3 GROUP BY sur première lettre
-- Objectif : statistiques par initiale de nom
-- ------------------------------------------------------------
SELECT 
    SUBSTRING(nom, 1, 1)    AS initiale,
    COUNT(*)                AS nb,
    MIN(nom)                AS premier_nom,
    MAX(nom)                AS dernier_nom,
    AVG(LENGTH(nom))        AS longueur_moyenne,
    SUM(LENGTH(nom))        AS longueur_totale
FROM contact.contact
GROUP BY SUBSTRING(nom, 1, 1);


-- ------------------------------------------------------------
-- 3.4 GROUP BY + HAVING — Filtrer après regroupement
-- Objectif : initiales avec plus de 1000 contacts
-- ------------------------------------------------------------
SELECT 
    SUBSTRING(nom, 1, 1)    AS initiale,
    COUNT(*)                AS nb,
    MIN(nom)                AS premier_nom,
    MAX(nom)                AS dernier_nom,
    AVG(LENGTH(nom))        AS longueur_moyenne,
    SUM(LENGTH(nom))        AS longueur_totale
FROM contact.contact
GROUP BY SUBSTRING(nom, 1, 1)
HAVING COUNT(*) > 1000
ORDER BY COUNT(*) DESC;


-- ------------------------------------------------------------
-- 3.5 GROUP BY sur dates — CA mensuel
-- Objectif : chiffre d'affaires par mois et par année
-- ------------------------------------------------------------
SELECT 
    EXTRACT(YEAR  FROM ff.datefacture)  AS annee,
    EXTRACT(MONTH FROM ff.datefacture)  AS mois,
    SUM(montantht)                      AS CA
FROM inscription.facture ff
WHERE datefacture >= '2000-01-01'
GROUP BY 
    EXTRACT(YEAR  FROM ff.datefacture),
    EXTRACT(MONTH FROM ff.datefacture)
ORDER BY annee, mois;


-- ------------------------------------------------------------
-- 3.6 ROLLUP — Sous-totaux par année + total général
-- Objectif : CA mensuel + total annuel + total général
-- Note    : ROLLUP remplace WITH ROLLUP de MySQL
-- ------------------------------------------------------------
SELECT 
    CASE 
        WHEN GROUPING(EXTRACT(YEAR  FROM ff.datefacture)) = 1 
             THEN 'Total Général'
        WHEN GROUPING(EXTRACT(MONTH FROM ff.datefacture)) = 1 
             THEN CONCAT('Total ', EXTRACT(YEAR FROM ff.datefacture)::INT)
        ELSE CONCAT(
            EXTRACT(YEAR  FROM ff.datefacture)::INT, '-',
            LPAD(EXTRACT(MONTH FROM ff.datefacture)::TEXT, 2, '0')
        )
    END                 AS periode,
    SUM(montantht)      AS CA
FROM inscription.facture ff
WHERE datefacture >= '2000-01-01'
GROUP BY ROLLUP(
    EXTRACT(YEAR  FROM ff.datefacture),
    EXTRACT(MONTH FROM ff.datefacture)
)
ORDER BY 
    EXTRACT(YEAR  FROM ff.datefacture) NULLS LAST,
    EXTRACT(MONTH FROM ff.datefacture) NULLS LAST;


-- ------------------------------------------------------------
-- 3.7 GROUP BY + JOIN — Inscriptions par contact et par année
-- ------------------------------------------------------------
SELECT 
    cc.nom,
    cc.prenom,
    cc.contactid,
    COUNT(*)                                AS nb_inscriptions,
    EXTRACT(YEAR FROM ss.datedebut)::INT    AS annee,
    MIN(EXTRACT(YEAR FROM ss.datedebut))    AS premiere_annee
FROM inscription.inscription ii
JOIN contact.contact cc ON cc.contactid = ii.contactid
JOIN stage.session   ss ON ss.sessionid  = ii.sessionid
GROUP BY 
    cc.nom,
    cc.prenom,
    cc.contactid,
    EXTRACT(YEAR FROM ss.datedebut)
ORDER BY nom, prenom, annee;
