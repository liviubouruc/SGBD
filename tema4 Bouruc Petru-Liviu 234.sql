SET SERVEROUTPUT ON;
--1 a
DECLARE
    TYPE job_record IS RECORD (
        job_id jobs.job_id%TYPE,
        job_title jobs.job_title%TYPE,
        avg_salary jobs.min_salary%TYPE
        );
        my_var job_record;
BEGIN
    my_var.job_id := 1;
    my_var.job_title := 'Brutar';
    my_var.avg_salary := 1250;
    DBMS_OUTPUT.PUT_LINE(my_var.job_id || ' ' || my_var.job_title || ' ' || my_var.avg_salary);
END;
/

--1 b
DECLARE
    TYPE job_record IS RECORD (
        job_id jobs.job_id%TYPE,
        job_title jobs.job_title%TYPE,
        avg_salary jobs.min_salary%TYPE
        );
    my_var job_record;
BEGIN
    select job_id, job_title, (min_salary + max_salary)/2
    into my_var
    from jobs where job_id = 'IT_PROG';
    DBMS_OUTPUT.PUT_LINE(my_var.job_id || ' ' || my_var.job_title || ' ' || my_var.avg_salary);
END;
/
    
--1 c
create table jobs_lbo as (select * from jobs);

SET SERVEROUTPUT ON;
DECLARE
    TYPE job_record IS RECORD (
        job_id jobs.job_id%TYPE,
        job_title jobs.job_title%TYPE,
        avg_salary jobs.min_salary%TYPE
        );
        my_var job_record;
BEGIN
    delete from jobs_lbo where job_id = 'ST_MAN'
    returning job_id, job_title, (min_salary + max_salary)/2 into my_var;
    ROLLBACK;
END;
/
    
--2 
create table emp_lbo as (select * from employees);

DECLARE
    mina emp_lbo%rowtype;
    maxa emp_lbo%rowtype;
BEGIN
    select * into mina
    from (select * from emp_lbo order by salary asc) where rownum <= 1;
    select * into maxa
    from (select * from emp_lbo order by salary desc) where rownum <= 1;
    
    if (mina.salary < maxa.salary * 0.1)
    then update emp_lbo set salary = salary * 1.1 where employee_id = mina.employee_id;
    end if;
    
    ROLLBACK;
END;
/

--3
create table dept_lbo as (select * from departments);
DECLARE
    x dept_lbo%rowtype;
    y dept_lbo%rowtype;
BEGIN
    x.department_id := 300;
    x.department_name := 'Research';
    x.manager_id := 103;
    x.location_id := 1700;
 
    insert into dept_lbo values x;

    delete from dept_lbo where department_id = 50 returning department_id, department_name, location_id, manager_id into y;
    DBMS_OUTPUT.PUT_LINE(y.department_id || ' ' || y.department_name || ' ' || y.location_id);

ROLLBACK;
END;
/

--4
Declare
    type tablou is table of emp_lbo%rowtype index by binary_integer;
    v tablou;
BEGIN
    delete from emp_lbo
    where commission_pct >= 0.1 and commission_pct <= 0.3
        returning employee_id, first_name, last_name,email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
        into v;
    
    for i in v.first..v.last loop
        DBMS_OUTPUT.PUT_LINE(v(i).employee_id || ' ' || v(i).first_name || ' 0' || v(i).commission_pct);
    end loop;
    ROLLBACK;
END;