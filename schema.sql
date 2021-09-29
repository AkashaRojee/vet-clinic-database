/* Database schema to keep the structure of entire database. */

CREATE DATABASE vet_clinic;

CREATE TABLE animals(
 id               INT GENERATED ALWAYS AS IDENTITY,
 name             VARCHAR(25),
 date_of_birth    DATE,
 escape_attempts  INT,
 neutered         BOOLEAN,
 weight_kg        DECIMAL(4, 2),
 PRIMARY KEY (id)
);

ALTER TABLE animals
ADD COLUMN
  species VARCHAR(25);

CREATE TABLE owners(
  id        INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(50),
  age       INT,
  PRIMARY KEY (id)
);

CREATE TABLE species(
  id  INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(25),
  PRIMARY KEY (id)
);

------------------------
-- Modify animals table:
------------------------

-- Remove column species

ALTER TABLE animals
DROP COLUMN species;

-- Add column species_id which is a foreign key referencing species table

ALTER TABLE animals
ADD COLUMN
  species_id INT,
ADD CONSTRAINT constraint_species_id
  FOREIGN KEY (species_id)
  REFERENCES species(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- Add column owner_id which is a foreign key referencing the owners table

ALTER TABLE animals
ADD COLUMN
  owner_id INT,
ADD CONSTRAINT constraint_owner_id
  FOREIGN KEY (owner_id)
  REFERENCES owners(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- Create a table named vets with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- name: string
-- age: integer
-- date_of_graduation: date

CREATE TABLE vets(
  id                  INT GENERATED ALWAYS AS IDENTITY,
  name                VARCHAR(50),
  age                 INT,
  date_of_graduation  DATE,
  PRIMARY KEY (id)
);

-- There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship.

CREATE TABLE specializations(
  vet_id  INT,
  species_id  INT,
  PRIMARY KEY (vet_id, species_id),
  CONSTRAINT constraint_vet_id
    FOREIGN KEY (vet_id)
    REFERENCES vets(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT constraint_species_id
    FOREIGN KEY (species_id)
    REFERENCES species(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets and one vet can be visited by multiple animals. Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit.

CREATE TABLE visits(
  vet_id      INT,
  animal_id   INT,
  visit_date  DATE,
  PRIMARY KEY (vet_id, animal_id, visit_date),
  CONSTRAINT constraint_vet_id
    FOREIGN KEY (vet_id)
    REFERENCES vets(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT constraint_animal_id
    FOREIGN KEY (animal_id)
    REFERENCES animals(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);