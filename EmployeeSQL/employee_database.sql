-- Create departments table and view column datatypes
CREATE TABLE departments(
	dept_no string
	dept_name VARCHAR
);

-- Create dept_emp table and view column datatypes
CREATE TABLE dept_emp(
	emp_no int
	dept_no string
);

-- Create dept_manager table and view column datatypes
CREATE TABLE dept_manager(
	dept_no string
	emp_no int
);

-- Create employees table and view column datatypes
CREATE TABLE employees(
	emp_no int
	emp_title_id string
	birth_date
	first_name VARCHAR
	last_name VARCHAR
	sex 
	hire_date 
);

-- Create salaries table and view column datatypes
CREATE TABLE salaries(
	emp_no int
	salary int
);

-- Create titles table and view column datatypes
CREATE TABLE titles(
	title_id string
	title VARCHAR
);