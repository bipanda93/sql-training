-- ============================================================
-- 04 — WINDOW FUNCTIONS : OVER, PARTITION BY, RANK, ROW_NUMBER
-- Schéma : inscription
-- Auteur  : Bipanda Franck Ulrich
-- ============================================================
-- Rappel : les window functions calculent une valeur par ligne
--          SANS réduire le nombre de lignes (≠ GROUP BY)
-- ============================================================


-- ------------------------------------------------------------
-- 4.1 SUM OVER() global — Part de chaque facture sur le total
-- Objectif : montant + total global + % de contribution
-- ------------------------------------------------------------
SELECT 
    datefacture,
    montantht,
    SUM(montantht)  OVER ()                         AS total_global,
    ROUND(
        montantht / SUM(montantht) OVER () * 100, 2
    )                                               AS pct_total,
    COUNT(*)        OVER ()                         AS nb_total_factures
FROM inscription.facture ff
WHERE datefacture BETWEEN '2000-01-01' AND '2000-12-31'
ORDER BY datefacture;


-- ------------------------------------------------------------
-- 4.2 SUM OVER PARTITION BY — Total par mois sur chaque ligne
-- + RANK, ROW_NUMBER, DENSE_RANK comparés
-- ------------------------------------------------------------
SELECT 
    datefacture,
    montantht,
    SUM(montantht)  OVER (
        PARTITION BY EXTRACT(MONTH FROM ff.datefacture)
    )                                               AS total_mensuel,
    ROW_NUMBER()    OVER (ORDER BY montantht DESC)  AS row_num,
    RANK()          OVER (ORDER BY montantht DESC)  AS rang,
    DENSE_RANK()    OVER (ORDER BY montantht DESC)  AS rang_dense
FROM inscription.facture ff
WHERE datefacture BETWEEN '2000-01-01' AND '2000-12-31';

-- Différence ROW_NUMBER / RANK / DENSE_RANK en cas d'égalité :
-- montant 500 | ROW_NUMBER=1 | RANK=1 | DENSE_RANK=1
-- montant 500 | ROW_NUMBER=2 | RANK=1 | DENSE_RANK=1  <- égalité
-- montant 400 | ROW_NUMBER=3 | RANK=3 | DENSE_RANK=2  <- saut chez RANK


-- ------------------------------------------------------------
-- 4.3 % du CA mensuel sur CA annuel
-- Objectif : part de chaque mois dans son année
-- Technique : SUM(SUM()) OVER PARTITION — double agrégation
-- ------------------------------------------------------------
SELECT 
    EXTRACT(YEAR  FROM ff.datefacture)::INT     AS annee,
    EXTRACT(MONTH FROM ff.datefacture)::INT     AS mois,
    SUM(montantht)                              AS ca_mensuel,
    ROUND(
        SUM(montantht) 
        / SUM(SUM(montantht)) OVER (
            PARTITION BY EXTRACT(YEAR FROM ff.datefacture)
        ) * 100, 2
    )                                           AS pct_annuel
FROM inscription.facture ff
WHERE datefacture >= '2000-01-01'
GROUP BY 
    EXTRACT(YEAR  FROM ff.datefacture),
    EXTRACT(MONTH FROM ff.datefacture)
ORDER BY annee, mois;


-- ------------------------------------------------------------
-- 4.4 RANK OVER PARTITION — Première session de chaque année
-- Objectif : garder uniquement la session la plus ancienne
--            par année (rang 1 par partition)
-- ------------------------------------------------------------
SELECT *
FROM (
    SELECT 
        *,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM ss.datedebut)
            ORDER BY ss.datedebut ASC       -- trier par date pour départager
        ) AS R
    FROM stage.session ss
) s
WHERE s.R = 1;
