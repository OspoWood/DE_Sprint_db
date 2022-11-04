select id,
       concat(last_name, ' ', first_name, ' ', participant) fullname,
       current_date - start_work                            experience_days
from employees;

select id,
       concat(last_name, ' ', first_name, ' ', participant) fullname,
       current_date - start_work                            experience_days
from employees
limit 3;

select id
from employees
where position = 'водитель';

select employee_id
from estimates
where estimate_1_quarter in ('D', 'E');

select max(salary_level)
from employees;


select department_name
from department
where number_employees = (select max(number_employees) from department);


select concat(last_name, ' ', first_name, ' ', participant) fullname
from employees
order by current_date - start_work desc;


select grade, round(sum(salary_level) / count(1), 2) mean_salary
from employees
group by grade;



CREATE FUNCTION estiminate_cff(elem varchar) RETURNS integer AS
$$
BEGIN
    if (elem = 'A') then
        return 20;
    elseif (elem = 'B') then
        return 10;
    elseif (elem = 'C') then
        return 0;
    elseif (elem = 'D') then
        return -10;
    elseif (elem = 'E') then
        return -20;
    end if;
END;
$$ LANGUAGE plpgsql;

alter table estimates
    add column coefficient decimal;

update estimates t
set coefficient = t1.corr
from (select employee_id,
       (100 + (estiminate_cff(estimate_1_quarter) +
               estiminate_cff(estimate_2_quarter) +
               estiminate_cff(estimate_3_quarter) +
               estiminate_cff(estimate_4_quarter)))::numeric /
       100 as corr
from estimates) as t1
where t1.employee_id = t.employee_id;