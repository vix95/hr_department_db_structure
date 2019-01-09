-- historia zatrudnien
CREATE TABLE historia_zatrudnien (
    id SERIAL PRIMARY KEY,
    data_aktualizacji DATE NOT NULL,
    nr_hr INTEGER NOT NULL,
    imie VARCHAR(25) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel BIGINT NOT NULL,
    data_urodzenia DATE NOT NULL,
    stanowisko_id INTEGER,
    opis VARCHAR(25) NOT NULL
);

CREATE OR REPLACE RULE historia_zatrudnien_INSERT AS
ON INSERT TO pracownik
DO (
    INSERT INTO historia_zatrudnien (data_aktualizacji, nr_hr, imie, nazwisko, pesel, data_urodzenia, stanowisko_id, opis)
    VALUES (CURRENT_TIMESTAMP, NEW.nr_hr, NEW.imie, NEW.nazwisko, NEW.pesel, NEW.data_urodzenia, NEW.stanowisko_id, 'zatrudnienie');
);

CREATE OR REPLACE RULE historia_zatrudnien_DELETE AS
ON DELETE TO pracownik
DO (
    INSERT INTO historia_zatrudnien (data_aktualizacji, nr_hr, imie, nazwisko, pesel, data_urodzenia, stanowisko_id, opis)
    VALUES (CURRENT_TIMESTAMP, OLD.nr_hr, OLD.imie, OLD.nazwisko, OLD.pesel, OLD.data_urodzenia, OLD.stanowisko_id, 'wypowiedzenie');
);

CREATE OR REPLACE RULE historia_zatrudnien_UPDATE AS
ON UPDATE TO pracownik WHERE OLD.stanowisko_id <> NEW.stanowisko_id
DO (
    INSERT INTO historia_zatrudnien (data_aktualizacji, nr_hr, imie, nazwisko, pesel, data_urodzenia, stanowisko_id, opis)
    VALUES (CURRENT_TIMESTAMP, OLD.nr_hr, OLD.imie, OLD.nazwisko, OLD.pesel, OLD.data_urodzenia, NEW.stanowisko_id, 'zmiana stanowiska');
);

DROP TABLE IF EXISTS historia_zatrudnien;
DROP RULE IF EXISTS historia_zatrudnien_INSERT ON pracownik;
DROP RULE IF EXISTS historia_zatrudnien_DELETE ON pracownik;
DROP RULE IF EXISTS historia_zatrudnien_UPDATE ON pracownik;

-- logi
CREATE TABLE logi (
    id SERIAL PRIMARY KEY,
    uzytkownik VARCHAR(25) NOT NULL,
    data_logu TIMESTAMP NOT NULL,
    tablica VARCHAR(50) NOT NULL,
    akcja VARCHAR(10) NOT NULL
);

-- pracownik
CREATE OR REPLACE RULE logi_pracownik_INSERT AS
ON INSERT TO pracownik
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'pracownik', 'INSERT');
);

CREATE OR REPLACE RULE logi_pracownik_DELETE AS
ON DELETE TO pracownik
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'pracownik', 'DELETE');
);

CREATE OR REPLACE RULE logi_pracownik_UPDATE AS
ON UPDATE TO pracownik
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'pracownik', 'UPDATE');
);

-- stanowisko
CREATE OR REPLACE RULE logi_stanowisko_INSERT AS
ON INSERT TO stanowisko
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko', 'INSERT');
);

CREATE OR REPLACE RULE logi_stanowisko_DELETE AS
ON DELETE TO stanowisko
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko', 'DELETE');
);

CREATE OR REPLACE RULE logi_stanowisko_UPDATE AS
ON UPDATE TO stanowisko
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko', 'UPDATE');
);

-- dzial
CREATE OR REPLACE RULE logi_dzial_INSERT AS
ON INSERT TO dzial
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'dzial', 'INSERT');
);

CREATE OR REPLACE RULE logi_dzial_DELETE AS
ON DELETE TO dzial
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'dzial', 'DELETE');
);

CREATE OR REPLACE RULE logi_dzial_UPDATE AS
ON UPDATE TO dzial
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'dzial', 'UPDATE');
);

-- wymagania
CREATE OR REPLACE RULE logi_wymagania_INSERT AS
ON INSERT TO wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'wymagania', 'INSERT');
);

CREATE OR REPLACE RULE logi_wymagania_DELETE AS
ON DELETE TO wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'wymagania', 'DELETE');
);

CREATE OR REPLACE RULE logi_wymagania_UPDATE AS
ON UPDATE TO wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'wymagania', 'UPDATE');
);

-- kwalifikacja
CREATE OR REPLACE RULE logi_kwalifikacja_INSERT AS
ON INSERT TO kwalifikacja
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'kwalifikacja', 'INSERT');
);

CREATE OR REPLACE RULE logi_kwalifikacja_DELETE AS
ON DELETE TO kwalifikacja
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'kwalifikacja', 'DELETE');
);

CREATE OR REPLACE RULE logi_kwalifikacja_UPDATE AS
ON UPDATE TO kwalifikacja
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'kwalifikacja', 'UPDATE');
);

-- stanowisko_wymagania
CREATE OR REPLACE RULE logi_stanowisko_wymagania_INSERT AS
ON INSERT TO stanowisko_wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko_wymagania', 'INSERT');
);

CREATE OR REPLACE RULE logi_stanowisko_wymagania_DELETE AS
ON DELETE TO stanowisko_wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko_wymagania', 'DELETE');
);

CREATE OR REPLACE RULE logi_stanowisko_wymagania_UPDATE AS
ON UPDATE TO stanowisko_wymagania
DO (
    INSERT INTO logi(uzytkownik, data_logu, tablica, akcja)
    VALUES ((SELECT USER db_details), CURRENT_TIMESTAMP, 'stanowisko_wymagania', 'UPDATE');
);

DROP RULE IF EXISTS logi_pracownik_INSERT ON pracownik;
DROP RULE IF EXISTS logi_pracownik_DELETE ON pracownik;
DROP RULE IF EXISTS logi_pracownik_UPDATE ON pracownik;
DROP RULE IF EXISTS logi_stanowisko_INSERT ON stanowisko;
DROP RULE IF EXISTS logi_stanowisko_DELETE ON stanowisko;
DROP RULE IF EXISTS logi_stanowisko_UPDATE ON stanowisko;
DROP RULE IF EXISTS logi_dzial_INSERT ON dzial;
DROP RULE IF EXISTS logi_dzial_DELETE ON dzial;
DROP RULE IF EXISTS logi_dzial_UPDATE ON dzial;
DROP RULE IF EXISTS logi_wymagania_INSERT ON wymagania;
DROP RULE IF EXISTS logi_wymagania_DELETE ON wymagania;
DROP RULE IF EXISTS logi_wymagania_UPDATE ON wymagania;
DROP RULE IF EXISTS logi_kwalifikacja_INSERT ON kwalifikacja;
DROP RULE IF EXISTS logi_kwalifikacja_DELETE ON kwalifikacja;
DROP RULE IF EXISTS logi_kwalifikacja_UPDATE ON kwalifikacja;
DROP RULE IF EXISTS logi_stanowisko_wymagania_INSERT ON stanowisko_wymagania;
DROP RULE IF EXISTS logi_stanowisko_wymagania_DELETE ON stanowisko_wymagania;
DROP RULE IF EXISTS logi_stanowisko_wymagania_UPDATE ON stanowisko_wymagania;
DROP TABLE IF EXISTS logi;

-- monitorowanie wynagrodzenia w firmie po dzialach, korzystajac z widoku
CREATE OR REPLACE VIEW statystyki_wynagrodzenia AS
SELECT d.id, d.nazwa, MAX(s.wynagrodzenie), AVG(s.wynagrodzenie), MIN(s.wynagrodzenie)
FROM stanowisko AS s
RIGHT JOIN dzial AS d ON d.id = s.dzial_id
GROUP BY d.id, d.nazwa;

CREATE TABLE monitor_wynagrodzenia (
    id SERIAL PRIMARY KEY,
    data_logu DATE NOT NULL,
    dzial_id INTEGER NULL,
    maksymalne_wynagrodzenie DECIMAL(10, 2) NULL,
    srednie_wynagrodzenie DECIMAL(10, 2) NULL,
    minimalne_wynagrodzenie DECIMAL(10, 2) NULL
);

CREATE OR REPLACE RULE zmiana_wynagrodzenia AS
ON UPDATE TO stanowisko
DO (
    INSERT INTO monitor_wynagrodzenia (data_logu, dzial_id, maksymalne_wynagrodzenie, srednie_wynagrodzenie, minimalne_wynagrodzenie)
    VALUES (CURRENT_TIMESTAMP, OLD.dzial_id,
        (SELECT COALESCE(x.max, 0) FROM statystyki_wynagrodzenia AS x WHERE x.id = OLD.dzial_id),
        (SELECT COALESCE(ROUND(x.avg, 2), 0) FROM statystyki_wynagrodzenia AS x WHERE x.id = OLD.dzial_id),
        (SELECT COALESCE(x.min, 0) FROM statystyki_wynagrodzenia AS x WHERE x.id = OLD.dzial_id)
    );
);

CREATE OR REPLACE RULE sledz_zmiany_wynagrodzenia AS
ON UPDATE TO stanowisko
DO (
    SELECT * FROM monitor_wynagrodzenia AS x
    WHERE x.dzial_id = (SELECT id FROM dzial WHERE id = NEW.dzial_id);
);

DROP RULE IF EXISTS zmiana_wynagrodzenia ON stanowisko;
DROP RULE IF EXISTS sledz_zmiany_wynagrodzenia ON stanowisko;
DROP VIEW IF EXISTS statystyki_wynagrodzenia;
DROP TABLE IF EXISTS monitor_wynagrodzenia;