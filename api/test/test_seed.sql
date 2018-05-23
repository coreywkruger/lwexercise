insert into departments 
        (dept_no, dept_name) 
    values 
        ('taco', 'shrimp');

insert into employees 
        (emp_no, birth_date, first_name, last_name, gender, hire_date) 
    values 
        (1, '1977-06-14)', 'John', 'Doe', 'M', '1985-06-14)'),
        (2, '1977-06-14)', 'Jane', 'Doe', 'F', '1985-06-14)'),
        (3, '1977-06-14)', 'Joe', 'Shmoe', 'M', '1985-06-14)');

insert into dept_emp 
        (dept_no, emp_no, from_date, to_date)
    values
        ('taco', 1, '1985-01-01', '2000-01-01'),
        ('taco', 2, '1985-01-01', '2000-01-01'),
        ('taco', 3, '1985-01-01', '2000-01-01');

insert into salaries
        (emp_no, salary, from_date, to_date)
    values
        (1, 12, '1985-01-01', '1990-01-01'),
        (2, 12, '1985-01-01', '1990-01-01'),
        (3, 12, '1985-01-01', '1990-01-01');