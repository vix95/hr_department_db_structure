SELECT * FROM dzial;
SELECT * FROM kwalifikacja;
SELECT * FROM wymagania;
SELECT * FROM stanowisko;
SELECT * FROM stanowisko_wymagania;
SELECT * FROM pracownik;

-- pracownicy w dzialach
SELECT imie, nazwisko, dzial.nazwa
FROM pracownik
INNER JOIN stanowisko ON stanowisko_id = stanowisko.id
INNER JOIN dzial ON dzial_id = dzial.id;

-- ilosc pracownikow w dzialach
SELECT dzial.nazwa, COUNT(nr_hr)
FROM dzial
INNER JOIN stanowisko ON stanowisko.dzial_id = dzial.id
INNER JOIN pracownik ON stanowisko.id = stanowisko_id
GROUP BY dzial.nazwa
ORDER BY dzial.nazwa;

-- wiek pracownikow
SELECT imie, nazwisko, DATE_PART('year', NOW()) - DATE_PART('year', data_urodzenia) AS wiek
FROM pracownik
ORDER BY DATE_PART('year', NOW()) - DATE_PART('year', data_urodzenia)

-- wypisanie ilosci osob z kwalifikacji
SELECT nazwa, COUNT(nr_hr)
FROM kwalifikacja
INNER JOIN pracownik ON pracownik.kwalifikacja_id = id
GROUP BY nazwa;

-- wypisanie kwalifikacji z najwieksza iloscia osob
WITH x AS (
	SELECT nazwa, COUNT(nr_hr) AS ilosc
	FROM kwalifikacja
	INNER JOIN pracownik ON kwalifikacja_id = id
	GROUP BY nazwa
)

SELECT * FROM x
WHERE ilosc = (SELECT MAX(ilosc) FROM x);

-- wypisanie wszystkich wymagan bez duplikatow, ktore zaczynaja sie od slowa 'Znajomość'
SELECT DISTINCT nazwa FROM wymagania
WHERE nazwa LIKE 'Znajomość%'
ORDER BY nazwa;

-- wypisanie pracownikow bez stanowiska
SELECT imie, nazwisko FROM pracownik
WHERE stanowisko_id IS NULL;

-- wypisanie hobby w rekordach
SELECT TRIM(REGEXP_SPLIT_TO_TABLE(p.hobby, E',')) AS hobby
FROM pracownik AS p;

-- wypisanie par wymagania stanowisko
WITH x AS (
	SELECT DISTINCT w.nazwa AS wymagania, s.nazwa AS stanowisko
	FROM wymagania AS w
	LEFT JOIN stanowisko_wymagania AS sw ON sw.wymagania_id = w.id
	LEFT JOIN stanowisko AS s ON s.id = sw.stanowisko_id
	ORDER BY w.nazwa
)

SELECT x.wymagania AS wymagania, STRING_AGG(x.stanowisko, ', ') as stanowiska, COUNT(x.stanowisko)
FROM x
GROUP BY x.wymagania
ORDER BY x.wymagania;

-- wypisanie pracownikow bez stanowiska
SELECT p.imie, p.nazwisko FROM pracownik AS p
LEFT OUTER JOIN stanowisko AS s ON p.stanowisko_id = s.id
WHERE p.stanowisko_id IS NULL
ORDER BY p.imie, p.nazwisko;

-- utworzenie widoku ilosci osob na stanowisku
CREATE VIEW ilosc_osob_na_stanowisku AS
SELECT s.nazwa, COUNT(p.nr_hr) AS ilosc
FROM stanowisko AS s
LEFT JOIN pracownik AS p ON p.stanowisko_id = s.id
GROUP BY s.nazwa;

SELECT * FROM ilosc_osob_na_stanowisku;

-- skasowanie stanowiska z id 1
-- w tablicy pracownik ustawia NULL w kolumnie stanowisko_id
DELETE FROM stanowisko
WHERE id = 1;

-- ustawienie stanowiska id = 2 wszystkim pracownikom, ktorzy maja stanowisko id = 4
UPDATE pracownik SET stanowisko_id = 2 WHERE stanowisko_id = 4;

-- wypisanie ilosci pracownikow w dzialach wraz z iloscia dostepnych miejsc w dziale
SELECT 
	dzial.nazwa, 
	dzial.ilosc_stanowisk, 
	COUNT(pracownik.nr_hr) AS "ilosc_pracownikow_w_dziale"
FROM dzial
LEFT JOIN stanowisko ON stanowisko.dzial_id = dzial.id
LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id
GROUP BY dzial.nazwa, dzial.ilosc_stanowisk;

-- wypisanie dzialu, ktory ma wiecej pracownikow niz powinien miec
SELECT 
	dzial.nazwa, 
	dzial.ilosc_stanowisk, 
	COUNT(pracownik.nr_hr) AS "ilosc_pracownikow_w_dziale"
FROM dzial
LEFT JOIN stanowisko ON stanowisko.dzial_id = dzial.id
LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id
GROUP BY dzial.nazwa, dzial.ilosc_stanowisk
HAVING COUNT(pracownik.nr_hr) > dzial.ilosc_stanowisk;

-- wypisanie pracownikow wraz z wynagrodzeniem, ktorzy sa w dziale, w ktorym jest za malo stanowisk
WITH x AS (
	SELECT
		dzial.id,
		dzial.nazwa, 
		dzial.ilosc_stanowisk, 
		COUNT(pracownik.nr_hr) AS "ilosc_pracownikow_w_dziale"
	FROM dzial
	LEFT JOIN stanowisko ON stanowisko.dzial_id = dzial.id
	LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id
	GROUP BY dzial.id, dzial.nazwa, dzial.ilosc_stanowisk
	HAVING COUNT(pracownik.nr_hr) > dzial.ilosc_stanowisk
)

SELECT 
	pracownik.imie,
	pracownik.nazwisko,
	stanowisko.wynagrodzenie
FROM x
LEFT JOIN stanowisko ON stanowisko.dzial_id = x.id
LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id;

-- nadanie premii zaleznej od wynagrodzenia
WITH x AS (
	SELECT
		pracownik.imie,
		pracownik.nazwisko,
		stanowisko.nazwa,
		stanowisko.wynagrodzenie
	FROM stanowisko
	LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id
)

SELECT
	x.imie,
	x.nazwisko,
	x.nazwa,
	ROUND(CASE
		WHEN x.wynagrodzenie BETWEEN 0 AND 1500 THEN x.wynagrodzenie * 0.25
		WHEN x.wynagrodzenie BETWEEN 1500.01 AND 2500 THEN x.wynagrodzenie * 0.20
		WHEN x.wynagrodzenie BETWEEN 2500.01 AND 3500 THEN x.wynagrodzenie * 0.15
		WHEN x.wynagrodzenie BETWEEN 3500.01 AND 5000 THEN x.wynagrodzenie * 0.10
	END, 2) AS "premia"
FROM x;

/* 
nadanie premii zaleznej od wynagrodzenia z wykluczeniem wynagrodzen, ktore sa przypisane
do wiekszej ilosci stanowisk niz 2
*/
-- wykaz_pracownikow
WITH x AS (
	SELECT
		p.imie,
		p.nazwisko,
		s.nazwa,
		s.wynagrodzenie,
		p.stanowisko_id,
		s.dzial_id,
		sw.wymagania_id
	FROM stanowisko AS s
	LEFT JOIN pracownik AS p ON p.stanowisko_id = s.id
	LEFT JOIN stanowisko_wymagania AS sw ON sw.stanowisko_id = p.stanowisko_id
	WHERE p.nr_hr IS NOT NULL
),

-- wykaz_wymagan
y AS (
	SELECT
		w.id,
		w.nazwa AS wymagania,
		COUNT(s.id) AS "ilosc_stanowisk"
	FROM wymagania AS w
	LEFT JOIN stanowisko_wymagania AS sw ON sw.wymagania_id = w.id
	LEFT JOIN stanowisko AS s ON s.id = sw.stanowisko_id
	GROUP BY w.id, w.nazwa
)

SELECT DISTINCT
	x.imie,
	x.nazwisko,
	x.nazwa,
	ROUND(CASE
		WHEN x.wynagrodzenie BETWEEN 0 AND 1500 THEN x.wynagrodzenie * 0.25
		WHEN x.wynagrodzenie BETWEEN 1500.01 AND 2500 THEN x.wynagrodzenie * 0.20
		WHEN x.wynagrodzenie BETWEEN 2500.01 AND 3500 THEN x.wynagrodzenie * 0.15
		WHEN x.wynagrodzenie BETWEEN 3500.01 AND 5000 THEN x.wynagrodzenie * 0.10
	END, 2) AS "premia",
	dzial.nazwa
FROM x
LEFT JOIN dzial ON dzial.id = x.dzial_id
LEFT JOIN y ON y.id = x.wymagania_id
WHERE y.ilosc_stanowisk < 3

/* 
nadanie premii zaleznej od wynagrodzenia z wykluczeniem wynagrodzen, ktore sa przypisane
do wiekszej ilosci stanowisk niz 2 oraz dla pracownikow z wyksztalceniem zasadniczym zawodowym
i srednim, wykluczajac dzial Kadr
*/
-- wykaz_pracownikow
WITH x AS (
	SELECT
		p.nr_hr,
		s.nazwa,
		s.wynagrodzenie,
		p.stanowisko_id,
		s.dzial_id,
		sw.wymagania_id
	FROM stanowisko AS s
	LEFT JOIN pracownik AS p ON p.stanowisko_id = s.id
	LEFT JOIN stanowisko_wymagania AS sw ON sw.stanowisko_id = p.stanowisko_id
	WHERE p.nr_hr IS NOT NULL
),
-- wykaz_wymagan
y AS (
	SELECT
		w.id,
		w.nazwa AS wymagania,
		COUNT(s.id) AS "ilosc_stanowisk"
	FROM wymagania AS w
	LEFT JOIN stanowisko_wymagania AS sw ON sw.wymagania_id = w.id
	LEFT JOIN stanowisko AS s ON s.id = sw.stanowisko_id
	GROUP BY w.id, w.nazwa
)

SELECT DISTINCT
	p.imie,
	p.nazwisko,
	x.nazwa,
	ROUND(CASE
		WHEN x.wynagrodzenie BETWEEN 0 AND 1500 THEN x.wynagrodzenie * 0.25
		WHEN x.wynagrodzenie BETWEEN 1500.01 AND 2500 THEN x.wynagrodzenie * 0.20
		WHEN x.wynagrodzenie BETWEEN 2500.01 AND 3500 THEN x.wynagrodzenie * 0.15
		WHEN x.wynagrodzenie BETWEEN 3500.01 AND 5000 THEN x.wynagrodzenie * 0.10
	END, 2) AS "premia",
	dzial.nazwa
FROM x
LEFT JOIN pracownik AS p ON p.nr_hr = x.nr_hr
LEFT JOIN dzial ON dzial.id = x.dzial_id
LEFT JOIN y ON y.id = x.wymagania_id
WHERE y.ilosc_stanowisk < 3
AND p.wyksztalcenie IN ('zasadnicze zawodowe', 'średnie')
AND x.dzial_id <> 3;

/* 
ustawienie pracownikom z pensja ponizej 2500 nowa stawke o 300 zl wieksza,
dodatkowo pracownikom z dzialu IT dodac 20 zl wyrownania do nowej stawki
*/
UPDATE stanowisko SET wynagrodzenie = wynagrodzenie + 300
WHERE wynagrodzenie < 2500;

UPDATE stanowisko SET wynagrodzenie = wynagrodzenie + 20
WHERE dzial_id = 1;

/*
wypisanie minimalnego, sredniego i maksymalnego wieku pracownikow w dziale
dla parzystych nr_hr
*/
WITH x AS (
	SELECT nr_hr, DATE_PART('year', NOW()) - DATE_PART('year', data_urodzenia) AS wiek
	FROM pracownik
)

SELECT
	d.nazwa,
	MIN(x.wiek) AS "min_wiek",
	ROUND(AVG(x.wiek)) AS "avg_wiek",
	MAX(x.wiek) AS "max_wiek"
FROM x
LEFT JOIN pracownik AS p ON p.nr_hr = x.nr_hr
LEFT JOIN stanowisko AS s ON s.id = p.stanowisko_id
LEFT JOIN dzial AS d ON d.id = s.dzial_id
WHERE d.nazwa IS NOT NULL AND p.nr_hr % 2 = 0
GROUP BY d.nazwa

/*
wypisanie najmlodszych i najstarszych pracownikow w kazdym dziale
uwzgledniajac tylko parzyste nr_hr
*/
WITH x AS (
	SELECT 
		d.id,
		MIN(DATE_PART('year', NOW()) - DATE_PART('year', p.data_urodzenia)) AS "min_wiek",
		MAX(DATE_PART('year', NOW()) - DATE_PART('year', p.data_urodzenia)) AS "max_wiek"
	FROM dzial AS d
	LEFT JOIN stanowisko AS s ON s.dzial_id = d.id
	LEFT JOIN pracownik AS p ON p.stanowisko_id = s.id
	WHERE d.id IS NOT NULL AND p.nr_hr % 2 = 0
	GROUP BY d.id
),
y AS (
	SELECT
		p.nr_hr,
		d.id,
		CONCAT(p.imie, ' ', p.nazwisko) AS "pracownik",
		DATE_PART('year', NOW()) - DATE_PART('year', p.data_urodzenia) AS "wiek"
	FROM pracownik AS p
	LEFT JOIN stanowisko AS s ON s.id = p.stanowisko_id
	LEFT JOIN dzial AS d ON d.id = s.dzial_id
	WHERE d.id IS NOT NULL AND p.nr_hr % 2 = 0
)

SELECT
	d.nazwa,
	y.pracownik AS "min_pracownik",
	MIN(x.min_wiek),
	y2.pracownik AS "max_pracownik",
	MAX(x.max_wiek)
FROM x
LEFT JOIN dzial AS d ON d.id = x.id
LEFT JOIN y AS y ON y.wiek = x.min_wiek AND y.id = x.id
LEFT JOIN y AS y2 ON y2.wiek = x.max_wiek AND y2.id = x.id
GROUP BY d.nazwa, y.pracownik, y2.pracownik;