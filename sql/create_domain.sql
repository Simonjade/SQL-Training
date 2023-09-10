-- domaine pour les noms de familles/prénoms
CREATE DOMAIN first_letter_capitalized AS text
    CHECK (VALUE ~ '^[A-Z][a-z]*$');

-- on rajoute le fait d'voir un "-" dans le nom de famille
ALTER DOMAIN public.first_letter_capitalized DROP CONSTRAINT first_letter_capitalized_check;

ALTER DOMAIN public.first_letter_capitalized
    ADD CONSTRAINT first_letter_capitalized_check CHECK (VALUE ~ '^[A-Z][a-z]*(-[A-Z][a-z]*$)?');

    