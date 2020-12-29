 procedure insert_emp( 

        lname   emp_cdr.last_name%type, 

        fname   emp_cdr.first_name%type, 

        phone   emp_cdr.phone_number%type, 

        email   emp_cdr.email%type, 

        dep_name    dept_cdr.department_name%type, 

        man_lname   emp_cdr.last_name%type, 

        man_fname   emp_cdr.first_name%type, 

        job_name    jobs_cdr.job_title%type 

    ) 

    is 

        v_salary    emp_cdr.salary%type; 

        man_id      emp_cdr.employee_id%type; 

        dep_id      dept_cdr.department_id%type; 

        job_id      emp_cdr.job_id%type; 

    begin 

        man_id := get_emp_id(man_lname, man_fname); 

        dep_id := get_dept_id(dep_name); 

        job_id := get_job_id(job_name); 

        v_salary := get_salary(dep_id, job_id); 

         

        insert into emp_cdr values( 

            sec_cdr.nextval, 

            fname, 

            lname, 

            email, 

            phone, 

            sysdate, 

            job_id, 

            v_salary, 

            null, -- comision 

            man_id, 

            dep_id          

        ); 

        commit; 

    end insert_emp; 

     

    function get_emp_id( 

        lname   emp_cdr.last_name%type, 

        fname   emp_cdr.first_name%type 

    ) return emp_cdr.employee_id%type 

    is 

        v_id    emp_cdr.employee_id%type; 

    begin 

        select employee_id into v_id 

        from emp_cdr 

        where last_name = lname and 

            first_name = fname; 

         

        return v_id; 

    exception 

        WHEN no_data_found THEN 

            raise_application_error(-20010, 'Nu exista angajat cu numele si prenumele dat'); 

        when too_many_rows then 

            raise_application_error(-20011, 'Exista mai multi angajati cu numele si prenumele dat'); 

        when others then 

            raise_application_error(-20012, 'Alta eroare in gasirea id-ului angajatului!'); 

    end get_emp_id; 

     

    function get_dept_id( 

        dname   dept_cdr.department_name%type 

    ) return dept_cdr.department_id%type 

    is 

        v_id    dept_cdr.department_id%type; 

    begin 

        select department_id into v_id 

        from dept_cdr 

        where department_name = dname; 

         

        return v_id; 

    exception 

        WHEN no_data_found THEN 

            raise_application_error(-20013, 'Nu exista departament cu numele dat'); 

        when too_many_rows then 

            raise_application_error(-20014, 'Exista mai multe departamente cu numele dat'); 

        when others then 

            raise_application_error(-20015, 'Alta eroare la gasirea departamentului!'); 

    end get_dept_id; 

     

    function get_job_id( 

        jname   jobs_cdr.job_title%type 

    ) return jobs_cdr.job_id%type 

    is 

        v_id    jobs_cdr.job_id%type; 

    begin 

        select job_id into v_id 

        from jobs_cdr 

        where job_title = jname; 

         

        return v_id; 

    exception 

        WHEN no_data_found THEN 

            raise_application_error(-20016, 'Nu exista joburi cu titlul dat'); 

        when too_many_rows then 

            raise_application_error(-20017, 'Exista mai multe joburi cu numele dat'); 

        when others then 

            raise_application_error(-20018, 'Alta eroare la gasirea jobului!'); 

    end get_job_id; 

     

    function get_salary( 

        dep_id  emp_cdr.department_id%type, 

        j_id  jobs_cdr.job_id%type 

    ) return emp_cdr.salary%type 

    is 

        v_salary    emp_cdr.salary%type; 

    begin 

        select min(salary) into v_salary 

        from emp_cdr 

        where job_id = j_id and 

            department_id = dep_id; 

         

        return v_salary; 

    exception 

        when no_data_found then 

            raise_application_error(-20019, 'Nu exista angajati cu acest job in acel departament'); 

        when others then 

            raise_application_error(-20020, 'Alta eroare la gasirea salariului!'); 

    end get_salary; 

     

    -- ex 1 b ------------------------------------------------------------------ 

    procedure move_emp( 

        lname       emp_cdr.last_name%type, 

        fname       emp_cdr.first_name%type, 

        dep_name    dept_cdr.department_name%type, 

        j_title     jobs_cdr.job_title%type, 

        man_lname   emp_cdr.last_name%type, 

        man_fname   emp_cdr.first_name%type  

    ) 

    is 

        emp_id      emp_cdr.employee_id%type; 

        dep_id      dept_cdr.department_id%type; 

        j_id        jobs_cdr.job_id%type;   

        man_id      emp_cdr.employee_id%type; 

        v_salary    emp_cdr.salary%type; 

        sal_curent  emp_cdr.salary%type; 

        v_emp       emp_cdr%rowtype; 

    begin 

        emp_id := get_emp_id(lname, fname); 

        dep_id := get_dept_id(dep_name); 

        j_id   := get_job_id(j_title); 

        man_id := get_emp_id(man_lname, man_fname); 

         

        select * into v_emp 

        from emp_cdr 

        where employee_id = emp_id; 

         

        if v_emp.salary > v_salary then 

            v_salary := v_emp.salary; 

        end if; 

         

        insert into job_history_cdr values( 

            emp_id, 

            v_emp.hire_date, 

            sysdate, 

            v_emp.job_id, 

            v_emp.department_id 

        ); 

         

        update emp_cdr 

        set 

            department_id = dep_id, 

            job_id = j_id, 

            manager_id = man_id, 

            salary = v_salary, 

            commission_pct = (select min(commission_pct) from emp_cdr  

                                where department_id = dep_id and 

                                    job_id = j_id), 

            hire_date = sysdate 

        where 

            employee_id = emp_id; 

        commit; 

    end move_emp; 