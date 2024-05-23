-- 1.
GRANT ALL PRIVILEGES ON dbexercices_q2.* TO 'user1'@'localhost' IDENTIFIED BY 'password1';
FLUSH PRIVILEGES;

START TRANSACTION;
INSERT INTO evenement(nomevent, dateevent, id) VALUES 
	('Nouvel Événement', '2024-06-01 12:00:00', 1);
SAVEPOINT pt_sauvegarde;
INSERT INTO participation(numcli, nomevent) VALUES 
	(1, 'Nouvel Événement'),
    (2, 'Nouvel Événement'),
    (3, 'Nouvel Événement');

-- Annuler ajout des participants	
ROLLBACK TO pt_sauvegarde;
-- Annuler toute la transaction
ROLLBACK;

-- 2.
START TRANSACTION;
LOCK TABLES client READ, participation READ, evenement WRITE;

UPDATE evenement
SET dateevent = DATE_ADD(dateevent, INTERVAL 1 DAY)
WHERE nomevent IN (
    SELECT DISTINCT p.nomevent
    FROM client c
    JOIN participation p ON c.numcli = p.numcli
    WHERE c.nomcli LIKE 'C%'
);

COMMIT;
UNLOCK TABLES;

-- 3.
START TRANSACTION;
SELECT * FROM evenement;

UPDATE evenement
SET dateevent = '2024-05-23 15:00:00'
WHERE nomevent = 'Dédicace BD';
COMMIT;

START TRANSACTION;
SELECT * FROM evenement
WHERE nomevent = 'Dédicace BD';
COMMIT;