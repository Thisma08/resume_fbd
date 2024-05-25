-- 1.
CREATE OR REPLACE VIEW vue_participants_event AS
SELECT 
    e.id AS id_magasin,
    e.nomevent,
    COUNT(p.numcli) AS nb_participants
FROM 
    evenement e
LEFT JOIN 
    participation p ON e.nomevent = p.nomevent
GROUP BY 
    e.id, e.nomevent;

CREATE OR REPLACE VIEW vue_evenements_par_magasin AS
SELECT 
    m.id AS id_magasin,
    m.nommag AS nom_magasin,
    m.codepostal AS cp_magasin,
    GROUP_CONCAT(CONCAT(e.nomevent, ': ', e.nb_participants) ORDER BY e.nomevent SEPARATOR ', ') AS evenements
FROM 
    magasin m
LEFT JOIN 
    vue_participants_event e ON m.id = e.id_magasin
GROUP BY 
    m.id, m.nommag, m.codepostal
ORDER BY 
    m.id;

-- 2.
CREATE VIEW vue_articles_magasins AS
SELECT 
    a.id AS id_art, 
    a.libelle AS libelle_art, 
    IFNULL(GROUP_CONCAT(m.nommag ORDER BY m.nommag SEPARATOR ', '), 'pas vendu') AS magasins_vendeurs
FROM 
    article a
LEFT JOIN 
    articleenvente av ON a.id = av.idart
LEFT JOIN 
    magasin m ON av.idmag = m.id
GROUP BY 
    a.id, a.libelle;

-- 3.
CREATE VIEW ArticlesNonEnVente AS
SELECT a.id AS id_art, a.libelle AS libelle_art
FROM article a
WHERE NOT EXISTS (
    SELECT 1
    FROM articleenvente ae
    WHERE a.id = ae.idart
);

-- L'algorithme MERGE ne peut pas être appliqué à cette vue 
-- car elle utilise une sous-requête avec NOT EXISTS.

-- 4.
CREATE VIEW ArticlesNonEnVenteMaisAchetes AS
SELECT a.id AS id_art, a.libelle AS libelle_art
FROM article a
WHERE NOT EXISTS (
    SELECT 1
    FROM articleenvente ae
    WHERE a.id = ae.idart
)
AND EXISTS (
    SELECT 1
    FROM detailachat da
    WHERE a.id = da.idart
);