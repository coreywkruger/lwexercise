delimiter //

-- get salary records within a given year & quarter
drop procedure if exists get_salaries_in_quarter;
create procedure get_salaries_in_quarter(IN currentYear varchar(16), IN currentQuarter int)
begin

    declare start date;
    declare end date;
    declare fullDate date;

    set fullDate = concat(currentYear, '-01-01');
    set start = date_add(fullDate, INTERVAL currentQuarter - 1 QUARTER);
    set end = date_sub(date_add(fullDate, INTERVAL currentQuarter QUARTER), INTERVAL 1 DAY);

    create temporary table if not exists salary_ranges (
        emp_no int,
        year int,
        quarter int,
        salary_paid decimal(65, 2)
    );
    
    insert into salary_ranges (emp_no, year, quarter, salary_paid) select emp_no, currentYear as year, (currentQuarter + 1) as quarter,
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

    from salaries as s where datediff(to_date, start) > 0 and datediff(end, from_date) > 0;
end; //

drop procedure if exists range_over_dates;
create procedure range_over_dates()
begin
    declare oldest int;
    declare yearRange int;
    declare increment int default 0;
    -- declare quarterIncrement int default 0;

    set oldest = (select YEAR(from_date) from salaries where YEAR(from_date) <= YEAR(CURDATE()) order by from_date asc limit 1);
    set yearRange = (select (select YEAR(to_date) from salaries where YEAR(to_date) <= YEAR(CURDATE()) order by to_date desc limit 1) - oldest);
    
    create temporary table if not exists salary_sums (
        year int,
        quarter int,
        empo_no int ,
        salary_paid decimal(65, 2)
    );

    while increment <= yearRange do
        set @start = oldest + increment;
        set @end = date_add(@start, INTERVAL 1 YEAR);
        set @quarterIncrement = 0;

        while @quarterIncrement < 4 do
            call get_salaries_in_quarter(@start, @quarterIncrement);
            set @quarterIncrement = @quarterIncrement + 1;
        end while;
        
        set increment = increment + 1;
    end while;

    insert into salary_sums (year, quarter, empo_no, salary_paid) 
        select sa.year as year, sa.quarter as quarter, sa.emp_no as emp_no, sum(sa.salary_paid) as salary_paid from salary_ranges as sa group by emp_no, year, quarter;

end; // 

call range_over_dates();
-- call range_over_dates();