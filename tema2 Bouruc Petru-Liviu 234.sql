--ex9
select m.first_name, m.last_name, t.title_id, count(t.title_id)
from member m join rental r on (m.member_id = r .member_id) join title t on (r.title_id = t.title_id)
group by  m.first_name, m.last_name, t.title_id;

--ex10
select m.first_name, m.last_name, t.title_id, tc.copy_id, count(tc.copy_id)
from member m join rental r on (m.member_id = r.member_id) join title t on (r.title_id = t.title_id) join title_copy tc on(t.title_id = tc.title_id)
group by  m.first_name, m.last_name, t.title_id, tc.copy_id;

--ex11
select t.title, tc.status 
from title_copy tc join title t on (tc.title_id = t.title_id)
where tc.copy_id = 
(
    select copy_id from 
    (select copy_id from rental r where r.title_id = title_id group by title_id, copy_id order by count(copy_id) desc)
    where rownum = 1
);

--ex12
--b
select book_date, count(*) from rental 
where extract(month from book_date) = extract(month from sysdate) 
group by book_date;