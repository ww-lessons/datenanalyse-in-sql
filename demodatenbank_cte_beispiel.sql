with
punkte_pro_pruefung as (
	select l.pruefung_id, sum(l.punkte) as gesamtpunkte
	from leistung as l
	group by l.pruefung_id
)
select s.student_id, s.vorname, s.nachname, p.bezeichnung, 
       l.punkte, pp.gesamtpunkte, round(l.punkte * 100.0 / pp.gesamtpunkte, 2) as anteil
from student as s
inner join leistung as l
	on s.student_id = l.student_id
inner join pruefung as p
	on p.pruefung_id = l.pruefung_id
inner join punkte_pro_pruefung as pp
	on pp.pruefung_id = l.pruefung_id

-- Alle Tabellen mit student_id suchen
/*
select * from information_schema.columns
where table_schema = 'public'
and column_name = 'student_id'
*/