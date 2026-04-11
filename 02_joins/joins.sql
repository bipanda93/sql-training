-- ============================================================
-- 02 — JOINTURES : JOIN, LEFT JOIN, SELF JOIN
-- Schémas : contact, inscription, stage
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================


-- ------------------------------------------------------------
-- 2.1 INNER JOIN — Contacts avec leurs inscriptions
-- Objectif : relier contact et inscription sur contactid
-- ------------------------------------------------------------
SELECT 
    c.nom, 
    c.contactid, 
    c.prenom,
    i.inscriptionid, 
    i.sessionid, 
    i.contactid
FROM contact.contact c
JOIN inscription.inscription i ON c.contactid = i.contactid
WHERE i.contactid = 5544;


-- ------------------------------------------------------------
-- 2.2 TRIPLE JOIN — Contacts inscrits en 2011 ET en 2012
-- Objectif : trouver les contacts présents les deux années
-- ------------------------------------------------------------
SELECT *
FROM contact.contact c
JOIN inscription.inscription i  ON c.contactid = i.contactid
JOIN stage.session s            ON i.sessionid  = s.sessionid
    AND EXTRACT(YEAR FROM s.datedebut) = 2011
JOIN inscription.inscription i2 ON c.contactid = i2.contactid
JOIN stage.session s2           ON i2.sessionid = s2.sessionid
    AND EXTRACT(YEAR FROM s2.datedebut) = 2012;


-- ------------------------------------------------------------
-- 2.3 LEFT JOIN — Tous les contacts avec leurs sessions
--                 (NULL si pas d'inscription)
-- ------------------------------------------------------------
SELECT *
FROM contact.contact c
LEFT JOIN inscription.inscription i ON c.contactid = i.contactid
LEFT JOIN stage.session s           ON i.sessionid  = s.sessionid;


-- ------------------------------------------------------------
-- 2.4 LEFT JOIN + IS NULL — Contacts sans aucune inscription
-- Objectif : anti-jointure, équivalent de NOT IN mais plus sûr
-- ------------------------------------------------------------
SELECT c.*
FROM contact.contact c
LEFT JOIN inscription.inscription i ON c.contactid = i.contactid
WHERE i.inscriptionid IS NULL;


-- ------------------------------------------------------------
-- 2.5 JOIN sur conditions multiples — Contacts = Prospects
-- Objectif : trouver les personnes présentes dans les deux tables
-- ------------------------------------------------------------
SELECT *
FROM contact.contact c
JOIN contact.prospectus p ON c.nom = p.nom 
                         AND c.prenom = p.prenom;


-- ------------------------------------------------------------
-- 2.6 SELF JOIN — Sessions en doublon sur la même date
-- Objectif : détecter deux sessions d'un même stage
--            qui débutent le même jour
-- ------------------------------------------------------------
SELECT *
FROM stage.stage ss
JOIN stage.session se  ON ss.stageid = se.stageid
JOIN stage.session s2  ON ss.stageid = s2.stageid
WHERE se.datedebut  = s2.datedebut
  AND se.sessionid <> s2.sessionid;


-- ------------------------------------------------------------
-- 2.7 JOIN simple — Stages avec leurs sessions triées par date
-- ------------------------------------------------------------
SELECT *
FROM stage.stage ss
JOIN stage.session se ON ss.stageid = se.stageid
ORDER BY datedebut ASC;
