/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".

SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.

SELECT * FROM animals
WHERE (SELECT EXTRACT(YEAR FROM date_of_birth)) BETWEEN 2016 AND 2019;

-- List the name of all animals that are neutered and have less than 3 escape attempts.

SELECT * FROM animals
WHERE neutered AND escape_attempts < 3;

-- List date of birth of all animals named either "Agumon" or "Pikachu".

SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg

SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.

SELECT * FROM animals
WHERE neutered;

-- Find all animals not named Gabumon.

SELECT * FROM  animals
WHERE name NOT LIKE 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)

SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction.

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

-- Inside a transaction:
-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
-- Commit the transaction.
-- Verify that change was made and persists after commit.

BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species = '';

COMMIT;

-- Inside a transaction delete all records in the animals table, then roll back the transaction.
-- After the roll back verify if all records in the animals table still exist.

BEGIN;
DELETE FROM animals;
ROLLBACK;

-- Inside a transaction:
-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
-- Update all animals' weight to be their weight multiplied by -1.
-- Rollback to the savepoint
-- Update all animals' weights that are negative to be their weight multiplied by -1.
-- Commit transaction

BEGIN;

DELETE FROM animals
WHERE date_of_birth > '01/01/2022';

SAVEPOINT del_dob_after_01012022;

UPDATE animals
SET weight_kg = (weight_kg * -1);

ROLLBACK TO del_dob_after_01012022;

UPDATE animals
SET weight_kg = (weight_kg * -1)
WHERE weight_kg < 0;

COMMIT;

-- How many animals are there?

SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?

SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?

SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?

SELECT neutered, SUM(escape_attempts) 
FROM animals
GROUP BY neutered
ORDER BY SUM DESC
LIMIT 1;

-- What is the minimum and maximum weight of each type of animal?

SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species, AVG(escape_attempts)
FROM animals
WHERE (SELECT extract(YEAR FROM date_of_birth)) BETWEEN 1990 AND 2000
GROUP BY species;