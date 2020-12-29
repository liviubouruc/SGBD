--22
-- Executia unui astfel de script poate determina eroare atunci cand, spre exemplu, vrem sa stergem ceva ce nu exista (tabel, constrangere).
-- Putem preveni asta prin verificarea existentei acestora
--23
SPOOL C:\Users\bouru\Documents\SGBD\SpoolTest2.sql; 

select 'insert into dep_lbo values (' || department_id || ', ''' || department_name || ''', ' || manager_id || ', ' || location_id || ');'
from departments;

spool off;