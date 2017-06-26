/*
 * Datenmodell zum Beispiel Student/Prüfung
 */
create table student (
   student_id serial primary key,
   matrikelnummer varchar(10) not null unique,
   vorname varchar(50),
   nachname varchar(50),
   geschlecht char(1)
);

create table pruefung (
   pruefung_id serial primary key,
   bezeichnung varchar(100),
   pnr int not null unique
);

create table leistung (
   student_id int not null references student(student_id),
   pruefung_id int not null references pruefung(pruefung_id),
   punkte int not null,
   note int not null constraint valid_note check (note >= 100 and note <= 500),
   primary key (student_id, pruefung_id)
);

/*
 * Demodaten
 */
insert into student (matrikelnummer, vorname, nachname, geschlecht) values 
('4711', 'Max', 'Mustermann', 'm'),
('4712', 'Moritz', 'Mustermann', 'm'),
('4713', 'Maria', 'Mustermann', 'w'),
('4714', 'Max', 'Musterer', 'm'),
('4715', 'Maria', 'Muster', 'w'),
('4716', 'Marianne', 'Musterbauer', 'w');

insert into pruefung (bezeichnung, pnr) values
('Mathematik 1', 1001),
('Mathematik 2', 1011),
('Programmieren 1', 1002),
('Programmieren 2', 1012),
('Betriebswirtschaft', 1003),
('Rechnungswesen', 1021),
('Betriebssysteme', 1022),
('Grundlagen der Informatik', 1004),
('Verteilte Systeme', 1051),
('IT-Controlling', 1052);

insert into leistung (student_id, pruefung_id, punkte, note) values
(1, 1, 100, 100),
(1, 2, 70, 200),
(1, 3, 71, 170),
(1, 4, 50, 370),
(2, 1, 46, 400),
(2, 2, 88, 100),
(3, 3, 76, 170),
(3, 4, 48, 400),
(2, 5, 101, 100),
(3, 6, 63, 330),
(4, 7, 73, 230),
(4, 8, 10, 500),
(4, 5, 55, 370),
(5, 6, 88, 170),
(5, 7, 31, 500);