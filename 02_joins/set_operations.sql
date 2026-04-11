-- ============================================================
-- 02 — OPÉRATIONS ENSEMBLISTES : UNION, INTERSECT, EXCEPT
-- Schéma : contact
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================
-- Règle : les deux SELECT doivent avoir le même nombre
--         de colonnes et les mêmes types de données
-- ============================================================


-- ------------------------------------------------------------
-- 3.1 UNION — Tous les noms (contacts + prospects, sans doublons)
-- ------------------------------------------------------------
SELECT c.nom, c.prenom, c.email
FROM contact.contact c
UNION
SELECT p.nom, p.prenom, p.email
FROM contact.prospectus p;


-- ------------------------------------------------------------
-- 3.2 INTERSECT — Personnes présentes dans les deux tables
-- Objectif : contacts qui sont aussi des prospects
-- ------------------------------------------------------------
SELECT c.nom, c.prenom, c.email
FROM contact.contact c
INTERSECT
SELECT p.nom, p.prenom, p.email
FROM contact.prospectus p;


-- ------------------------------------------------------------
-- 3.3 EXCEPT — Contacts qui ne sont PAS des prospects
-- Objectif : présents dans contact mais absents de prospectus
-- ------------------------------------------------------------
SELECT c.nom, c.prenom, c.email
FROM contact.contact c
EXCEPT
SELECT p.nom, p.prenom, p.email
FROM contact.prospectus p;
