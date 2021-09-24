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