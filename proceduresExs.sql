-- 1.
DELIMITER |

CREATE PROCEDURE CountDistinctArticles(
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

CALL CountDistinctArticles('2020-03-26 00:00:00', '2020-03-29 12:00:00', @count);

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

CREATE PROCEDURE DernierSamediDuMois(IN p_date DATE, OUT dernier_samedi DATE)
BEGIN
    DECLARE jour INT;
    DECLARE dernier_jour DATE;    
    SET dernier_jour = LAST_DAY(p_date);
    SET jour = DAYOFWEEK(dernier_jour);
    SET dernier_samedi = DATE_SUB(dernier_jour, INTERVAL (jour % 7) DAY);
END |

DELIMITER ;

SET @dernier_samedi = NULL;

CALL DernierSamediDuMois('2021-03-10', @dernier_samedi);
SELECT @dernier_samedi AS 'dernier_samedi_mars_2021';

CALL DernierSamediDuMois('2016-04-02', @dernier_samedi);
SELECT @dernier_samedi AS 'dernier_samedi_avril_2016';



