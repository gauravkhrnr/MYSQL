/* Simple procedure with local*/
delimiter $$
create procedure MyProcedureLocalVariables()
begin
Declare a int default 10;
Declare b,c int;
set a = a + 100;
set b = 2;
set c = a + b;
begin
declare c int;
set c = 5;
select a,b,c;
end;
select a,b,c;
end$$
/* Call the procedure */
call MyProcedureLocalVariables();

/* user variable */
deleimiter $$
create procedure MyProcedureUserVariables()
begin
set @x = 5;
set @y = 2;
select @x,@y,@x-@y;
end$$
call MyProcedureUserVariables();

/*Find second highest salary by in parameter*/
delimiter $$
create procedure SecondHighestSalaray(in var int)
begin
	select max_salary 
	from jobs
	where max_salary < 
	(
		select max(max_salary) from jobs
	) limit var;
end;
call SecondHighestSalaray(1);$$

/*find max salary by out parameter*/
delimiter $$
create procedure GetMaxSalary(out heighest_salary int)
begin 
	select max(max_salary) into heighest_salary
    from jobs;
end;$$
call GetMaxSalary(@salary);
select @salary; 

/*Find count of employees in the same department by inout parameter*/
delimiter $$
create procedure GetEmpCountInDept(inout no_of_employee int,in dept_id int)
begin
	select count(*) into no_of_employee 
    from employees
    where DEPARTMENT_ID = dept_id;
end;$$
call GetEmpCountInDept(@count,'50');
select @count;

/*Procedure with if else condition*/
delimiter $$
create procedure GetUserName(inout emp_name varchar(16),in emp_id int)
begin
	DECLARE uname varchar(16);
	select FIRST_NAME into uname 
	from employees
	where employee_id = emp_id;
	if emp_id = 100	
	then 
		set emp_name = 'Steven King';  
	elseif emp_id = 103
	then 
		set emp_name = 'Lex';
	else
		set emp_id = 'no name found';
    end if;    
end;$$

call GetUserName(@name,103);
select @name;


DELIMITER $$
CREATE PROCEDURE `hr`.`CaseProcedure` (INOUT no_employees INT, IN salary INT)
BEGIN
	CASE
	WHEN (salary > 10000) 
	THEN 
		(   SELECT COUNT(job_id) INTO no_employees 
			FROM jobs 
			WHERE min_salary > 10000
		);
	WHEN (salary < 10000) 
	THEN 
		(
			SELECT COUNT(job_id) INTO no_employees 
			FROM jobs 
			WHERE min_salary < 10000
		);
	ELSE 
		(
			SELECT COUNT(job_id) INTO no_employees 
			FROM jobs WHERE min_salary = 10000
		);
	END CASE;
END$$

call CaseProcedure(@count,1000);
select @count

/*loop example*/
create table number(val double);
DELIMITER $$
CREATE PROCEDURE `LoopProcedure` (IN num INT)
BEGIN
	DECLARE x INT;
	SET x = 0;
	loop_label: LOOP
		INSERT INTO number VALUES (rand());
		SET x = x + 1;
		IF x >= num 
		THEN
			LEAVE loop_label;
		END IF;
	END LOOP;
END$$
call LoopProcedure(10);
select * from number;

/* Repeate Statement */
delimiter $$
create procedure RepeateProcedure(in n int)
begin
	set @sum = 0;
	set @x = 1;
    repeat 
		if mod(@x,2) = 0
		then
			set @sum = @sum + @x;
		end if;
		set @x = @x + 1;
		until n < @x
    end repeat;
end;$$
call RepeateProcedure(5);
select @sum;

/*Do while loop*/
delimiter $$
create procedure DoWhileLoopprocedure(in n int)
begin	
	set @sum = 0; 
	set @x = 1;
    while @x < n
    do
		if mod(@x,2) = 0
        then 
			set @sum = @sum + @x;
		end if;
		set @x = @x + 1;
    end while;    
end;$$
call DoWhileLoopprocedure(5);
select @sum;

/*Cursor example*/
delimiter $$
create procedure CursorProcedure(INOUT return_val INT)
begin
	declare a,b int;
    declare cur_1 cursor for
    select max_salary from jobs;
    declare continue handler for not found set b = 1;
    open cur_1;
		repeat
			fetch cur_1 into a;
            until b = 1
        end repeat;
    close cur_1;    
    set return_val = a;
end;$$
call CursorProcedure(@salary);
select @salary;