-- P1
-- 1.
DELIMITER |

CREATE PROCEDURE compter_articles(
    IN startDate DATETIME,
    IN endDate DATETIME,
    OUT articleCount INT
)
BEGIN
    SELECT COUNT(DISTINCT idart) 
    INTO articleCount
    FROM detailachat
    WHERE dateachat BETWEEN startDate AND endDate;
END|

DELIMITER ;

CALL compter_articles('2020-03-26 00:00:00', '2020-03-29 12:00:00', @count);

SELECT @count AS nbre_articles_differents_achates;

-- 2.
DELIMITER |

CREATE PROCEDURE augmenter_prix_moyen_articles(IN prix_cible DECIMAL(8,2), OUT nombre_augmentations INT)
BEGIN
    DECLARE prix_moyen_actuel DECIMAL(8,2);
    DECLARE nombre_iterations INT DEFAULT 0;
    SELECT AVG(prixvente) INTO prix_moyen_actuel FROM article;
    WHILE prix_moyen_actuel < prix_cible DO
        UPDATE article
        SET prixvente = prixvente * 1.02;
        SELECT AVG(prixvente) INTO prix_moyen_actuel FROM article;
        SET nombre_iterations = nombre_iterations + 1;
    END WHILE;
    SET nombre_augmentations = nombre_iterations;
END |

DELIMITER ;

SET @nombre_augmentations = 0;

CALL augmenter_prix_moyen_articles(4.8, @nombre_augmentations);

SELECT @nombre_augmentations AS NombreAugmentations;

-- 3.
DELIMITER |

CREATE PROCEDURE dernier_samedi_du_mois(IN p_date DATE, OUT dernier_samedi DATE)
BEGIN
    DECLARE jour INT;
    DECLARE dernier_jour DATE;    
    SET dernier_jour = LAST_DAY(p_date);
    SET jour = DAYOFWEEK(dernier_jour);
    SET dernier_samedi = DATE_SUB(dernier_jour, INTERVAL (jour % 7) DAY);
END |

DELIMITER ;

SET @dernier_samedi = NULL;

CALL dernier_samedi_du_mois('2021-03-10', @dernier_samedi);
SELECT @dernier_samedi AS 'dernier_samedi_mars_2021';

CALL dernier_samedi_du_mois('2016-04-02', @dernier_samedi);
SELECT @dernier_samedi AS 'dernier_samedi_avril_2016';

-- P2
-- 1.
DELIMITER |

CREATE PROCEDURE supprimer_evenement_limite_client(
    IN eventName VARCHAR(50),
    IN minParticipants INT
)
BEGIN
    DECLARE participantCount INT;
    SELECT COUNT(*) INTO participantCount
    FROM participation
    WHERE nomevent = eventName;
    IF participantCount < minParticipants THEN
        DELETE FROM participation
        WHERE nomevent = eventName;
        DELETE FROM evenement
        WHERE nomevent = eventName;
    END IF;
END |

DELIMITER ;

CALL supprimer_evenement_limite_client('Foire aux vins', 4);

SELECT * FROM evenement;
SELECT * FROM participation;

-- 2.
CREATE USER 'user_proc'@'localhost' IDENTIFIED BY 'proc';
GRANT EXECUTE ON dbexercices_q2.* TO 'user_proc'@'localhost';
GRANT SELECT ON dbexercices_q2.* TO 'user_proc'@'localhost';

DELIMITER |

CREATE PROCEDURE customer_summary(IN client_id INT) SQL SECURITY INVOKER
BEGIN
    DECLARE total_achats DECIMAL(8,2);
    DECLARE total_events INT;

    SELECT COUNT(*) INTO total_achats
    FROM achat
    WHERE numcli = client_id;

    SELECT COUNT(*) INTO total_events
    FROM participation
    WHERE numcli = client_id;

    SELECT SUM((prixachat * quantite * (1 - remise))) INTO total_achats
    FROM detailachat
    WHERE numcli = client_id;

    IF total_achats > 30 THEN
        SELECT CONCAT(nomcli, ' ', prenomcli, ' est un gros client') AS message;
    ELSE
        SELECT CONCAT(nomcli, ' ', prenomcli, ' est un client occasionnel') AS message;
    END IF;
END |

DELIMITER ;
