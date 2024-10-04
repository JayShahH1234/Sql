CREATE TABLE Department (
    deptno NUMBER PRIMARY KEY,
    deptname VARCHAR2(50),
    location VARCHAR2(50)
);

CREATE TABLE Employee (
    empno NUMBER PRIMARY KEY,
    empname VARCHAR2(50),
    salary NUMBER,
    commission NUMBER,
    desig VARCHAR2(50),
    deptno NUMBER,
    CONSTRAINT fk_dept FOREIGN KEY (deptno) REFERENCES Department(deptno)
);
INSERT INTO Department (deptno, deptname, location)
VALUES (1, 'Human Resources', 'New York');

INSERT INTO Department (deptno, deptname, location)
VALUES (2, 'Finance', 'London');

INSERT INTO Department (deptno, deptname, location)
VALUES (3, 'Engineering', 'San Francisco');
INSERT INTO Employee (empno, empname, salary, commission, desig, deptno)
VALUES (101, 'John Doe', 50000, 5000, 'Manager', 1);

INSERT INTO Employee (empno, empname, salary, commission, desig, deptno)
VALUES (102, 'Jane Smith', 60000, 0, 'Senior Engineer', 3);

INSERT INTO Employee (empno, empname, salary, commission, desig, deptno)
VALUES (103, 'Emily White', 45000, NULL, 'Accountant', 2);

INSERT INTO Employee (empno, empname, salary, commission, desig, deptno)
VALUES (104, 'Michael Brown', 75000, 10000, 'Director', 1);

INSERT INTO Employee (empno, empname, salary, commission, desig, deptno)
VALUES (105, 'Sophia Johnson', 52000, 3000, 'Software Engineer', 3);

CREATE OR REPLACE PROCEDURE get_employee_details(p_empno IN NUMBER) IS
    v_empname Employee.empname%TYPE;
    v_salary Employee.salary%TYPE;
    v_commission Employee.commission%TYPE;
    v_desig Employee.desig%TYPE;
    v_deptno Employee.deptno%TYPE;
    v_deptname Department.deptname%TYPE;
BEGIN
    SELECT empname, salary, commission, desig, deptno
    INTO v_empname, v_salary, v_commission, v_desig, v_deptno
    FROM Employee
    WHERE empno = p_empno;

    SELECT deptname
    INTO v_deptname
    FROM Department
    WHERE deptno = v_deptno;

    DBMS_OUTPUT.PUT_LINE('Employee Details:');
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_empname);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
    DBMS_OUTPUT.PUT_LINE('Commission: ' || NVL(v_commission, 0));
    DBMS_OUTPUT.PUT_LINE('Designation: ' || v_desig);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_deptname);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found with employee number: ' || p_empno);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
DECLARE
    CURSOR emp_cursor IS
        SELECT empname, salary, NVL(commission, 0) AS commission
        FROM Employee;
    v_empname Employee.empname%TYPE;
    v_salary Employee.salary%TYPE;
    v_commission Employee.commission%TYPE;
    v_total_salary NUMBER;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_empname, v_salary, v_commission;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        v_total_salary := v_salary + v_commission;
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_empname || ' - Total Salary: ' || v_total_salary);
    END LOOP;
    CLOSE emp_cursor;
END;
/
