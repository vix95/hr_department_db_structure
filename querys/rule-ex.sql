-- historia zatrudnien
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie1', 'Nazwisko1', '11111111121', '2017-06-25', '111111121', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie2', 'Nazwisko2', '11111111122', '2017-06-25', '111111122', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie3', 'Nazwisko3', '11111111123', '2017-06-25', '111111123', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie4', 'Nazwisko4', '11111111124', '2017-06-25', '111111124', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie5', 'Nazwisko5', '11111111125', '2017-06-25', '111111125', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie6', 'Nazwisko6', '11111111126', '2017-06-25', '111111126', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie7', 'Nazwisko7', '11111111127', '2017-06-25', '111111127', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie8', 'Nazwisko8', '11111111128', '2017-06-25', '111111128', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie9', 'Nazwisko9', '11111111129', '2017-06-25', '111111129', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie10', 'Nazwisko10', '11111111130', '2017-06-25', '111111130', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);

SELECT * FROM historia_zatrudnien;

DELETE FROM pracownik WHERE pesel = 11111111121;
DELETE FROM pracownik WHERE pesel = 11111111122;
DELETE FROM pracownik WHERE pesel = 11111111123;
DELETE FROM pracownik WHERE pesel = 11111111124;
DELETE FROM pracownik WHERE pesel = 11111111125;

SELECT * FROM historia_zatrudnien;

UPDATE pracownik SET stanowisko_id = 1 WHERE pesel = 11111111126;
UPDATE pracownik SET stanowisko_id = 2 WHERE pesel = 11111111127;
UPDATE pracownik SET stanowisko_id = 3 WHERE pesel = 11111111128;

SELECT * FROM historia_zatrudnien;

-- skasowanie pracownikow (DO TESTOW)
DELETE FROM pracownik WHERE pesel = 11111111121;
DELETE FROM pracownik WHERE pesel = 11111111122;
DELETE FROM pracownik WHERE pesel = 11111111123;
DELETE FROM pracownik WHERE pesel = 11111111124;
DELETE FROM pracownik WHERE pesel = 11111111125;
DELETE FROM pracownik WHERE pesel = 11111111126;
DELETE FROM pracownik WHERE pesel = 11111111127;
DELETE FROM pracownik WHERE pesel = 11111111128;
DELETE FROM pracownik WHERE pesel = 11111111129;
DELETE FROM pracownik WHERE pesel = 11111111130;

-- logi
INSERT INTO pracownik (imie, nazwisko, pesel, data_urodzenia, numer_telefonu, miejscowosc, ulica, numer_domu, kod_pocztowy, wyksztalcenie, hobby, kwalifikacja_id, stanowisko_id) VALUES ('Imie10', 'Nazwisko10', '11111111131', '2017-06-25', '111111131', 'Sharonburgh', 'Jerry Creek', '73', '91-657', 'zasadnicze zawodowe', NULL, 3, NULL);
UPDATE pracownik SET stanowisko_id = 6 WHERE pesel = 11111111131;
DELETE FROM pracownik WHERE pesel = 11111111131;

INSERT INTO stanowisko (id, nazwa, dzial_id, minimalne_wyksztalcenie, wynagrodzenie) VALUES (100, 'Stanowisko testowe do Reguly', 6, 'średnie', 3800);
UPDATE stanowisko SET wynagrodzenie = 1000 WHERE id = 100;
DELETE FROM stanowisko WHERE id = 100;

INSERT INTO dzial (id, nazwa, ilosc_stanowisk) VALUES (100, 'Dzial testowy do reguly', 2);
UPDATE dzial SET ilosc_stanowisk = 10 WHERE id = 100;
DELETE FROM dzial WHERE id = 100;

INSERT INTO wymagania (id, nazwa, poziom) VALUES (100, 'Wymaganie testowe do reguly', NULL);
UPDATE wymagania SET poziom = 1 WHERE id = 100;
DELETE FROM wymagania WHERE id = 100;

INSERT INTO kwalifikacja (id, nazwa, opis) VALUES (100, 'Kwalifikacja testowa do reguly', 'Jakieś tam kwalifikacje');
UPDATE kwalifikacja SET opis = 'Nowy opis do testowej kwalifikacji' WHERE id = 100;
DELETE FROM kwalifikacja WHERE id = 100;

INSERT INTO stanowisko_wymagania (stanowisko_id, wymagania_id) VALUES (1, 1);
UPDATE stanowisko_wymagania SET wymagania_id = 2 WHERE stanowisko_id = 1 AND wymagania_id = 1;
DELETE FROM stanowisko_wymagania WHERE stanowisko_id = 1 AND wymagania_id = 2;

SELECT * FROM logi ORDER BY id;

-- monitorowanie wynagrodzenia w firmie po dzialach, korzystajac z widoku
UPDATE stanowisko SET wynagrodzenie = 1000 WHERE id = 1;
UPDATE stanowisko SET wynagrodzenie = 2000 WHERE id = 2;
UPDATE stanowisko SET wynagrodzenie = 3000 WHERE id = 3;
UPDATE stanowisko SET wynagrodzenie = 1500 WHERE id = 4;
UPDATE stanowisko SET wynagrodzenie = 1800 WHERE id = 5;
UPDATE stanowisko SET wynagrodzenie = 3500 WHERE id = 6;
UPDATE stanowisko SET wynagrodzenie = 4200 WHERE id = 7;

SELECT * FROM monitor_wynagrodzenia ORDER BY id;
