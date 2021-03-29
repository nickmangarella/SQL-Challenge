# sql-employee-database

### Description
First, create an Entity Relationship Diagram from a collection of csvs of a company's employee data. From there use PostgreSQL to create an employee database table and run some queries. Then connect to that database with SQLAlchemy's create_engine() function and plot employee salary data with Pandas, and MatPlotLib.

### employee_db_erd
![alt text](https://github.com/nickmangarella/sql-employee-database/blob/master/EmployeeSQL/employee_db_erd.png)

### employee_db
```
CREATE TABLE "departments" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "dept_name" VARCHAR(50)   ,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(50)   ,
    "birth_date" DATE   ,
    "first_name" VARCHAR(50)   ,
    "last_name" VARCHAR(50)   ,
    "sex" VARCHAR(50)   ,
    "hire_date" DATE   ,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   ,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(50)   NOT NULL,
    "title" VARCHAR(50)   ,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
```
### employee_queries
* Employee details
```
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	e.sex,
	s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;
```

* Employees hired in 1986
```
SELECT first_name,
	last_name,
	hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY hire_date;
```

* Department managers
```
SELECT d.dept_no,
	d.dept_name,
	dm.emp_no,
	e.last_name,
	e.first_name
FROM departments d
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN employees e ON dm.emp_no = e.emp_no;
```

* Department employees
```
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no;
```

* Employees named 'Hercules B'
```
SELECT first_name,
	last_name,
	sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';
```

* Sales department employees
```
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';
```

* Sales and development departments employees
```
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';
```

* Frequency count of employee last names
```
SELECT last_name, COUNT(*)
FROM employees
GROUP BY last_name
ORDER BY 2 DESC;
```

### Employee Salary Plots
* Employee Salary Distribution
```
# Create engine and connect
engine = create_engine(f'postgresql://{username}:{password}@localhost:5432/SQL_Challenge')
conn = engine.connect()

# Query records in salaries table
salaries = pd.read_sql("SELECT * FROM salaries", conn)

# Plot histogram of salaries
plt.hist(salaries["salary"], density=True, bins=7)
plt.xlabel("Salaries")
plt.ylabel("Frequency")
plt.title("Employee Salaries Distribution")

plt.show()
```

* Employee Salary by Title
```
# Create engine and connect
engine = create_engine(f'postgresql://{username}:{password}@localhost:5432/SQL_Challenge')
conn = engine.connect()

# Query records in titles table
titles = pd.read_sql("SELECT * FROM titles", conn)

# Groupby title averages and drop emp_no column
title_avg_salary = employees_salaries_titles.groupby("title").mean()
salary_by_title = title_avg_salary.drop(columns=['emp_no'])

# Plot bar chart of employee salaries by title
salary_by_title.iloc[::1].plot.bar(title="Employee Salaries by Title")
```
