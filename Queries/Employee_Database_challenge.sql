-- Drop all tables
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS dept_manager CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;
DROP TABLE IF EXISTS dept_emp CASCADE;
DROP TABLE IF EXISTS titles CASCADE;

-- Creating tables for PH-EmployeeDB

-- note the difference b/w a column constraint & a table constraint

CREATE TABLE departments (
	 dept_no VARCHAR(5) NOT NULL,
	 dept_name VARCHAR(50) NOT NULL,
	 PRIMARY KEY(dept_no),
	 UNIQUE(dept_name)
);

SELECT * FROM departments;

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);
SELECT * FROM employees;

-- Primary keys must contain UNIQUE values, and cannot contain NULL values
-- A table can only have ONE primary key; and in the table, this primary
-- key can consist of single or multiple columns (fields)

CREATE TABLE dept_manager (
dept_no VARCHAR(5) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager;

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  PRIMARY KEY (emp_no, salary, from_date),
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM salaries;

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR(5) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  PRIMARY KEY (emp_no, dept_no)
);

-- To add a foreign key after the fact:
-- ALTER TABLE table_name
-- ADD FOREIGN KEY (dept_no) REFERENCES departments(dept_no);


SELECT * FROM dept_emp;

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM titles;

-- Deliverable 1: The Number of Retiring Employees by Title
-- Retrieve the emp_no, first_name, and last_name columns from the employees table
SELECT emp_no, first_name, last_name
FROM employees;
-- Retrieve the title, from_date, and to_date columns from the titles table
SELECT title, from_date, to_date
FROM titles;

-- Create a new table using the INTO clause [retirement_titles]
-- Join both tables on the primary key
-- Filter the data on the birth_date column to retrieve the employees
-- who were born b/w 1952 and 1955, then order by emp_no

SELECT e.emp_no, e.first_name, e.last_name, e.birth_date, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS e
JOIN titles as ti ON
e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date;

SELECT * FROM retirement_titles;

-- Use DISTINCT w/ ORDER BY to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date ='9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

SELECT * FROM unique_titles;

-- Retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(emp_no) as count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles
