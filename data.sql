/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts)
VALUES
  ('Agumon', '03/02/2020', 10.23, true, 0),
  ('Gabumon', '15/11/2018', 8, true, 2),
  ('Pikachu', '07/01/2021', 15.04, false, 1),
  ('Devimon', '12/05/2017', 11, true, 5);

INSERT INTO animals (name, date_of_birth,weight_kg, neutered, escape_attempts)
VALUES
  ('Charmander', '08/02/2020', -11, false, 0),
  ('Plantmon', '15/11/2022', -5.7, true, 2),
  ('Squirtle', '02/04/1993', -12.13, false, 3),
  ('Angemon', '12/06/2005', -45, true, 1),
  ('Boarmon', '07/06/2005', 20.4, true, 7),
  ('Blossom', '13/10/1998', 17, true, 3);

INSERT INTO owners(full_name, age)
VALUES
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

INSERT INTO species(name)
VALUES
 ('Pokemon'),
 ('Digimon');

-- Modify your inserted animals so it includes the species_id value:
-- If the name ends in "mon" it will be Digimon
-- All other animals are Pokemon

UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Digimon')
WHERE name LIKE '%mon';

UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Pokemon')
WHERE name NOT LIKE '%mon';

------------------------------------------------------------------------
-- Modify your inserted animals to include owner information (owner_id):
------------------------------------------------------------------------

-- Sam Smith owns Agumon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHERE name = 'Agumon';

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHERE name IN ('Gabumon', 'Pikachu');

-- Bob owns Devimon and Plantmon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Bob')
WHERE name IN ('Devimon', 'Plantmon'); --no Plantmon in database, deleted in milestone 2

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
WHERE name IN ('Angemon', 'Boarmon');

-- Insert the following data for vets:
-- Vet William Tatcher is 45 years old and graduated Apr 23rd, 2000.
-- Vet Maisy Smith is 26 years old and graduated Jan 17th, 2019.
-- Vet Stephanie Mendez is 64 years old and graduated May 4th, 1981.
-- Vet Jack Harkness is 38 years old and graduated Jun 8th, 2008.

INSERT INTO vets(name, age, date_of_graduation)
VALUES
 ('William Tatcher', 45, '23/04/2000'),
 ('Maisy Smith', 26, '17/01/2019'),
 ('Stephanie Mendez', 64, '04/05/1981'),
 ('Jack Harkness', 38, '08/06/2008');

-- Insert the following data for specialties:
-- Vet William Tatcher is specialized in Pokemon.
-- Vet Stephanie Mendez is specialized in Digimon and Pokemon.
-- Vet Jack Harkness is specialized in Digimon.

INSERT INTO specializations(vet_id, species_id)
VALUES
  ((SELECT id from vets WHERE name = 'William Tatcher'),
  (SELECT id from species WHERE name = 'Pokemon')),
  ((SELECT id from vets WHERE name = 'Stephanie Mendez'),
  (SELECT id from species WHERE name = 'Digimon')),
  ((SELECT id from vets WHERE name = 'Stephanie Mendez'),
  (SELECT id from species WHERE name = 'Pokemon')),
  ((SELECT id from vets WHERE name = 'Jack Harkness'),
  (SELECT id from species WHERE name = 'Digimon'));

-- Insert the following data for visits:
-- Agumon visited William Tatcher on May 24th, 2020.
-- Agumon visited Stephanie Mendez on Jul 22th, 2020.
-- Gabumon visited Jack Harkness on Feb 2nd, 2021.
-- Pikachu visited Maisy Smith on Jan 5th, 2020.
-- Pikachu visited Maisy Smith on Mar 8th, 2020.
-- Pikachu visited Maisy Smith on May 14th, 2020.
-- Devimon visited Stephanie Mendez on May 4th, 2021.
-- Charmander visited Jack Harkness on Feb 24th, 2021.
-- Plantmon visited Maisy Smith on Dec 21st, 2019.
-- Plantmon visited William Tatcher on Aug 10th, 2020.
-- Plantmon visited Maisy Smith on Apr 7th, 2021.
-- Squirtle visited Stephanie Mendez on Sep 29th, 2019.
-- Angemon visited Jack Harkness on Oct 3rd, 2020.
-- Angemon visited Jack Harkness on Nov 4th, 2020.
-- Boarmon visited Maisy Smith on Jan 24th, 2019.
-- Boarmon visited Maisy Smith on May 15th, 2019.
-- Boarmon visited Maisy Smith on Feb 27th, 2020.
-- Boarmon visited Maisy Smith on Aug 3rd, 2020.
-- Blossom visited Stephanie Mendez on May 24th, 2020.
-- Blossom visited William Tatcher on Jan 11th, 2021.

INSERT INTO visits(animal_id, vet_id, visit_date)
VALUES
  ((SELECT id FROM animals WHERE name = 'Agumon'),
  (SELECT id FROM vets WHERE name = 'William Tatcher'),
  '24/05/2020'),
  ((SELECT id FROM animals WHERE name = 'Agumon'),
  (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
  '22/07/2020'),
  ((SELECT id FROM animals WHERE name = 'Gabumon'),
  (SELECT id FROM vets WHERE name = 'Jack Harkness'),
  '02/02/2021'),
  ((SELECT id FROM animals WHERE name = 'Pikachu'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '05/01/2020'),
  ((SELECT id FROM animals WHERE name = 'Pikachu'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '08/03/2020'),
  ((SELECT id FROM animals WHERE name = 'Pikachu'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '14/05/2020'),
  ((SELECT id FROM animals WHERE name = 'Devimon'),
  (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
  '04/05/2021'),
  ((SELECT id FROM animals WHERE name = 'Charmander'),
  (SELECT id FROM vets WHERE name = 'Jack Harkness'),
  '24/02/2021'),
  ((SELECT id FROM animals WHERE name = 'Squirtle'),
  (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
  '29/09/2019'),
  ((SELECT id FROM animals WHERE name = 'Angemon'),
  (SELECT id FROM vets WHERE name = 'Jack Harkness'),
  '03/10/2020'),
  ((SELECT id FROM animals WHERE name = 'Angemon'),
  (SELECT id FROM vets WHERE name = 'Jack Harkness'),
  '04/11/2020'),
  ((SELECT id FROM animals WHERE name = 'Boarmon'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '24/01/2019'),
  ((SELECT id FROM animals WHERE name = 'Boarmon'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '15/05/2019'),
  ((SELECT id FROM animals WHERE name = 'Boarmon'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '27/02/2020'),
  ((SELECT id FROM animals WHERE name = 'Boarmon'),
  (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  '03/08/2020'),
  ((SELECT id FROM animals WHERE name = 'Blossom'),
  (SELECT id FROM vets WHERE name = 'Stephanie Mendez'),
  '24/05/2020'),
  ((SELECT id FROM animals WHERE name = 'Blossom'),
  (SELECT id FROM vets WHERE name = 'William Tatcher'),
  '11/01/2021');

  --   ((SELECT id FROM animals WHERE name = 'Plantmon'),
  -- (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  -- '21/12/2019'),
  -- ((SELECT id FROM animals WHERE name = 'Plantmon'),
  -- (SELECT id FROM vets WHERE name = 'William Tatcher'),
  -- '10/08/2020'),
  -- ((SELECT id FROM animals WHERE name = 'Plantmon'),
  -- (SELECT id FROM vets WHERE name = 'Maisy Smith'),
  -- '07/04/2021'),