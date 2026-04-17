-- ============================================================
-- 06 — TRANSACTIONS, DELETE, MERGE
-- Schémas : contact, public
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================
-- ⚠️  ATTENTION : ces commandes modifient les données
--     Toujours tester avec un SELECT avant d'exécuter
-- ============================================================


-- ------------------------------------------------------------
-- 6.1 TRANSACTION — Modifier et valider ou annuler
-- Objectif : mettre à jour un nom en sécurité
-- ------------------------------------------------------------
BEGIN;                          -- démarre la transaction

UPDATE contact.contact
SET nom = 'NouveauNom'
WHERE contactid = 1;

-- Si tout est bon :
COMMIT;

-- Si on veut annuler :
-- ROLLBACK;

-- Note PostgreSQL : pas de "START TRANSACTION" — utiliser BEGIN
-- START TRANSACTION fonctionne aussi mais BEGIN est la norme


-- ------------------------------------------------------------
-- 6.2 DELETE — Supprimer une ligne
-- ⚠️  Toujours vérifier avec SELECT avant de supprimer
-- ------------------------------------------------------------

-- Vérifier d'abord
SELECT *
FROM contact.contact
WHERE contactid = 23;

-- Supprimer ensuite
BEGIN;
DELETE FROM contact.contact
WHERE contactid = 23;     -- ⚠️ "contactid" pas "conctactid" (faute de frappe corrigée)
COMMIT;


-- ------------------------------------------------------------
-- 6.3 CREATE TABLE AS SELECT — Copier une table
-- Objectif : créer une copie de la table employe
-- ⚠️  Pas de ROLLBACK possible sur DDL (CREATE/DROP)
--     En revanche le SELECT est annulable dans une transaction
-- ------------------------------------------------------------
CREATE TABLE public.employe2 AS
SELECT *
FROM public.employe;

-- Vérifier la copie
SELECT COUNT(*) FROM public.employe2;

-- Supprimer si besoin
-- DROP TABLE IF EXISTS public.employe2;


-- ------------------------------------------------------------
-- 6.4 MERGE — Synchroniser deux tables
-- Objectif : mettre à jour contact si email existe dans prospectus
--            insérer sinon
-- Note     : MERGE disponible depuis PostgreSQL 15
-- ------------------------------------------------------------
MERGE INTO contact.contact cc
USING (
    SELECT nom, prenom, email
    FROM contact.prospectus
) s
ON s.email = cc.email
WHEN MATCHED THEN
    UPDATE SET
        nom    = s.nom,
        prenom = s.prenom
WHEN NOT MATCHED THEN
    INSERT (nom, prenom, email)
    VALUES (s.nom, s.prenom, s.email);  -- "s.email" corrigé (faute de frappe)


-- ------------------------------------------------------------
-- Rappel des commandes de transaction
-- ------------------------------------------------------------
-- BEGIN        → démarre une transaction
-- COMMIT       → valide les changements
-- ROLLBACK     → annule les changements
-- SAVEPOINT    → point de sauvegarde intermédiaire
