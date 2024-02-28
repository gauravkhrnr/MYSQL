-- Query using Joins

-- find the addresses (location_id, street_address, city, state_province, country_name) of all the departments.
select location_id, street_address, city, state_province,c.country_name 
from locations 
natural join countries;

-- Write a query to find the name (first_name, last_name), job, department ID and name of the employees 
-- who works in London.
select first_name, last_name, e.department_id
from employees e join departments d
on e.department_id = d.DEPARTMENT_ID
join locations l
using(location_id)
where l.city = 'London';

-- Write a query to find the employee id, name (last_name) along with their manager_id and name (last_name).
select emp.EMPLOYEE_ID,emp.FIRST_NAME,emp.LAST_NAME,d.manager_id from 
(   select e.EMPLOYEE_ID,e.FIRST_NAME,e.LAST_NAME,e.DEPARTMENT_ID
	from employees e 	
    join employees m
    on e.EMPLOYEE_ID = m.manager_id
) emp
join departments d
on d.DEPARTMENT_ID = emp.DEPARTMENT_ID;

-- Write a query to find the name (first_name, last_name) and hire date of the employees who was hired after 'Jones'.
select e.FIRST_NAME,e.LAST_NAME,davis.HIRE_DATE
from employees e 
join employees davis
on davis.LAST_NAME = 'Jones'
where davis.HIRE_DATE < e.HIRE_DATE;
select * from employees where last_name='Jones';

-- Write a query to get the department name and number of employees in the department
select d.DEPARTMENT_NAME,count(*) as 'number of employee'
from employees e
join departments d
on e.DEPARTMENT_ID = d.DEPARTMENT_ID
group by d.DEPARTMENT_ID
order by DEPARTMENT_NAME;

-- Write a query to find the employee ID, job title, number of days between ending date and starting date 
-- for all jobs in department 90.
select employee_id, job_title,(END_DATE - START_DATE) as 'no of days'
from job_history 
natural join jobs
where DEPARTMENT_ID =90;

-- Write a query to display the department ID and name and first name of manager.
SELECT d.department_id, d.department_name, d.manager_id, e.first_name
from departments d
join employees e
on d.MANAGER_ID = e.employee_id;

-- Write a query to display the department name, manager name, and city.
SELECT d.department_name, d.manager_id, e.first_name,l.CITY
from employees e
join departments d
on d.MANAGER_ID = e.employee_id
join locations l
on d.LOCATION_ID = l.LOCATION_ID;

-- Write a query to display the job title and average salary of employees.
select job_title,avg(SALARY) 
from employees
natural join jobs
group by job_title;

-- Write a query to display job title, employee name, and the difference between salary of the employee 
-- and minimum salary for the job. 
select FIRST_NAME,(SALARY - MIN_SALARY) as 'Salary Diff'
from employees
natural join jobs;

-- Write a query to display the job history that were done by any employee who is currently drawing more than 
-- 10000 of salary.
select jh.*
from employees e
join job_history jh
on e.EMPLOYEE_ID = jh.EMPLOYEE_ID
where SALARY > 10000;

-- Write a query to display department name, name (first_name, last_name), hire date, salary of the manager 
-- for all managers whose experience is more than 15 years.
select * from (
	select d.DEPARTMENT_NAME,e.first_name,e.LAST_NAME,HIRE_DATE,(DATEDIFF(now(), hire_date)) / 365 as 'experience'
	from employees e
	join departments d
	on e.EMPLOYEE_ID = d.MANAGER_ID 
) as emp
where emp.experience > 15;
 







