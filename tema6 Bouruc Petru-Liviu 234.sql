SET SERVEROUTPUT ON;

-- 1 a)
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr;
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    ct NUMBER(5);
BEGIN
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i);
        DBMS_OUTPUT.PUT_LINE(v_job_title);
        ct := 0;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO v_fname, v_lname, v_salary;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname || ' ' || v_salary);
            ct := ct + 1;
        END LOOP;
        CLOSE c;
        IF ct = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat.');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/
    
-- 1 b)
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name l_name, e.first_name f_name, e.salary salary
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr;
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    ct NUMBER(5);
BEGIN
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP 
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i);
        DBMS_OUTPUT.PUT_LINE(v_job_title);
        ct := 0;
        
        FOR j IN c(joburi(i)) LOOP
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(j.f_name || ' ' || j.l_name || ' ' || j.salary);
            ct := ct + 1;
        END LOOP;
        IF ct = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat.');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/
    
-- 1 c)        
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name l_name, e.first_name f_name, e.salary salary
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr;
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    ct NUMBER(5);
BEGIN
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i);
        DBMS_OUTPUT.PUT_LINE(v_job_title);
        ct := 0;
        
        FOR j IN (SELECT e.last_name l_name, e.first_name f_name, e.salary salary FROM employees e, jobs j WHERE j.job_id = e.job_id and j.job_id = joburi(i)) LOOP
            DBMS_OUTPUT.PUT_LINE(j.f_name || ' ' || j.l_name || ' ' || j.salary);
            ct := ct + 1;
        END LOOP;
        IF ct = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat.');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/


-- 1 d)
DECLARE 
    TYPE refcursor IS REF CURSOR;
    CURSOR c IS 
        SELECT jo.job_title, CURSOR
            (SELECT e.last_name, e.first_name, e.salary
            FROM employees e, jobs j
            WHERE j.job_id = e.job_id and j.job_id = jo.job_id)
        FROM jobs jo;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    v_job jobs.job_title%TYPE;
    v_cursor refcursor;
    ct NUMBER(5);
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_job, v_cursor;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_job);
        LOOP 
            FETCH v_cursor INTO v_fname, v_lname, v_salary;
            EXIT WHEN v_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname || ' ' || v_salary);
        END LOOP; 
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/


-- 2
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr;
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    nr_salariati NUMBER(5);
    ct NUMBER(5);
    v_sal_tot_job NUMBER(8,2);
    avg_salary NUMBER(8,2);
    v_sal_tot NUMBER(10,2) := 0;
    v_sal_med NUMBER(10,2) := 0;
    v_ct_tot NUMBER(5) := 0;
BEGIN
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP 
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i);     
        ct := 0;
        v_sal_tot_job := 0;
        
        SELECT count(*)
        INTO nr_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and j.job_id = joburi(i);
        
        IF nr_salariati = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe postul de ' || v_job_title);
        ELSIF nr_salariati = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Un angajat lucreaza ca ' || v_job_title);
        ELSIF nr_salariati < 20 THEN
            DBMS_OUTPUT.PUT_LINE(nr_salariati || ' angajati lucreaza ca ' || v_job_title);
        ELSE
            DBMS_OUTPUT.PUT_LINE(nr_salariati || ' de angajati lucreaza ca ' || v_job_title);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO v_fname, v_lname, v_salary;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(ct + 1 || ' ' || v_fname || ' ' || v_lname || ' ' || v_salary);
            ct := ct + 1;
            v_sal_tot_job := v_sal_tot_job + v_salary;
            v_ct_tot := v_ct_tot + 1;
        END LOOP;
        CLOSE c;
        
        v_sal_tot := v_sal_tot + v_sal_tot_job;
        IF ct = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat.');
        ELSE
            avg_salary := v_sal_tot_job / ct;
            DBMS_OUTPUT.PUT_LINE('Salariul total al angajatilor este ' || v_sal_tot_job || ' iar cel mediu este ' || avg_salary);
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    v_sal_med := v_sal_tot / v_ct_tot;
    DBMS_OUTPUT.PUT_LINE('Salariul total al tuturor angajatilor este ' || v_sal_tot || ' iar cel mediu este ' || v_sal_med);
END;
/
    
-- 3
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary, e.commission_pct
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr;
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    nr_salariati NUMBER(5);
    ct NUMBER(5);
    v_sal_tot_job NUMBER(8,2);
    avg_salary NUMBER(8,2);
    v_sal_tot NUMBER(10,2) := 0;
    v_sal_med NUMBER(10,2) := 0;
    v_ct_tot NUMBER(5) := 0;
    commission_pct NUMBER(5) := 0;
    v_total_cu_comision NUMBER(10,2) := 0;
BEGIN
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
    
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i);     
        ct := 0;
        v_sal_tot_job := 0;
        
        SELECT count(*)
        INTO nr_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and
            j.job_id = joburi(i);
            
        SELECT SUM(salary) + SUM(salary*commission_pct)
        INTO v_total_cu_comision
        FROM EMPLOYEES;
        
        IF nr_salariati = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu lucreaza niciun angajat pe postul de ' || v_job_title);
        ELSIF nr_salariati = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Un angajat lucreaza ca ' || v_job_title);
        ELSIF nr_salariati < 20 THEN
            DBMS_OUTPUT.PUT_LINE(nr_salariati || ' angajati lucreaza ca ' || v_job_title);
        ELSE
            DBMS_OUTPUT.PUT_LINE(nr_salariati || ' de angajati lucreaza ca ' || v_job_title);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO v_fname, v_lname, v_salary, commission_pct;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(ct + 1 || ' ' || v_fname || ' ' || v_lname || ' ' || v_salary || ' ' || TO_CHAR(((v_salary + (v_salary * nvl(commission_pct, 0))) * 100 / v_total_cu_comision), '0.00'));
            
            ct := ct + 1;
            v_sal_tot_job := v_sal_tot_job + v_salary;
            v_ct_tot := v_ct_tot + 1;
        END LOOP;
        CLOSE c;
        
        v_sal_tot := v_sal_tot + v_sal_tot_job;
        IF ct = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun angajat.');
        ELSE
            avg_salary := v_sal_tot_job / ct;
            DBMS_OUTPUT.PUT_LINE('Salariul total al angajatilor este ' || v_sal_tot_job || ' iar cel mediu este ' || avg_salary);
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    v_sal_med := v_sal_tot / v_ct_tot;
    DBMS_OUTPUT.PUT_LINE('Salariul total al tuturor angajatilor este ' || v_sal_tot || ' iar cel mediu este ' || v_sal_med);
END;
/
    

-- 4
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary, e.commission_pct
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and
                j.job_id = job_curr
        ORDER BY e.salary DESC; 
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    nr_salariati NUMBER(5);
    ct NUMBER(5);
    v_sal_tot_job NUMBER(8,2);
    avg_salary NUMBER(8,2);
    v_sal_tot NUMBER(10,2) := 0;
    v_sal_med NUMBER(10,2) := 0;
    v_ct_tot NUMBER(5) := 0;
    commission_pct NUMBER(5) := 0;
    v_total_cu_comision NUMBER(10,2) := 0;
BEGIN  
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        ct := 0;
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i); 
        
        SELECT count(*)
        INTO nr_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and
            j.job_id = joburi(i);

        IF nr_salariati < 5 THEN
            DBMS_OUTPUT.PUT_LINE('Lucreaza mai putin de 5 angajati ca  ' || v_job_title);
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_job_title);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO v_fname, v_lname, v_salary, commission_pct;
            EXIT WHEN c%NOTFOUND or c%ROWCOUNT > 5;
            DBMS_OUTPUT.PUT_LINE(ct + 1 || ' ' || v_fname || ' ' || v_lname || ' ' || v_salary);
            ct := ct + 1;
        END LOOP;
        CLOSE c;  
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/


-- 5
DECLARE 
    TYPE tip_joburi IS TABLE OF jobs.job_id%TYPE;
    CURSOR c (job_curr jobs.job_id%TYPE)IS 
        SELECT e.last_name, e.first_name, e.salary, e.commission_pct
        FROM employees e, jobs j
        WHERE j.job_id = e.job_id and j.job_id = job_curr
        ORDER BY e.salary DESC; 
    nr_joburi NUMBER;
    v_job_title jobs.job_title%TYPE;
    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;
    v_salary employees.salary%TYPE;
    joburi tip_joburi := tip_joburi();
    nr_salariati NUMBER(5);
    ct NUMBER(5);
    v_sal_tot_job NUMBER(8,2);
    avg_salary NUMBER(8,2);
    v_sal_tot NUMBER(10,2) := 0;
    v_sal_med NUMBER(10,2) := 0;
    v_ct_tot NUMBER(5) := 0;
    commission_pct NUMBER(5) := 0;
    v_total_cu_comision NUMBER(10,2) := 0;
    aux employees.salary%TYPE;
BEGIN   
    SELECT COUNT(*)
    INTO nr_joburi
    FROM jobs;
    
    joburi.EXTEND(nr_joburi);
    
    SELECT j.job_id
    BULK COLLECT INTO joburi
    FROM jobs j;
    
    FOR i IN joburi.FIRST..joburi.LAST LOOP   
        aux := 0;
        ct := 0;
        SELECT job_title
        INTO v_job_title
        FROM jobs j
        WHERE j.job_id = joburi(i); 
        
        SELECT count(*)
        INTO nr_salariati
        FROM employees e, jobs j
        WHERE e.job_id = j.job_id and j.job_id = joburi(i);

        IF nr_salariati < 5 THEN
            DBMS_OUTPUT.PUT_LINE('Lucreaza mai putin de 5 angajati ca  ' || v_job_title);
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_job_title);
        END IF;
        
        OPEN c(joburi(i));
        LOOP
            FETCH c INTO v_fname, v_lname, v_salary, commission_pct;
            EXIT WHEN c%NOTFOUND or c%ROWCOUNT > 5;
            IF aux = 0 or v_salary <> aux THEN
                aux := v_salary;
                ct := ct + 1;
            END IF;
            DBMS_OUTPUT.PUT_LINE(ct || ' ' || v_fname || ' ' || v_lname || ' ' || v_salary);
        END LOOP;
        CLOSE c;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/