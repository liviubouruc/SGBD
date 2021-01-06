--ex1a
CREATE OR REPLACE PACKAGE ex1a AS
    PROCEDURE AdaugaEmp(
            emp_id employees.employee_id%TYPE,
            f_name employees.first_name%TYPE,
            l_name employees.last_name%TYPE,
            phone employees.phone_number%TYPE,
            email employees.email%TYPE,
            department departments.department_name%TYPE,
            job_title jobs.job_title%TYPE),
            boss_f_name employees.first_name%TYPE,
            boss_l_name employees.last_name%TYPE;
    FUNCTION GetUserId(f_name employees.first_name%TYPE, l_name employees.last_name%TYPE) RETURN employees.employee_id%TYPE;
    FUNCTION GetDepartmentId(department departments.department_name%TYPE) RETURN departments.department_id%TYPE;
    FUNCTION GetJobId(job_title jobs.job_title%TYPE) RETURN jobs.job_id%TYPE;
END ex1a;
/
CREATE OR REPLACE PACKAGE BODY ex1a AS
    PROCEDURE AdaugaEmp(
            emp_id employees.employee_id%TYPE,
            f_name employees.first_name%TYPE,
            l_name employees.last_name%TYPE,
            email employees.email%TYPE,
            phone employees.phone_number%TYPE,
            boss_f_name employees.first_name%TYPE,
            boss_l_name employees.last_name%TYPE,
            department departments.department_name%TYPE,
            job_title jobs.job_title%TYPE)
    AS
        v_manager_id employees.employee_id%TYPE;
        v_department_id departments.department_id%TYPE;
        v_salary employees.salary%TYPE;
        v_job_id jobs.job_id%TYPE;
    BEGIN
        v_manager_id := GetUserId(boss_f_name, boss_l_name);
        v_department_id := GetDepartmentId(department);
        v_job_id := GetJobId(job_title);
        
        SELECT MIN(salary) INTO v_salary
        FROM employees
        WHERE department_id = v_department_id;
        
        INSERT INTO employees VALUES(emp_id, f_name, l_name, email, phone, sysdate, v_job_id, v_salary, NULL, v_manager_id, v_department_id);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Prea multe interogragi gasite');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu au fost gasite date');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare');
    END AdaugaEmp;
    
    FUNCTION GetUserId(f_name employees.first_name%TYPE, l_name employees.last_name%TYPE) RETURN employees.employee_id%TYPE
    AS
        v_user_id employees.employee_id%TYPE;
    BEGIN
        SELECT employee_id INTO v_user_id
        FROM employees
        WHERE first_name = f_name AND last_name = l_name;
        
        RETURN v_user_id;
    END GetUserId;
    
    FUNCTION GetDepartmentId(department departments.department_name%TYPE) RETURN departments.department_id%TYPE
    AS
        v_department_id departments.department_id%TYPE;
    BEGIN
        SELECT department_id INTO v_department_id
        FROM departments
        WHERE department_name = department;
        
        RETURN v_department_id;
    END GetDepartmentId;
    
    FUNCTION GetJobId(job_title jobs.job_title%TYPE) RETURN jobs.job_id%TYPE
    AS
        v_job_id jobs.job_id%TYPE;
    BEGIN
        SELECT job_id INTO v_job_id
        FROM jobs
        WHERE job_title = job_title;
        
        RETURN v_job_id;
    END GetJobId;
END ex1a;
/

--ex1b
CREATE OR REPLACE PACKAGE ex1b AS
    PROCEDURE MoveEmployee(
            emp_id employees.employee_id%TYPE,
            boss_f_name employees.first_name%TYPE,
            boss_l_name employees.last_name%TYPE,
            department departments.department_name%TYPE,
            job_title jobs.job_title%TYPE);
            
    FUNCTION GetUserId(f_name employees.first_name%TYPE, l_name employees.last_name%TYPE) RETURN employees.employee_id%TYPE;
    FUNCTION GetDepartmentId(department departments.department_name%TYPE) RETURN departments.department_id%TYPE;
    FUNCTION GetJobId(job_title jobs.job_title%TYPE) RETURN jobs.job_id%TYPE;
END ex1b;
/
CREATE OR REPLACE PACKAGE BODY ex1b AS
   PROCEDURE MoveEmp(
            emp_id employees.employee_id%TYPE,
            boss_f_name employees.first_name%TYPE,
            boss_l_name employees.last_name%TYPE,
            department departments.department_name%TYPE,
            job_title jobs.job_title%TYPE)
        AS
        v_manager_id employees.employee_id%TYPE;
        v_department_id departments.department_id%TYPE;
        job_id_d jobs.job_id%TYPE;
    BEGIN
        v_manager_id := GetUserId(boss_f_name, boss_l_name);
        v_department_id := GetDepartmentId(department);
        v_job_id := GetJobId(job_title);
        
        UPDATE employees
        SET manager_id = v_manager_id, department_id = v_department_id, job_id = v_job_id
        WHERE employee_id = emp_id;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Prea multe interogragi gasite');
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nu au fost gasite date');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Eroare');
    END MoveEmp;
    
    FUNCTION GetUserId(f_name employees.first_name%TYPE, l_name employees.last_name%TYPE) RETURN employees.employee_id%TYPE
    AS
        v_user_id employees.employee_id%TYPE;
    BEGIN
        SELECT employee_id INTO v_user_id
        FROM employees
        WHERE first_name = f_name AND last_name = l_name;
        
        RETURN v_user_id;
    END GetUserId;
    
    FUNCTION GetDepartmentId(department departments.department_name%TYPE) RETURN departments.department_id%TYPE
    AS
        v_department_id departments.department_id%TYPE;
    BEGIN
        SELECT department_id INTO v_department_id
        FROM departments
        WHERE department_name = department;
        
        RETURN v_department_id;
    END GetDepartmentId;
    
    FUNCTION GetJobId(job_title jobs.job_title%TYPE) RETURN jobs.job_id%TYPE
    AS
        v_job_id jobs.job_id%TYPE;
    BEGIN
        SELECT job_id INTO v_job_id
        FROM jobs
        WHERE job_title = job_title;
        
        RETURN v_job_id;
    END GetJobId;
END ex1b;
/