SET SERVEROUTPUT ON;
-- 1
DECLARE
    TYPE t_codes IS TABLE OF emp_lbo.employee_id%TYPE  
    INDEX BY PLS_INTEGER;
    TYPE t_salaries IS TABLE OF emp_lbo.salary%TYPE;
    v_codes t_codes;
    v_salaries t_salaries;
BEGIN
    SELECT employee_id, salary BULK COLLECT INTO v_codes, v_salaries
    FROM (SELECT * FROM emp_lbo ORDER BY SALARY)
    WHERE ROWNUM <= 5;

    FOR i IN 1..5 LOOP
        UPDATE emp_lbo
        SET salary = salary * 1.05
        WHERE employee_id = v_codes(i);
        DBMS_OUTPUT.PUT(v_codes(i) || ' ' || v_salaries(i) || ' ' || v_salaries(i)*1.05);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
/
ROLLBACK;

--2
CREATE OR REPLACE TYPE tip_orase_lbo IS TABLE OF VARCHAR(20); 
/ 
CREATE TABLE excursie_lbo (cod_excursie NUMBER(4), denumire VARCHAR2(20), status VARCHAR2(12));
ALTER TABLE excursie_lbo ADD (orase tip_orase_lbo) NESTED TABLE orase STORE AS tabel_orase_lbo;

--a
INSERT INTO excursie_lbo VALUES (1, 'romania', 'disponibil', tip_orase_lbo('Bucurest', 'Vaslui', 'iasi'));
INSERT INTO excursie_lte VALUES (2, 'uk', 'disponibil', tip_orase_lbo('Londra', 'Liverpool'));
INSERT INTO excursie_lte VALUES (3, 'italia', 'disponibil', tip_orase_lbo('Roma', 'Milano', 'Venetia'));
INSERT INTO excursie_lte VALUES (4, 'franta', 'anulat', tip_orase_lbo('Paris', 'Marseille', 'Nice'));
INSERT INTO excursie_lte VALUES (5, 'spania', 'anulat', tip_orase_lbo('Madrid', 'Barcelona'));
COMMIT;

--b
DECLARE  
    t tip_orase_lbo := tip_orase_lbo();
    nume_excursie varchar2(20) := &e;
BEGIN 
    SELECT orase INTO t FROM excursie_lbo WHERE denumire = nume_excursie;
    
    t.extend;
    t(t.count):= &nume_oras;
    
    UPDATE excursie_lbo SET orase = t WHERE denumire = nume_excursie;
END;
/
ROLLBACK;

--
DECLARE  
    tb tip_orase_lbo := tip_orase_lbo(); 
    aux tip_orase_lbo := tip_orase_lbo();
    nume_excursie varchar2(20) := &e;
BEGIN 
    SELECT orase INTO tb FROM excursie_lbo WHERE denumire = nume_excursie;
    
    FOR i IN 1..tb.count LOOP 
        aux.extend; 
        if i = 1 then 
            aux(i):= tb(i);
        end if;
        if i = 2 then
            aux(i) := &nume_oras;
            aux.extend;
            aux(i+1) := tb(i);
        end if;
        if i > 2 then
            aux(i+1) := tb(i);
        end if;
    END LOOP;
    
    UPDATE excursie_lbo SET orase = aux WHERE denumire = nume_excursie;
END;
/
ROLLBACK;

--
DECLARE  
    t tip_orase_lbo := tip_orase_lbo();
    nume_excursie varchar2(20) := &e;
    o1 VARCHAR(20) := &oras1;
    o2 VARCHAR(20) := &oras2;
BEGIN 
    SELECT orase INTO t FROM excursie_lbo WHERE denumire = nume_excursie;
    
    FOR i IN 1..t.count LOOP 
        if t(i) = o1 then 
            t(i):= o2;
        else
            if t(i) = o2 then 
                t(i):= o1;
            end if;
        end if;
    END LOOP;
    
    UPDATE excursie_lbo SET orase = t WHERE denumire = nume_excursie;
END;
/
ROLLBACK;

--
DECLARE  
    tb tip_orase_lbo := tip_orase_lbo();
    aux tip_orase_lbo := tip_orase_lbo();
    nume_excursie varchar2(20) := &exc;
    o varchar2(20) := &oras;
    j number := 1;
BEGIN 
    SELECT orase INTO t FROM excursie_lbo WHERE denumire = nume_excursie;
    
    FOR i IN 1..tb.count LOOP 
        if tb(i) != o then
            aux.extend;
            aux(j):= tb(i);
            j := j + 1;
        end if;
    END LOOP;
    
    UPDATE excursie_lbo SET orase = aux WHERE denumire = nume_excursie;
END;
/
ROLLBACK;

-- c
DECLARE  
    t tip_orase_lbo := tip_orase_lbo();
    cod number(4) := &cod;
BEGIN 
    SELECT orase INTO t
    FROM excursie_lbo WHERE cod_excursie = cod;
    DBMS_OUTPUT.PUT_LINE(t.count || ' orase: ');
    FOR i IN 1..t.count LOOP 
        DBMS_OUTPUT.PUT_LINE(t(i) || ' ');
    END LOOP;
END;
/