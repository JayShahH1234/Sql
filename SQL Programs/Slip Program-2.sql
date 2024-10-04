-- Create Customer table
CREATE TABLE Customer (
    cno NUMBER PRIMARY KEY,
    cname VARCHAR2(100),
    city VARCHAR2(100)
);

-- Create Account table (1:M relationship with Customer)
CREATE TABLE Account (
    ano NUMBER PRIMARY KEY,
    acc_type VARCHAR2(50) NOT NULL, -- Account type should not be null
    balance NUMBER,
    cno NUMBER,  -- Foreign key
    FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Insert sample data into Customer table
INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'New York');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'San Francisco');

-- Insert sample data into Account table
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (101, 'Savings', 5000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (102, 'Checking', 3000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (103, 'Savings', 7000, 2);

-- a) PL/SQL function to return account balance of a given customer
CREATE OR REPLACE FUNCTION get_account_balance (p_cno IN NUMBER) RETURN NUMBER IS
    v_total_balance NUMBER := 0;
BEGIN
    -- Summing up the balance for the given customer
    SELECT SUM(balance)
    INTO v_total_balance
    FROM Account
    WHERE cno = p_cno;

    RETURN v_total_balance;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- b) Trigger to restrict updating Employee salary where new salary should not be less than old salary
CREATE TABLE Employee (
    empno NUMBER PRIMARY KEY,
    empname VARCHAR2(100),
    salary NUMBER
);

-- Insert sample data into Employee table
INSERT INTO Employee (empno, empname, salary) VALUES (1, 'John Doe', 5000);
INSERT INTO Employee (empno, empname, salary) VALUES (2, 'Jane Smith', 6000);

-- Create trigger to ensure new salary is not less than old salary
CREATE OR REPLACE TRIGGER salary_check
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20002, 'New salary cannot be less than the old salary.');
    END IF;
END;
/
