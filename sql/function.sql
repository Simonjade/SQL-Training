-- fonction pour retourner la population par ville
CREATE OR REPLACE FUNCTION cities_population() RETURNS TABLE("Nom de la ville" text,Population int) AS $$
SELECT city.name,COUNT(city.id)::int FROM city
JOIN person ON person.city_id = city.id
GROUP BY city.name;
$$ LANGUAGE SQL

-- fonction pour retourner la population d'une ville précise
CREATE OR REPLACE FUNCTION city_population(s text) RETURNS int AS $$
SELECT COUNT(person.id)::int FROM person
JOIN city ON person.city_id = city.id
WHERE city.name = s
$$ LANGUAGE SQL

-- fonction qui retourne les deux parents d'un enfant
CREATE OR REPLACE FUNCTION get_parent(c int) RETURNS TABLE(prenom text, nom text) AS $$
SELECT firstname,lastname FROM person
JOIN relationship ON relationship.parent = person.id
WHERE child = c
$$ LANGUAGE SQL

-- fonction qui retourne un parent ou un enfant suivant son statut
CREATE OR REPLACE FUNCTION get_status(f text,l text) RETURNS text AS $$
DECLARE r RECORD;
BEGIN
SELECT child,parent,person.id INTO r FROM person
JOIN relationship ON child = person.id OR parent = person.id
WHERE firstname = f AND lastname = l
LIMIT 1;

IF r.child = r.id
THEN RETURN 'enfant';
ELSE RETURN 'parent';
END IF;

END;
$$ LANGUAGE plpgsql

-- fonction qui retourne l'ensemble de la famille d'une personne suivant son nom/prenom
CREATE OR REPLACE FUNCTION get_relatives(f text,l text) RETURNS TABLE("prénom" text,"nom" text) AS $$
DECLARE t text;
DECLARE id_temp int;
BEGIN
SELECT get_status(f,l) into t;
IF t = 'enfant'
THEN
    RETURN QUERY SELECT firstname,lastname FROM person
    WHERE id IN (
        SELECT relationship.parent FROM person
        JOIN relationship ON child = person.id
        WHERE firstname = f AND lastname = l
    );
ELSE
    RETURN QUERY SELECT firstname,lastname FROM person
    WHERE id IN (
        SELECT relationship.child FROM person
        JOIN relationship ON parent = person.id
        WHERE firstname = f AND lastname = l
    );
END IF;

END;
$$ LANGUAGE plpgsql

-- fonction pour trouver un nom de famille qui contient le param de la fonction
CREATE FUNCTION get_family(t text) RETURNS SETOF text AS $$
select distinct lastname as "nom de famille" from person
where lastname ~* ('^.*' || t || '.*$')
order by lastname
$$ LANGUAGE SQL