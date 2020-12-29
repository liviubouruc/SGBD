SET SERVEROUTPUT ON;

--ex3
CREATE OR REPLACE FUNCTION f3(oras locations.city%TYPE)
RETURN NUMBER
IS
    v_utilizator info_ari.utilizator%TYPE;
    sol NUMBER;
    v_err VARCHAR2(100);
BEGIN
    SELECT user INTO v_utilizator from dual;
    IF oras IS NULL THEN
        INSERT INTO info_lbo VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_lbo), v_utilizator, sysdate, NULL, 0, 'valoare nula!');
        RETURN 0;
    END IF;
    
    SELECT COUNT(*) INTO sol
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    JOIN locations l ON (l.location_id = d.location_id)
    WHERE (SELECT COUNT(*)
           FROM job_history
           WHERE employee_id = e.employee_id) >= 1;
    
    IF sol = 0 THEN v_err := 'nu sunt angajati!';
    END IF;
    INSERT INTO info_lbo
            VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_lbo), v_utilizator, sysdate, NULL, 0, v_err);
            
    RETURN sol;
END;
/
--ex4
CREATE OR REPLACE PROCEDURE f4 (manager_id employees.employee_id%TYPE)
IS
    v_utilizator info_ari.utilizator%TYPE;
    v_err VARCHAR2(100);
    nr_lin NUMBER;
BEGIN
    SELECT user INTO v_utilizator from dual;
    
    UPDATE employees SET salary = salary*1.10 WHERE employee_id = manager_id;
        
    nr_lin := SQL%ROWCOUNT;
    
    IF nr_lin = 0 THEN
        INSERT INTO info_lbo VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_lbo), v_utilizator, sysdate, NULL, 0, 'manager inexistent!');
        RETURN;
    END IF;
    
    INSERT INTO info_lbo VALUES((SELECT NVL(MAX(id), 0) + 1 FROM info_lbo), v_utilizator, sysdate, NULL, 0, v_err);
    
    FOR i IN (SELECT employee_id FROM employees WHERE manager_id = manager_id) LOOP
        f4(i.employee_id);
    END LOOP;
END;
/
--ex5
CREATE OR REPLACE PROCEDURE informatii_lbo
IS
    v_utilizator info_ari.utilizator%TYPE;
    nr_lin NUMBER;
    v_zi NUMBER;
BEGIN
    SELECT user INTO v_utilizator from dual;
    
    FOR d IN (SELECT * FROM departments) LOOP
        DBMS_OUTPUT.PUT_LINE('Departmentul ' || d.department_name || ':');
        
        SELECT COUNT(*) INTO nr_lin FROM employees WHERE department_id = d.department_id;
        
        IF nr_lin = 0 THEN
            DBMS_OUTPUT.PUT_LINE('nu sunt angajati');
            CONTINUE;
        END IF;
        
        SELECT zi INTO v_zi
        FROM (SELECT EXTRACT (DAY FROM hire_date) zi, COUNT(*) FROM employees e
              WHERE e.department_id = d.department_id
              GROUP BY EXTRACT(DAY FROM hire_date) ORDER BY COUNT(*) DESC)
        WHERE rownum = 1;
        
        DBMS_OUTPUT.PUT_LINE('Zi maxima: ' || v_zi);
        
        FOR e IN (SELECT * FROM employees WHERE department_id = d.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE('Nume: ' || e.first_name || ', salariu: ' || e.salary);
        END LOOP;
    END LOOP;
END;
/
