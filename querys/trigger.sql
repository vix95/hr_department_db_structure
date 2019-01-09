-- wyzwalacz do zmiany wynagrodzenia
CREATE TABLE Log_zmiany_wynagrodzenia_UPDATE (
	id SERIAL,
	data_logu TIMESTAMP NOT NULL,
	stanowisko VARCHAR(255),
	stare_wynagrodzenie DECIMAL(10, 2) NOT NULL,
	nowe_wynagrodzenie DECIMAL(10, 2) NOT NULL
);

CREATE FUNCTION dopisz_do_logu()
	RETURNS TRIGGER AS $$
DECLARE
	st VARCHAR(255);
	x DECIMAL(10, 2);

BEGIN
	st := OLD.nazwa;
	x := NEW.wynagrodzenie;
	RAISE NOTICE 'zmiana wynagrodzenia dla %', st || ' na ' || x || ' brutto';
	
	INSERT INTO Log_zmiany_wynagrodzenia_UPDATE (data_logu, stanowisko, stare_wynagrodzenie, nowe_wynagrodzenie)
    VALUES (NOW(), st, OLD.wynagrodzenie, NEW.wynagrodzenie);
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER Log_zmiany_wynagrodzenia_UPDATE
AFTER UPDATE ON stanowisko
FOR EACH ROW EXECUTE PROCEDURE dopisz_do_logu();

DROP TABLE IF EXISTS Log_zmiany_wynagrodzenia_UPDATE;
DROP TRIGGER IF EXISTS log_zmiany_wynagrodzenia_update ON stanowisko;
DROP FUNCTION IF EXISTS dopisz_do_logu;

-- wyzwalacz do poczekalni
CREATE TABLE Poczekalnia_INSERT (
	id SERIAL PRIMARY KEY,
    nr_hr INTEGER,
	imie VARCHAR(25) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel BIGINT NOT NULL,
    na_stanowisko INTEGER NOT NULL
);

CREATE FUNCTION dopisz_do_poczekalni()
	RETURNS TRIGGER AS $$
DECLARE
    hr INTEGER;
    imie VARCHAR(25);
    nazwisko VARCHAR(50);
    na_stanowisko INTEGER;
    ilosc_miejsc INTEGER;
    ilosc_pracownikow_w_dziale INTEGER;

BEGIN
    hr := NEW.nr_hr;
    imie := NEW.imie;
    nazwisko := NEW.nazwisko;
	na_stanowisko := NEW.stanowisko_id;
	RAISE NOTICE 'pracownik nr HR %', hr || '(' || imie || ' ' || nazwisko || ') czeka na stanowisko o id ' || na_stanowisko;
	
    SELECT
        dzial.ilosc_stanowisk INTO ilosc_miejsc
    FROM dzial
    LEFT JOIN stanowisko ON stanowisko.dzial_id = dzial.id
    WHERE stanowisko.id = na_stanowisko;

    SELECT
        COUNT(pracownik.nr_hr) INTO ilosc_pracownikow_w_dziale
    FROM dzial
    LEFT JOIN stanowisko ON stanowisko.dzial_id = dzial.id
    LEFT JOIN pracownik ON pracownik.stanowisko_id = stanowisko.id
    WHERE stanowisko.id = na_stanowisko;

    IF ilosc_miejsc <= ilosc_pracownikow_w_dziale THEN
        INSERT INTO Poczekalnia_INSERT (nr_hr, imie, nazwisko, pesel, na_stanowisko)
        VALUES (hr, imie, nazwisko, NEW.pesel, na_stanowisko);

        UPDATE pracownik SET stanowisko_id = NULL WHERE nr_hr = hr;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER sprawdz_miejsca_pracy
AFTER INSERT ON pracownik
FOR EACH ROW EXECUTE PROCEDURE dopisz_do_poczekalni();

DROP TABLE IF EXISTS Poczekalnia_INSERT;
DROP TRIGGER IF EXISTS sprawdz_miejsca_pracy ON pracownik;
DROP FUNCTION IF EXISTS dopisz_do_poczekalni;

/*
wyzwalacz, ktory przerzuca wszystkie osoby bez stanowisk do 
nowo utworzonego dzialu (podanego z kwery) i stanowiska (podanego z funkcji),
przydziela X wynagrodzenia (podanego z funkcji) i dopisuje do logow
kogo przeniosiono, gdzie i z jakim wynagrodzeniem
dodatkowo wywietlenie ostrzezenia czy pracownik ma mniej niz 18 lat
dodatkowo zliczenie przedzialow wiekowych przeniesionych pracownikow
z wykorzystaniem wczesniej utworzonego widoku
jesli nie ma potrzebny tworzenia dzialu, to dzial nie jest tworzony
(dzial musi byc najpierw stworzony, bo nie bedzie mozna przypisac
go do stanowiska i pracownikow)
*/
CREATE OR REPLACE VIEW przedzialy_wiekowe_praconikow AS
SELECT y.przedzialy, COUNT(y.przedzialy), y.stanowisko_id
FROM (
    SELECT
        CASE 
            WHEN x.wiek > 1 AND x.wiek <= 20 THEN 'w1_20'
            WHEN x.wiek > 21 AND x.wiek <= 40 THEN 'w21_40'
            WHEN x.wiek > 41 AND x.wiek <= 60 THEN 'w41_60'
            WHEN x.wiek > 61 AND x.wiek <= 80 THEN 'w61_80'
            WHEN x.wiek > 81 AND x.wiek <= 100 THEN 'w81_100'
        END AS przedzialy,
        x.stanowisko_id AS stanowisko_id
    FROM (
        SELECT p.nr_hr, DATE_PART('year', NOW()) - DATE_PART('year', p.data_urodzenia) AS wiek, p.stanowisko_id AS stanowisko_id
        FROM pracownik AS p
        GROUP BY p.nr_hr, p.stanowisko_id
    ) AS x
) AS y
GROUP BY przedzialy, y.stanowisko_id
HAVING COUNT(y.przedzialy) > 0;

CREATE TABLE Przerzuceni_pracownicy (
	id SERIAL PRIMARY KEY,
    nr_hr INTEGER,
	imie VARCHAR(25) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel BIGINT NOT NULL,
    na_stanowisko INTEGER NOT NULL,
    na_dzial INTEGER NOT NULL,
    nowe_wynagrodzenie DECIMAL(10, 2) NOT NULL
);

CREATE FUNCTION przerzuc_pracownikow()
	RETURNS TRIGGER AS $$
DECLARE
    ilosc_stanowisk_tymaczasowych INTEGER;
    s_hr INTEGER;
    s_imie VARCHAR(25);
    s_nazwisko VARCHAR(50);
    s_pesel BIGINT;
    na_stanowisko INTEGER;
    na_dzial INTEGER;
    dzial_nazwa VARCHAR(50);
    ilosc_osob_bez_stanowiska INTEGER;
    czy_przerzucic BOOLEAN;
    nowe_wynagrodzenie DECIMAL(10, 2);
    stanowisko_nazwa VARCHAR(50);
    s_wiek INTEGER;
    wiek_1_20 INTEGER;
    wiek_21_40 INTEGER;
    wiek_41_60 INTEGER;
    wiek_61_80 INTEGER;
    wiek_81_100 INTEGER;

BEGIN
    nowe_wynagrodzenie := TG_ARGV[0];
    stanowisko_nazwa := TG_ARGV[1];
    dzial_nazwa := NEW.nazwa;

    -- sprawdzenie czy jest potrzeba tworzenia przerzucenia ludzi
    SELECT
        CASE WHEN COUNT(nr_hr) > 0 THEN true ELSE false END,
        COUNT(nr_hr)
    INTO czy_przerzucic, ilosc_osob_bez_stanowiska
    FROM pracownik WHERE stanowisko_id IS NULL;

    IF czy_przerzucic THEN
        -- pobranie ID dzialu
        SELECT id INTO na_dzial FROM dzial WHERE nazwa = dzial_nazwa;
            
        -- pobranie ilosci stanowisk w tablicy stanowisko i przypisanie kolejnego id
        SELECT MAX(id) + 1 INTO na_stanowisko FROM stanowisko;

        -- utworzenie nowego stanowiska
        INSERT INTO stanowisko (id, nazwa, dzial_id, minimalne_wyksztalcenie, wynagrodzenie)
        VALUES (na_stanowisko, stanowisko_nazwa, na_dzial, NULL, nowe_wynagrodzenie);

        FOR i IN 1..ilosc_osob_bez_stanowiska LOOP
            -- pobranie informacji o pracowniku
            SELECT nr_hr, imie, nazwisko, pesel, DATE_PART('year', NOW()) - DATE_PART('year', data_urodzenia)
            INTO s_hr, s_imie, s_nazwisko, s_pesel, s_wiek
            FROM pracownik WHERE stanowisko_id IS NULL;

            -- wrzucenie do tablicy 'Przerzuceni_pracownicy' pracownikow, ktorzy beda przeniesieni
            INSERT INTO Przerzuceni_pracownicy (nr_hr, imie, nazwisko, pesel, na_stanowisko, na_dzial, nowe_wynagrodzenie)
            VALUES (s_hr, s_imie, s_nazwisko, s_pesel, na_stanowisko, na_dzial, nowe_wynagrodzenie);

            -- zaktualizowanie stanowiska przerzuconych pracownikow
            UPDATE pracownik SET stanowisko_id = na_stanowisko WHERE nr_hr = s_hr;

            RAISE NOTICE 'pracownik nr HR %', s_hr || ' (' || s_imie || ' ' || s_nazwisko ||
            ') zostal przypisany do stanowiska ' || stanowisko_nazwa || ' ('
            || na_stanowisko || ') do dzialu ' || dzial_nazwa || ' (' || na_dzial ||
            ') z wynagrodzeniem ' || nowe_wynagrodzenie || ' PLN';

            IF s_wiek < 18 THEN
                RAISE WARNING 'UWAGA! Pracownik o numerze %', s_hr || ' nie jest pelnoletni!';
            END IF;
        END LOOP;

        RAISE INFO 'przeniosiono %', ilosc_osob_bez_stanowiska || ' pracownikow';

        -- pobranie ilosci przedzialow wiekowych z widoku
        SELECT count INTO wiek_1_20 FROM przedzialy_wiekowe_praconikow WHERE stanowisko_id = na_stanowisko AND przedzialy = 'w1_20';
        SELECT count INTO wiek_21_40 FROM przedzialy_wiekowe_praconikow WHERE stanowisko_id = na_stanowisko AND przedzialy = 'w21_40';
        SELECT count INTO wiek_41_60 FROM przedzialy_wiekowe_praconikow WHERE stanowisko_id = na_stanowisko AND przedzialy = 'w41_60';
        SELECT count INTO wiek_61_80 FROM przedzialy_wiekowe_praconikow WHERE stanowisko_id = na_stanowisko AND przedzialy = 'w61_80';
        SELECT count INTO wiek_81_100 FROM przedzialy_wiekowe_praconikow WHERE stanowisko_id = na_stanowisko AND przedzialy = 'w81_100';

        IF wiek_1_20 IS NULL THEN wiek_1_20 := 0; END IF;
        IF wiek_21_40 IS NULL THEN wiek_21_40 := 0; END IF;
        IF wiek_41_60 IS NULL THEN wiek_41_60 := 0; END IF;
        IF wiek_61_80 IS NULL THEN wiek_61_80 := 0; END IF;
        IF wiek_81_100 IS NULL THEN wiek_81_100 := 0; END IF;

        -- wypisanie przedzialow wiekowych
        RAISE INFO 'W przedziale wiekowym 1-20 jest %', wiek_1_20 || ' pracownikow';
        RAISE INFO 'W przedziale wiekowym 21-40 jest %', wiek_21_40 || ' pracownikow';
        RAISE INFO 'W przedziale wiekowym 41-60 jest %', wiek_41_60 || ' pracownikow';
        RAISE INFO 'W przedziale wiekowym 61-80 jest %', wiek_61_80 || ' pracownikow';
        RAISE INFO 'W przedziale wiekowym 81-100 jest %', wiek_81_100 || ' pracownikow';

        -- zaktualizowanie ilosci stanowisk w nowym dziale
        UPDATE dzial SET ilosc_stanowisk = ilosc_osob_bez_stanowiska WHERE id = na_dzial;
    ELSE
        -- pobranie ID nowego dzialu
        SELECT id INTO na_dzial FROM dzial WHERE nazwa = dzial_nazwa;

        -- skasowanie utworzonego dzialu
        DELETE FROM dzial WHERE id = na_dzial;

        RAISE WARNING 'brak pracownikow bez stanowiska, skasowano utworzony dzial';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER przerzucenie_pracownikow
AFTER INSERT ON dzial
FOR EACH ROW EXECUTE PROCEDURE przerzuc_pracownikow(2200, "Stanowisko tymczasowe");

DROP TABLE IF EXISTS Przerzuceni_pracownicy;
DROP TRIGGER IF EXISTS przerzucenie_pracownikow ON dzial;
DROP FUNCTION IF EXISTS przerzuc_pracownikow;
