# 📊 SQL Training — PostgreSQL

Répertoire de pratique SQL sur PostgreSQL dans le cadre du **Mastère Data Engineering**  
**Digital School de Paris — Promotion 2026**  
Auteur : **Bipanda Franck Ulrich**

---

## 🗂️ Structure du repo

```
sql-training/
├── 01_basics/               # SELECT, WHERE, CASE, LIKE, LIMIT
├── 02_joins/                # JOIN, LEFT JOIN, UNION, INTERSECT, EXCEPT
├── 03_aggregations/         # GROUP BY, HAVING, ROLLUP, COUNT, SUM, AVG
├── 04_window_functions/     # OVER, PARTITION BY, RANK, ROW_NUMBER, DENSE_RANK
└── 05_subqueries_cte/       # Sous-requêtes, WITH, NOT IN, NOT EXISTS
```

---

## 🛠️ Stack technique

- **SGBD** : PostgreSQL 17
- **Schémas** : `contact`, `inscription`, `stage`
- **Outils** : pgAdmin, DBeaver

---

## 📚 Concepts couverts

| Concept | Fichier |
|---|---|
| SELECT, WHERE, CASE WHEN | `01_basics/select_case.sql` |
| LIKE, ORDER BY | `01_basics/like_order.sql` |
| JOIN, LEFT JOIN | `02_joins/joins.sql` |
| UNION, INTERSECT, EXCEPT | `02_joins/set_operations.sql` |
| GROUP BY, HAVING, ROLLUP | `03_aggregations/group_by.sql` |
| Fonctions d'agrégation | `03_aggregations/aggregate_functions.sql` |
| SUM OVER, PARTITION BY | `04_window_functions/sum_over.sql` |
| RANK, ROW_NUMBER, DENSE_RANK | `04_window_functions/ranking.sql` |
| Sous-requêtes | `05_subqueries_cte/subqueries.sql` |
| CTE (WITH) | `05_subqueries_cte/cte.sql` |

---

## 🚀 Comment utiliser ce repo

```bash
git clone https://github.com/bipanda-franck/sql-training.git
cd sql-training
```

Ouvre les fichiers `.sql` dans pgAdmin ou DBeaver et exécute-les sur ta base PostgreSQL locale.

---

## 📈 Progression

- [x] Bases SQL (SELECT, WHERE, CASE)
- [x] Jointures (JOIN, LEFT JOIN, UNION)
- [x] Agrégations (GROUP BY, ROLLUP)
- [x] Window Functions (RANK, ROW_NUMBER, SUM OVER)
- [x] Sous-requêtes et CTEs
- [x] Transactions (BEGIN, COMMIT, ROLLBACK)
- [x] DELETE, CREATE TABLE AS
- [x] MERGE (upsert)
- [x] CTE Récursive
- [ ] Index et optimisation
- [ ] Procédures stockées
- [ ] Triggers
