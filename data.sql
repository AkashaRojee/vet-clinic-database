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