-- 1
-- Création des utilisateurs
CREATE USER 'user1'@'localhost' IDENTIFIED WITH mysql_native_password BY 'user';
CREATE USER 'user2'@'localhost' IDENTIFIED WITH sha256_password BY 'user';

-- Vérification des méthodes de cryptage
USE mysql;
SELECT user, plugin FROM user WHERE user IN ('user1', 'user2');

-- 2.
-- Attribution des privilèges
-- Accorder des privilèges sur toutes les tables individuellement sauf participation
GRANT ALL PRIVILEGES ON dbexercices_q2.magasin TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.evenement TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.localite TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.employe TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.client TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.article TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.articleenvente TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.achat TO 'user1'@'localhost';
GRANT ALL PRIVILEGES ON dbexercices_q2.detailachat TO 'user1'@'localhost';

-- Pourquoi ne puis-je pas retirer les droits sur une table si j'ai au préalable accordé un
-- privilège sur toutes la base de données ?
 
-- Lorsque des privilèges sont accordés globalement sur une base de données (dbexercices_q2.*),
-- cela inclut tous les objets (tables) dans cette base de données. Les privilèges accordés
-- au niveau de la base de données ne peuvent pas être retirés pour des objets individuels comme une table spécifique.

-- Vérification des privilèges
USE mysql;
SELECT * FROM user WHERE user = 'user1';

-- Commande alternative pour voir les droits à partir de 'root'
SHOW GRANTS FOR 'user1'@'localhost';

-- 3.
-- Attribution des privilèges
GRANT SELECT ON dbexercices_q2.* TO 'user2'@'localhost';
GRANT INSERT ON dbexercices_q2.participation TO 'user2'@'localhost';
GRANT LOCK TABLES ON dbexercices_q2.* TO 'user2'@'localhost';
GRANT CREATE TABLE ON *.* TO 'user2'@'localhost';

-- Vérification des privilèges
USE mysql;
SELECT * FROM user WHERE user = 'user2';

