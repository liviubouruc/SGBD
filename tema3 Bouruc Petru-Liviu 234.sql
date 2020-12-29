-- 1
/*
a) 2
b) text 2
c) text 3 adaugat in subbloc
d) 101 in bloc
e) mesaj1 adaugat in blocul principal
f) mesaj2 adaugat in blocul principal
*/

--2
CREATE TABLE octombrie_lbo as select * from octombrie_cdr;
delete from octombrie_lbo;
SET SERVEROUTPUT ON;
DECLARE
    rentals NUMBER(3) := 0;
    d NUMBER(3) := extract(day from last_day(sysdate));
BEGIN
    FOR i IN 1..d LOOP
        select count(*) into rentals from rental 
        where extract(day from book_date) = i and extract(month from book_date) = extract(month from sysdate);
        INSERT INTO octombrie_lbo VALUES (i, TO_DATE(i ||' 10' || ' 2020', 'DD MM YYYY'));
    END LOOP;
END;

--3 
DECLARE
    aux NUMBER(3) := 0;
    nume VARCHAR(101) := '&name';
BEGIN
    select count(title) into aux 
    from rental r join member m on (r.member_id = m.member_id) join title t on (t.title_id = r.title_id) 
    where lower(last_name) like '%' || lower(nume)|| '%' or lower(first_name) like '%' || lower(nume) || '%';
    dbms_output.put_line(nume || ': ' || aux);
END;

--4
DECLARE
    aux1 NUMBER(3) := 0;
    aux2 NUMBER(3) := 0;
    liviu NUMBER(3) := 0;
    nume VARCHAR(101) := '&name';
BEGIN
    select count(title) into aux1
    from rental r join member m on (r.member_id = m.member_id) join title t on (t.title_id = r.title_id) 
    where lower(last_name) like '%' || lower(nume) || '%' or lower(first_name) like '%' || lower(nume) || '%' 
    and rownum = 1;

    select count(title) into aux2 from rental join title using (title_id);
    
    dbms_output.put_line(nume || ': ' || r);
    
    liviu := (aux1/aux2) * 100;
    if liviu > 75 then dbms_output.put_line('Categoria 1');
    elsif liviu > 50 then dbms_output.put_line('Categoria 2');
    elsif liviu > 25 then dbms_output.put_line('Categoria 3');
    else dbms_output.put_line('Categoria 4');
    end if;
END;


--5
create table member_lbo as (select * from member);

ALTER TABLE member_lbo
ADD CONSTRAINT PK_member_lbo PRIMARY KEY (member_id);

alter table member_lbo
add discount number;

SET VERIFY OFF
DECLARE
    id_membru member_lbo.member_id%TYPE := &cod;
    titluri_1 number;
    titluri_2 number;
BEGIN
    select count(distinct title_id)
    into titluri_1
    from rental r join member_lbo m using (member_id)
    group by member_id
    having member_id = id_membru;
    
    
    select count(*)
    into titluri_2
    from title;
    
    CASE WHEN titluri_1 * 100 / titluri_2 >= 75 THEN 
            UPDATE member_lbo
            SET DISCOUNT = 10
            WHERE MEMBER_ID = id_membru;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('modificare!');
        WHEN titluri_1 * 100 / titluri_2 >= 50 THEN 
            UPDATE member_lbo
            SET DISCOUNT = 5
            WHERE MEMBER_ID = id_membru;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('modificare!');
        WHEN titluri_1 * 100 / titluri_2 >= 25 THEN
            UPDATE member_lbo
            SET DISCOUNT = 3
            WHERE MEMBER_ID = id_membru;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('modificare!');
        ELSE DBMS_OUTPUT.PUT_LINE('Nicio modificare');
    END CASE;        
EXCEPTION
    WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Nicio modificare');
END;
/ 
SET VERIFY ON;