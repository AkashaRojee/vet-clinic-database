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

----------------------------------------------------------------
-- Write queries (using JOIN) to answer the following questions:
----------------------------------------------------------------

-- What animals belong to Melody Pond?

SELECT name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).

SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.

SELECT full_name, name
FROM animals
FULL JOIN owners ON owner_id = owners.id;

-- How many animals are there per species?

SELECT species.name, COUNT(*)
FROM animals
JOIN species ON species_id = species.id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.

SELECT animals.name
FROM animals
JOIN owners ON owner_id = owners.id
JOIN species on species_id = species.id
WHERE full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.

SELECT animals.name
FROM animals
JOIN owners on owner_id = owners.id
WHERE full_name = 'Dean Winchester' AND escape_attempts = 0;

-- Who owns the most animals?

SELECT full_name, COUNT(*)
FROM animals
JOIN owners ON owner_id = owners.id
GROUP BY full_name
ORDER BY COUNT DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?

SELECT animals.name, visit_date
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?

SELECT COUNT(DISTINCT animals.name)
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.

SELECT vets.name AS vet, species.name AS specialization
FROM vets
FULL JOIN specializations ON id = specializations.vet_id
FULL JOIN species ON species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

SELECT animals.name, visit_date
FROM animals
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez' AND visit_date BETWEEN '01/04/2020' AND '30/08/2020';

-- What animal has the most visits to vets?

SELECT animals.name, COUNT(*)
FROM visits
JOIN animals ON animal_id = animals.id
GROUP BY animals.name
ORDER BY COUNT DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?

SELECT animals.name, visit_date
FROM visits
JOIN vets ON vet_id = vets.id
JOIN animals ON animal_id = animals.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visit_date ASC
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.

SELECT
  visit_date,
  animal_id, a.name AS animal_name, a.date_of_birth, a.escape_attempts, a.neutered, a.weight_kg,
  vet_id, v.name AS vet_name, v.age AS vet_age, v.date_of_graduation
FROM visits
JOIN animals a ON animal_id = a.id
JOIN vets v ON vet_id = v.id
ORDER BY visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(vets.name)
FROM visits
JOIN vets ON vet_id = vets.id
WHERE vet_id NOT IN (SELECT vet_id FROM specializations);

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.

SELECT species.name
FROM visits
JOIN vets ON vet_id = vets.id
JOIN animals ON animal_id = animals.id
JOIN species ON species_id = species.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY COUNT(species.name) DESC
LIMIT 1;