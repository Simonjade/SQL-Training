-- view qui permet d'avoir le nombre d'enfant vivant dans la ville sélectionnée
CREATE VIEW children_by_city AS
     SELECT city_id AS id, COUNT(city_id) AS "nombre d''enfants" FROM person
    WHERE person.id IN (
        SELECT DISTINCT relationship.child FROM relationship
    )
    GROUP BY city_id
    ORDER BY COUNT(city_id) DESC

-- view qui permet d'avoir le nombre de parents vivant dans la ville sélectionnée
CREATE VIEW parents_by_city AS
     SELECT city_id AS id, COUNT(city_id) AS "nombre de parents" FROM person
    WHERE person.id IN (
        SELECT DISTINCT relationship.parent FROM relationship
    )
    GROUP BY city_id
    ORDER BY COUNT(city_id) DESC    

--views qui permet d'avoir la natalité par ville (en utilisant les deux views précédentes)
CREATE VIEW birthrate AS
    SELECT parents_by_city.id, "nombre d''enfants"::FLOAT / "nombre de parents"::FLOAT as "birthrate" from  parents_by_city
    JOIN children_by_city ON parents_by_city.id = children_by_city.id ;    

--exemple de requête qui utilise cette view
SELECT city.name FROM city
WHERE city.id IN (
    select id from birthrate
    ORDER BY birthrate DESC
    LIMIT 1
);    