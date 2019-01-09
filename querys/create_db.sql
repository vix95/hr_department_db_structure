CREATE TABLE dzial (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
    ilosc_stanowisk INT NULL
);

CREATE TABLE kwalifikacja (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
    opis VARCHAR(500) NOT NULL
);

CREATE TABLE wymagania (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(255) NOT NULL,
    poziom INT NULL
);

CREATE TABLE stanowisko (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
    dzial_id INT NULL,
    minimalne_wyksztalcenie VARCHAR(50) NULL,
    wynagrodzenie DECIMAL(10, 2) NOT NULL,
    CONSTRAINT dzial_fk FOREIGN KEY (dzial_id) REFERENCES dzial (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE stanowisko_wymagania (
    stanowisko_id INT NOT NULL,
    wymagania_id INT NOT NULL,
    PRIMARY KEY (stanowisko_id, wymagania_id),
    CONSTRAINT stanowisko_fk FOREIGN KEY (stanowisko_id) REFERENCES stanowisko (id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT wymagania_fk FOREIGN KEY (wymagania_id) REFERENCES wymagania (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE pracownik (
    nr_hr SERIAL PRIMARY KEY,
    imie VARCHAR(25) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    pesel BIGINT NOT NULL,
    data_urodzenia DATE NOT NULL,
    numer_telefonu BIGINT NOT NULL,
    miejscowosc VARCHAR(50) NOT NULL,
    ulica VARCHAR(50) NOT NULL,
    numer_domu VARCHAR(25) NOT NULL,
    kod_pocztowy VARCHAR(6) NOT NULL,
    wyksztalcenie VARCHAR(25) NULL,
    hobby VARCHAR(255) NULL,
    kwalifikacja_id INT NULL,
    stanowisko_id INT NULL,
    CONSTRAINT pracownik_pesel_un UNIQUE (pesel),
    CONSTRAINT pracownik_numer_telefonu_un UNIQUE (numer_telefonu),
    CONSTRAINT kwalifikacja_fk FOREIGN KEY (kwalifikacja_id) REFERENCES kwalifikacja (id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT stanowisko_fk FOREIGN KEY (stanowisko_id) REFERENCES stanowisko (id) ON UPDATE CASCADE ON DELETE SET NULL
);