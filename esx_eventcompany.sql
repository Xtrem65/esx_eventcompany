USE `gta5_gamemode_essential`;

INSERT INTO `jobs` (name, label)
VALUES
  ('events', 'Events')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female)
VALUES
('events', 0, 'employee_test', 'Employé à l\'essai', 2000, '{}', '{}'),
('events', 1, 'employee', 'Salarié', 2000, '{}', '{}'),
('events', 2, 'pilote', 'Pilote', 2000, '{}', '{}'),
('events', 3, 'manager', 'Manager', 2000, '{}', '{}'),
('events', 4, 'associe', 'Associé', 2500, '{}', '{}'),
('events', 5, 'PDG', 'PDG', 3000, '{}', '{}'),
;
