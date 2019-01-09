-- zmiana wynagrodzenia
UPDATE stanowisko SET wynagrodzenie = 200 WHERE nazwa = 'Handlowiec';
UPDATE stanowisko SET wynagrodzenie = 3500 WHERE nazwa = 'Kadrowa';
UPDATE stanowisko SET wynagrodzenie = 4200 WHERE nazwa = 'Manager';
UPDATE stanowisko SET wynagrodzenie = 1200 WHERE nazwa = 'Ksiegowa';
SELECT * FROM Log_zmiany_wynagrodzenia_UPDATE;

-- dodanie nowych pracownikow
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('N1', 'S1', '11111111111', '1993-07-23', '111111111', 'Caliport', 'Aditya Ridge', '9', '85-099', 'zasadnicze zawodowe', 'kino, grafika, pisanie książek, park, gry, programowanie', 1, 3);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('N2', 'S2', '22222222222', '2003-01-17', '222222222', 'New Agnes', 'Ivy Villages', '45', '48-950', 'średnie', 'pisanie książek, grafika', 3, 4);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('N3', 'S3', '33333333333', '1991-07-25', '333333333', 'Lake Annettaport', 'Nikolaus Ranch', '83', '88-364', 'średnie', 'teatr, elektronika, czytanie, pisanie książek, wycieczki, czytanie, gry, elektronika, grafika, taniec, taniec, jeżdzenie na rolkach, opera, taniec, jeżdzenie na deskorolce', 2, 2);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('N4', 'S4', '44444444444', '1998-08-07', '444444444', 'Schmidtberg', 'Gutmann Summit', '1', '60-121', 'wyższe', 'wycieczki', 4, 2);
SELECT * FROM Poczekalnia_INSERT;

-- utworzenie nowego dzialu, w ktorym beda sie znajdowac wszyscy pracownicy nieprzydzieleniu do stanowiska
SELECT przedzialy, count AS ilosc, stanowisko_id FROM przedzialy_wiekowe_praconikow ORDER BY stanowisko_id, przedzialy;
INSERT INTO dzial (id, nazwa, ilosc_stanowisk) VALUES (7, 'Dzial tymczasowy', NULL);
SELECT * FROM dzial;
SELECT * FROM stanowisko;
SELECT * FROM Przerzuceni_pracownicy;
DELETE FROM dzial WHERE nazwa = 'Dzial tymczasowy';
-- wypisanie pracownikow bez stanowiska
SELECT imie, nazwisko FROM pracownik
WHERE stanowisko_id IS NULL;