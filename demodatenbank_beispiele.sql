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

select * from student
order by vorname desc, nachname asc;

--  Ermitteln der Anzahl der Studenten
select count(*) from student;

-- Ermitteln der Anzahl der männlichen und weiblichen Studenten
select geschlecht, count(*) as anzahl
from student
group by geschlecht;

-- Prüfungen nach Prüfungsnummer (und damit nach Semester) sortiert
select * from pruefung 
order by pnr;

-- Nur Gruppen, die mind. 3 Elemente enthalten
select geschlecht, count(*) as anzahl
from student 
group by geschlecht
having count(*) >= 3;

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

-- Anzahl der männl. und weibl. Studenten gruppiert nach Familiennamen
select nachname, 
       sum(case when geschlecht = 'm' then 1 else 0 end) as maennlich,
       sum(case when geschlecht = 'w' then 1 else 0 end) as weiblich
from student
group by nachname

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
from information_schema.columnsE
where table_catalog = 'schulung'
and column_name like '%\_id' -- zuerst mit %_id versuchen -> aber _ ist ja Platzhalter für genau ein Zeichen!!!

-- Alle Studenten mit Durchschnittsnoten
select s.vorname, s.nachname, round(avg(l.note)/100, 2) as durchschnitt
from student as s
inner join leistung as l
on s.student_id = l.student_id
where l.note < 500
group by s.vorname, s.nachname
order by durchschnitt


-- CTE-Beispiel, das zeigt wie SQL-Statements in kleinere Teilabschnitte zerlegt werden können
with 
/*
 * Virtuelle Tabelle der Notenschnitte pro Student -> eine Zeile pro Student
 */
durchschnitt_pro_student as (
    select l.student_id, round(avg(case when l.note < 500 and l.note >= 100 then l.note else null end)/100, 2) as durchschnitt
    from leistung as l
    group by l.student_id
), 
/*
 * Virtuelle Tabelle der Anzahl der Fehlversuche und Gesamtzahl der Prüfungsversuche pro Student
 */
fehlversuche_pro_student as (
    select s.student_id, sum(case when l.note = 500 then 1 else 0 end) as fehlversuche, count(l) as leistungen
    from student as s
    left outer join leistung l
        on s.student_id = l.student_id
    group by s.student_id
)
/*
 * Das eigentliche Select-Statemtent, das auf den beiden Zwischenergebnissen aufbauen kann...
 */
select s.*, d.durchschnitt, f.fehlversuche, f.leistungen
from student as s
inner join fehlversuche_pro_student as f
    on f.student_id = s.student_id
left outer join durchschnitt_pro_student as d
    on s.student_id = d.student_id

    