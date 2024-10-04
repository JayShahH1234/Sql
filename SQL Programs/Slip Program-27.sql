-- Create Department Table
CREATE TABLE Department27 (
    deptno INT PRIMARY KEY,
    deptname VARCHAR(100),
    location VARCHAR(100)
);

-- Create Employee Table
CREATE TABLE Employee27 (
    empno INT PRIMARY KEY,
    empname VARCHAR(100),
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    designation VARCHAR(50),
    deptno INT,
    CONSTRAINT fk_dept FOREIGN KEY (deptno) REFERENCES Department27(deptno)
);

-- Insert Sample Data into Department Table
INSERT INTO Department27 (deptno, deptname, location) VALUES (1, 'Computer', 'Building A');
INSERT INTO Department27 (deptno, deptname, location) VALUES (2, 'HR', 'Building B');
INSERT INTO Department27 (deptno, deptname, location) VALUES (3, 'Finance', 'Building C');

-- Insert Sample Data into Employee Table
INSERT INTO Employee27 (empno, empname, salary, commission, designation, deptno) 
VALUES (101, 'Alice', 50000, 2000, 'Software Engineer', 1);

INSERT INTO Employee27 (empno, empname, salary, commission, designation, deptno) 
VALUES (102, 'Bob', 55000, 2500, 'Senior Developer', 1);

INSERT INTO Employee27 (empno, empname, salary, commission, designation, deptno) 
VALUES (103, 'Charlie', 45000, 1500, 'HR Manager', 2);

INSERT INTO Employee27 (empno, empname, salary, commission, designation, deptno) 
VALUES (104, 'David', 48000, 1800, 'Financial Analyst', 3);

-- Create PL/SQL Function to Count Employees in the 'Computer' Department
CREATE OR REPLACE FUNCTION get_emp_count
RETURN NUMBER
IS
    emp_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO emp_count
    FROM Employee27 E
    JOIN Department27 D ON E.deptno = D.deptno
    WHERE D.deptname = 'Computer';
    
    RETURN emp_count;
END;
/

-- Example: Call the function to get the number of employees in the 'Computer' department
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total employees in Computer Department: ' || get_emp_count);
END;
/

-- Create Trigger to Restrict Salary Update
CREATE OR REPLACE TRIGGER salcheck
BEFORE UPDATE OF salary ON Employee27
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'New salary must not be less than the old salary.');
    END IF;
END;
/

-- Example: Try to update salary to see the trigger in action
-- This will succeed
UPDATE Employee27 SET salary = 60000 WHERE empno = 101;

-- This will fail because the new salary is less than the old salary
-- UPDATE Employee27 SET salary = 40000 WHERE empno = 101;
