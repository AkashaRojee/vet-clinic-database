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