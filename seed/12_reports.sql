use employees;

delimiter //

drop procedure if exists get_salaries_in_range;

-- get salary paid per employee for the given date range

create procedure get_salaries_in_range(start date, end date, dept varchar(4))
begin

    drop temporary table if exists salary_ranges;
    create temporary table salary_ranges (
        emp_no int,
        year int,
        dept_no varchar(4),
        dept_name varchar(40),
        salary_paid decimal(65, 2)
    );
    
    insert into salary_ranges (emp_no, year, dept_no, dept_name, salary_paid) 
    select s.emp_no, year(start) as year, de.dept_no as dept_no, d.dept_name as dept_name,
    case
        when 
            datediff(start, s.from_date) > 0 and datediff(s.to_date, start) > 0 
            then round(s.salary * datediff(s.to_date, start) / 365, 2)
        when 
            datediff(end, s.from_date) > 0 and datediff(s.to_date, end) > 0 
            then round(s.salary * datediff(end, s.from_date) / 365, 2)
        when
            datediff(start, s.from_date) > 0 and datediff(s.to_date, end) > 0
            then round(s.salary * datediff(end, start) / 365, 2)
        when 
            datediff(s.from_date, start) > 0 and datediff(end, s.to_date) > 0 
            then round(s.salary * datediff(s.to_date, s.from_date) / 365, 2)
        else null
    end as salary_paid 
    from salaries as s 
        inner join dept_emp as de
            on 
                datediff(s.to_date, start) > 0 and 
                datediff(end, s.from_date) > 0 and
                s.emp_no = de.emp_no and
                de.dept_no = dept
        inner join departments as d
            on 
                de.dept_no = d.dept_no;
end; //

drop procedure if exists get_salary_sums;

-- get a sum of salary paid by a department within a given year & quarter like so:

-- call get_salary_sums(2000, 1, 'd005');
-- +------+---------+---------+---------------+
-- | year | quarter | dept_no | salary_paid   |
-- +------+---------+---------+---------------+
-- | 2000 |       1 | d005    | 2849582066.89 |
-- +------+---------+---------+---------------+

create procedure get_salary_sums(year int, quarter int, dept varchar(4))
begin

    set @startDate = date_add(concat(year, '-01-01'), INTERVAL quarter - 1 QUARTER);
    set @endDate = date_sub(date_add(@startDate, INTERVAL quarter QUARTER), INTERVAL 1 DAY);

    call get_salaries_in_range(@startDate, @endDate, dept);

    select year, quarter, sr.dept_no as dept_no, sr.dept_name as dept_name, sum(sr.salary_paid) as salary_paid 
    from salary_ranges as sr
    group by dept_no, dept_name;
end; // 