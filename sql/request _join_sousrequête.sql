-- Nombre d'habitant de chaque ville
--version sous requête
SELECT id, name, 
(SELECT count (city_id) FROM person WHERE city_id = city.id GROUP BY city_id) 
FROM city;
-- version join
SELECT city.name, count(person.id) FROM city
JOIN person ON person.city_id = city.id
GROUP BY city.name
ORDER BY count(person.id) DESC;


-- personne vivant à Paris
-- version sous requête
SELECT firstname, lastname 
FROM person 
WHERE city_id = (
    SELECT id FROM city WHERE name= 'Paris'
    )
-- version join
SELECT person.firstname,person.lastname FROM person
JOIN city ON city.id = person.city_id
WHERE city.name = 'Paris'

-- la ville qui contient le plus de personnes
-- version avec sous requête
SELECT city.name, COUNT(person.id) AS population
FROM city
JOIN person ON person.city_id = city.id
GROUP BY city.name
HAVING COUNT(person.id) = 
    (SELECT MAX(population_count) 
    FROM (
        SELECT COUNT(person.id) AS population_count 
        FROM city 
        JOIN person ON person.city_id = city.id 
        GROUP BY city.name) AS population);
-- version join
SELECT city.name,COUNT(person.id) as population FROM person
JOIN city ON city.id = person.city_id
GROUP BY city.name
ORDER BY population DESC
LIMIT 1    

-- nombre de parent
-- version sans join
SELECT COUNT(DISTINCT parent)
FROM relationship;

-- version join
SELECT COUNT(person.id) FROM person
WHERE person.id IN (
    SELECT DISTINCT relationship.parent FROM relationship
)

-- la ville qui contient le plus d'enfants
-- versions sous requête
SELECT city.name FROM city
WHERE city.id IN (
    SELECT city_id FROM person
    WHERE person.id IN (
        SELECT DISTINCT relationship.child FROM relationship
    )
    GROUP BY city_id
    ORDER BY COUNT(city_id) DESC
    LIMIT 1
);

