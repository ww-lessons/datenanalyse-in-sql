/*
 * SQLs ohne Join
 */
-- Ausgeben der Inhalte von student und pruefung
select * from student;
select * from pruefung;

-- Nur die ersten 3 Zeilen ausgeben
select *
from student
limit 3;

-- Ungleich
select * from leistung
where student_id != 10;

select * from leistung
where student_id <> 10;

--  Ermitteln der Anzahl der Studenten
select count(*) from student;

-- Ermitteln der Anzahl der männlichen und weiblichen Studenten
select geschlecht, count(*) as anzahl
from student
group by geschlecht;

-- Prüfungen nach Prüfungsnummer (und damit nach Semester) sortiert
select * from pruefung 
order by pnr;

-- Anzahl der Prüfungen pro Lehrplansemester
select (pnr/10)-99 as lpsem, count(*)
from pruefung
group by (pnr/10)-99
order by lpsem;

-- Ermitteln aller Prüfungen im 2. LPSem
select *
from pruefung
where cast(pnr as varchar(10)) like '__1_';

-- Warum ist das folgende Statement nicht OK?
select *
from pruefung
where cast(pnr as varchar(10)) like '%1%';

-- Was liefert dieses Statement?
select *
from pruefung
where cast(pnr as varchar(10)) similar to '[0-9][0-9][12][0-9]';

/*
 * SQLs mit Join
 */
-- Ausgabe aller Studenten mit ihren Prüfungsleistungen
select * 
from student as s
inner join leistung as l
	on s.student_id = l.student_id
inner join pruefung as p
	on p.pruefung_id = l.pruefung_id
order by s.student_id, p.pnr;

-- Ermittlung der Durchschnittsnoten der Prüfungen
select p.pruefung_id, p.bezeichnung, p.pnr, round(avg(note)/100, 2) as durchschnittsnote
from pruefung as p
inner join leistung as l
on p.pruefung_id = l.pruefung_id
group by p.pruefung_id, p.bezeichnung, p.pnr
order by pnr;

-- Ermitteln der Anzahl der Prüfungen die der Student jeweils schon bestanden hat
select matrikelnummer, vorname, nachname, count(l.note) as Anzahl
from student as s
left outer join leistung as l
on s.student_id = l.student_id
and l.note < 500
group by matrikelnummer, vorname, nachname
order by anzahl;

-- Ermitteln der Anzahl bestandenen und nicht bestandenen der Prüfungen der Studenten
select matrikelnummer, vorname, nachname, 
	sum(case when l.note < 500 then 1 else 0 end) as Bestanden, 
	sum(case when l.note = 500 then 1 else 0 end) as NichtBestanden
from student as s
left outer join leistung as l
on s.student_id = l.student_id
group by matrikelnummer, vorname, nachname
order by matrikelnummer;

-- Ermitteln in welchen Tabellen es eine Spalte pruefung_id gibt
select table_name, column_name, data_type
from information_schema.columns
where table_catalog = 'schulung'
and column_name = 'pruefung_id';

-- Ermitteln aller *_id -Spalten
select table_name, column_name, data_type
from information_schema.columns
where table_catalog = 'schulung'
and column_name like '%\_id' -- zuerst mit %_id versuchen -> aber _ ist ja Platzhalter für genau ein Zeichen!!!