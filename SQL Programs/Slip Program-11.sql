-- Create Department table
CREATE TABLE
  Department (
    deptno NUMBER(5) PRIMARY KEY,
    deptname VARCHAR2(50),
    location VARCHAR2(50)
  );

-- Create Employee table with a foreign key relationship to Department
CREATE TABLE
  Employee (
    empno NUMBER(5) PRIMARY KEY,
    empname VARCHAR2(50),
    salary NUMBER(10, 2),
    commission NUMBER(10, 2),
    desig VARCHAR2(50),
    deptno NUMBER(5),
    CONSTRAINT fk_dept FOREIGN KEY (deptno) REFERENCES Department (deptno)
  );

-- Insert data into Department table
INSERT INTO
  Department (deptno, deptname, location)
VALUES
  (1, 'HR', 'New York');

INSERT INTO
  Department (deptno, deptname, location)
VALUES
  (2, 'Finance', 'San Francisco');

INSERT INTO
  Department (deptno, deptname, location)
VALUES
  (3, 'IT', 'Chicago');

-- Insert data into Employee table
INSERT INTO
  Employee (empno, empname, salary, commission, desig, deptno)
VALUES
  (101, 'John Doe', 50000, 500, 'Manager', 1);

INSERT INTO
  Employee (empno, empname, salary, commission, desig, deptno)
VALUES
  (102, 'Jane Smith', 60000, 800, 'Analyst', 2);

INSERT INTO
  Employee (empno, empname, salary, commission, desig, deptno)
VALUES
  (103, 'Michael Brown', 70000, 1000, 'Developer', 3);

-- Commit the data
COMMIT;

-- Procedure to increase salary by 5% for a given employee and display updated salary
CREATE
OR REPLACE PROCEDURE Increase_Salary (p_empno IN NUMBER) IS v_salary Employee.salary % TYPE;

BEGIN
-- Update the salary by 5%
UPDATE Employee
SET
  salary = salary * 1.05
WHERE
  empno = p_empno;

-- Get the updated salary
SELECT
  salary INTO v_salary
FROM
  Employee
WHERE
  empno = p_empno;

-- Display the updated salary
DBMS_OUTPUT.PUT_LINE (
  'The updated salary for employee ' || p_empno || ' is: ' || v_salary
);

-- Commit the transaction
COMMIT;

END Increase_Salary;

/
-- Cursor to display details of Employees of all departments
DECLARE CURSOR emp_cursor IS
SELECT
  e.empno,
  e.empname,
  e.salary,
  e.commission,
  e.desig,
  d.deptname,
  d.location
FROM
  Employee e
  INNER JOIN Department d ON e.deptno = d.deptno;

v_empno Employee.empno % TYPE;

v_empname Employee.empname % TYPE;

v_salary Employee.salary % TYPE;

v_commission Employee.commission % TYPE;

v_desig Employee.desig % TYPE;

v_deptname Department.deptname % TYPE;

v_location Department.location % TYPE;

BEGIN OPEN emp_cursor;

LOOP FETCH emp_cursor INTO v_empno,
v_empname,
v_salary,
v_commission,
v_desig,
v_deptname,
v_location;

EXIT WHEN emp_cursor % NOTFOUND;

-- Display the employee details
DBMS_OUTPUT.PUT_LINE (
  'EmpNo: ' || v_empno || ', Name: ' || v_empname || ', Salary: ' || v_salary || ', Commission: ' || v_commission || ', Designation: ' || v_desig || ', Dept: ' || v_deptname || ', Location: ' || v_location
);

END
LOOP;

CLOSE emp_cursor;

END;

/
-- Test the procedure to increase salary for a specific employee (e.g., employee 101)
BEGIN Increase_Salary (101);

END;

/
-- Execute the block to display all employee details
BEGIN NULL;

-- Call your procedures or logic here if needed
END;

/