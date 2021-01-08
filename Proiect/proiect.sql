CREATE TABLE Hotel(
    id_hotel NUMBER PRIMARY KEY,
    nume_hotel VARCHAR2(100),
    adresa_hotel VARCHAR2(100));

CREATE TABLE Angajati (
    id_angajat NUMBER PRIMARY KEY,
    nume VARCHAR2(100),
    prenume VARCHAR2(100),
    CNP NUMBER,
    desc_job VARCHAR2(100),
    id_manager NUMBER,
    id_hotel NUMBER,
    FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel) ON DELETE SET NULL,
    FOREIGN KEY (id_manager) REFERENCES Angajati(id_angajat) ON DELETE SET NULL);

CREATE TABLE TipCamera(
    id_tip_camera NUMBER PRIMARY KEY,
    descriere VARCHAR2(100),
    nr_camere NUMBER NOT NULL,
    tarif NUMBER);

CREATE TABLE Camera(
    id_camera NUMBER PRIMARY KEY,
    id_hotel NUMBER,
    id_tip_camera NUMBER,
    nr_camera NUMBER,
    FOREIGN KEY (id_hotel) REFERENCES Hotel(id_hotel) ON DELETE SET NULL,
    FOREIGN KEY (id_tip_camera) REFERENCES TipCamera(id_tip_camera) ON DELETE SET NULL);

CREATE TABLE Clienti(
    id_client NUMBER PRIMARY KEY,
    nume_client VARCHAR2(100),
    CNP NUMBER);

CREATE TABLE Rezervari(
    id_rezervare NUMBER PRIMARY KEY,
    data_check_in DATE,
    data_check_out DATE,
    id_client NUMBER,
    FOREIGN KEY (id_client) REFERENCES Clienti(id_client) ON DELETE SET NULL);

CREATE TABLE CamereRezervate(
    id_camera NUMBER,
    id_rezervare NUMBER,
    PRIMARY KEY (id_camera, id_rezervare),
    FOREIGN KEY (id_camera) REFERENCES Camera(id_camera) ON DELETE SET NULL,
    FOREIGN KEY (id_rezervare) REFERENCES Rezervari(id_rezervare) ON DELETE SET NULL);

INSERT INTO Hotel VALUES(0, 'Racova', 'Str. Stefan cel Mare, nr.10, Vaslui');
INSERT INTO Hotel VALUES(1, 'Europa', 'Str. Stefan cel Mare, nr.11, Vaslui');
INSERT INTO Hotel VALUES(2, 'Intercontinental', 'Bd. Elisabeta, Bucuresti'); 

INSERT INTO Angajati VALUES(0, 'Liviu', 'Bouruc', 123456, 'Director', NULL, 2);
INSERT INTO Angajati VALUES(1, 'Miruna', 'Vasilu', 123457, 'Manager', 0, 2);
INSERT INTO Angajati VALUES(2, 'Ciuri', 'Ciurescu', 123458, 'Bucatar-Sef', 0, 2);
INSERT INTO Angajati VALUES(3, 'Mihai', 'Dobrescu', 123459, 'Receptioner', 1, 2);
INSERT INTO Angajati VALUES(4, 'David', 'Popa', 123410, 'Bucatar', 2, 2);
INSERT INTO Angajati VALUES(5, 'Andrei', 'Filip', 123333, 'CEO', NULL, 0);
INSERT INTO Angajati VALUES(6, 'Marius', 'Dumi', 123334, 'Manager', NULL, 1);
INSERT INTO Angajati VALUES(7, 'Tode', 'Lavric', 1233555, 'Majordom', 6, 1);

INSERT INTO TipCamera VALUES(0, 'Camera Single', 1, 120);
INSERT INTO TipCamera VALUES(1, 'Apartament', 2, 200);
INSERT INTO TipCamera VALUES(2, 'Penthouse', 4, 500);

INSERT INTO Camera VALUES(0, 2, 0, 11);
INSERT INTO Camera VALUES(1, 2, 0, 12);
INSERT INTO Camera VALUES(2, 2, 1, 21);
INSERT INTO Camera VALUES(3, 2, 2, 22);
INSERT INTO Camera VALUES(4, 2, 2, 30);
INSERT INTO Camera VALUES(5, 1, 0, 11);
INSERT INTO Camera VALUES(6, 1, 0, 12);
INSERT INTO Camera VALUES(7, 1, 1, 13);
INSERT INTO Camera VALUES(8, 0, 0, 11);
INSERT INTO Camera VALUES(9, 0, 0, 12);

INSERT INTO Clienti VALUES(0, 'George', 222222);
INSERT INTO Clienti VALUES(1, 'Laur', 22223);
INSERT INTO Clienti VALUES(2, 'Stafie', 233344);
INSERT INTO Clienti VALUES(3, 'Lila', 233345);
INSERT INTO Clienti VALUES(4, 'Costea', 233349);

INSERT INTO Rezervari VALUES(0, TO_DATE('2017-03-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2017-04-30 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), 0);
INSERT INTO Rezervari VALUES(1, TO_DATE('2018-06-2 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2018-07-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO Rezervari VALUES(2, TO_DATE('2019-03-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-05-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), 1);
INSERT INTO Rezervari VALUES(3, TO_DATE('2017-03-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2017-08-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), 2);
INSERT INTO Rezervari VALUES(4, TO_DATE('2017-03-1 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2017-03-31 19:35:20', 'YYYY-MM-DD HH24:MI:SS'), 3);

INSERT INTO CamereRezervate VALUES(0, 0);
INSERT INTO CamereRezervate VALUES(1, 0);
INSERT INTO CamereRezervate VALUES(2, 0);
INSERT INTO CamereRezervate VALUES(6, 1);
INSERT INTO CamereRezervate VALUES(7, 1);
INSERT INTO CamereRezervate VALUES(8, 2);
INSERT INTO CamereRezervate VALUES(1, 3);
INSERT INTO CamereRezervate VALUES(2, 3);
INSERT INTO CamereRezervate VALUES(3, 3);
INSERT INTO CamereRezervate VALUES(4, 3);

CREATE OR REPLACE PACKAGE Proiect
AS
    PROCEDURE Ex6(numeh Hotel.nume_hotel%TYPE);
    PROCEDURE Ex7;
    FUNCTION Ex8(nrc NUMBER) RETURN NUMBER;
    PROCEDURE Ex9(nume VARCHAR2);
END Proiect;
/
CREATE OR REPLACE PACKAGE BODY Proiect
AS
    PROCEDURE Ex6 (numeh Hotel.nume_hotel%TYPE) 
    AS
    	TYPE tbl_idx IS TABLE OF Angajati%ROWTYPE INDEX BY PLS_INTEGER;
    	t tbl_idx;
    BEGIN
    	SELECT * BULK COLLECT INTO t
    	FROM Angajati
    	WHERE desc_job = 'Manager';
    		
    	DBMS_OUTPUT.PUT_LINE('Sunt ' || t.COUNT || ' manageri la hotelul ' || numeh);
    	FOR i IN t.FIRST..t.LAST LOOP
    			DBMS_OUTPUT.PUT_LINE(t(i).nume || ' ' || t(i).prenume);
    	END LOOP;
    END;
    
    PROCEDURE Ex7
    AS
        v_nume Hotel.nume_hotel%TYPE;
        v_nr NUMBER(4);
    	CURSOR c IS 
    	    SELECT nume_hotel, COUNT(id_angajat)
    	    FROM Hotel h JOIN Angajati a ON (h.id_hotel = a.id_hotel)
    	    GROUP BY nume_hotel;
    BEGIN
        OPEN c;
        LOOP
        	FETCH c INTO v_nume, v_nr;
        	EXIT WHEN c%NOTFOUND;
        		
        	IF v_nr = 0 THEN
        	    DBMS_OUTPUT.PUT_LINE('In hotelul ' || v_nume || ' nu lucreaza angajati');
        	ELSIF v_nr = 1 THEN
        	    DBMS_OUTPUT.PUT_LINE('In hotelul ' || v_nume || ' lucreaza un angajat');
        	ELSE 
        	    DBMS_OUTPUT.PUT_LINE('In hotelul ' || v_nume || ' lucreaza '|| v_nr ||' angajati');
            END IF;
        END LOOP;
        CLOSE c;
    END;
    
    FUNCTION Ex8(nrc NUMBER) RETURN NUMBER
    IS
        nr_c_rez NUMBER;
        TYPE tbl_idx IS TABLE OF Camera%ROWTYPE INDEX BY PLS_INTEGER;
        aux tbl_idx;
        NEGATIVE_NUMBER EXCEPTION;
        NO_DATA_FOUND1 EXCEPTION;
        NO_DATA_FOUND2 EXCEPTION;
    BEGIN
        IF nrc < 0 THEN 
            RAISE NEGATIVE_NUMBER;
        END IF;
        SELECT * BULK COLLECT INTO aux FROM Camera WHERE nr_camera = nrc;
        IF SQL%NOTFOUND THEN
            RAISE NO_DATA_FOUND1;
        END IF;
        
        SELECT COUNT(r.id_rezervare) INTO nr_c_rez
        FROM Rezervari r JOIN CamereRezervate cr ON (r.id_rezervare = cr.id_rezervare)
        JOIN Camera c ON (cr.id_camera = c.id_camera)
        WHERE c.nr_camera = nrc;
        
        IF nr_c_rez = 0 THEN
            RAISE NO_DATA_FOUND2;
        ELSE
            RETURN nr_c_rez;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND1 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista camera cu numarul ' || nrc);
            RETURN -1;
        WHEN NO_DATA_FOUND2 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista rezervari pentru camerele cu numarul ' || nrc);
            RETURN -1;
        WHEN NEGATIVE_NUMBER THEN
            DBMS_OUTPUT.PUT_LINE('Nu sunt permise valori negative!');
            RETURN -1;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ('Codul erorii: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE ('Mesajul erorii: ' || SQLERRM);
            RETURN -1;
    END;
    
    PROCEDURE Ex9(nume VARCHAR2)
    AS
        TYPE tbl_idx_h IS TABLE OF Hotel.nume_hotel%TYPE INDEX BY PLS_INTEGER;
        v_nume tbl_idx_h;
        TYPE tbl_idx_cl IS TABLE OF Clienti%ROWTYPE INDEX BY PLS_INTEGER;
        aux tbl_idx_cl;
        NO_DATA_FOUND1 EXCEPTION;
        NO_DATA_FOUND2 EXCEPTION;
    BEGIN
        SELECT * BULK COLLECT INTO aux FROM Clienti WHERE nume_client = nume;
        IF SQL%NOTFOUND THEN
            RAISE NO_DATA_FOUND1;
        END IF;
        
        SELECT nume_hotel BULK COLLECT INTO v_nume
        FROM Hotel h JOIN Camera c ON (h.id_hotel = c.id_hotel)
        JOIN CamereRezervate cr ON (c.id_camera = cr.id_camera)
        JOIN Rezervari r ON (cr.id_rezervare = r.id_rezervare)
        JOIN Clienti c ON (r.id_client = c.id_client)
        WHERE nume_client = nume;
        
        IF v_nume.COUNT = 0 THEN
            RAISE NO_DATA_FOUND2;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Hotelurile la care s-a cazat clientul cautat: ');
        FOR i IN v_nume.FIRST..v_nume.LAST LOOP
            DBMS_OUTPUT.PUT_LINE(v_nume(i));
        END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND1 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista clientul cu numele ' || nume);
        WHEN NO_DATA_FOUND2 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista date de afisat');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE ('Codul erorii: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE ('Mesajul erorii: ' || SQLERRM);
    END;
END Proiect;
/

CREATE OR REPLACE PACKAGE Stiva
AS
    PROCEDURE Adauga(x NUMBER);
    PROCEDURE Scoate;
    FUNCTION Top RETURN NUMBER;
    TYPE tbl_imb IS TABLE OF NUMBER;
    stiva tbl_imb;
END Stiva;
/
CREATE OR REPLACE PACKAGE BODY Stiva
AS
    PROCEDURE Adauga(x NUMBER) AS
    BEGIN
        stiva.EXTEND(x);
    END;
    
    PROCEDURE Scoate
    AS
        NO_ELEMENTS EXCEPTION;
    BEGIN
        IF stiva.COUNT > 0 THEN
            stiva.DELETE(stiva.LAST);
        ELSE
            RAISE NO_ELEMENTS;
        END IF;
    EXCEPTION
        WHEN NO_ELEMENTS THEN
            DBMS_OUTPUT.PUT_LINE('Stiva este goala');
    END;
    
    FUNCTION Top RETURN NUMBER AS
    BEGIN
        RETURN stiva.LAST;
    END;
END Stiva;
/