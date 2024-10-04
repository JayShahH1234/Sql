-- Creating the Customer table
CREATE TABLE Customer (
    cno NUMBER PRIMARY KEY,       -- Customer Number as Primary Key
    cname VARCHAR2(50),           -- Customer Name
    city VARCHAR2(50)             -- City
);

-- Creating the Loan table
CREATE TABLE Loan (
    lno NUMBER PRIMARY KEY,       -- Loan Number as Primary Key
    loanamt NUMBER CHECK (loanamt > 0), -- Loan Amount must be greater than 0
    no_of_years NUMBER,           -- Loan Duration (in years)
    cno NUMBER,                   -- Foreign Key for Customer (1:M relationship)
    CONSTRAINT fk_customer FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Inserting sample data into Customer table
INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'Mumbai');
INSERT INTO Customer (cno, cname, city) VALUES (3, 'Alice Walker', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (4, 'Bob Johnson', 'Delhi');

-- Inserting sample data into Loan table
INSERT INTO Loan (lno, loanamt, no_of_years, cno) VALUES (101, 50000, 5, 1);
INSERT INTO Loan (lno, loanamt, no_of_years, cno) VALUES (102, 30000, 3, 2);
INSERT INTO Loan (lno, loanamt, no_of_years, cno) VALUES (103, 75000, 4, 3);
INSERT INTO Loan (lno, loanamt, no_of_years, cno) VALUES (104, 100000, 3, 4);

-- 9a) PL/SQL procedure to display customer details who have taken maximum loan from 'Pune'
CREATE OR REPLACE PROCEDURE display_max_Pune_loan IS 
    v_cno Customer.cno%TYPE; 
    v_cname Customer.cname%TYPE; 
    v_city Customer.city%TYPE; 
    v_max_loanamt Loan.loanamt%TYPE; 
BEGIN 
    SELECT c.cno, c.cname, c.city, l.loanamt 
    INTO v_cno, v_cname, v_city, v_max_loanamt 
    FROM Customer c 
    JOIN Loan l ON c.cno = l.cno 
    WHERE c.city = 'Pune' 
      AND l.loanamt = (SELECT MAX(loanamt) 
       FROM Loan l2                 JOIN Customer c2 ON l2.cno = c2.cno 
   WHERE c2.city = 'Pune'); 

    DBMS_OUTPUT.PUT_LINE('Customer No: ' || v_cno); 
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_cname); 
    DBMS_OUTPUT.PUT_LINE('City: ' || v_city); 
    DBMS_OUTPUT.PUT_LINE('Max Loan Amount: ' || v_max_loanamt); 
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No customer found from Pune city with loan.'); 
END; 
/

-- Execute the Procedure
BEGIN 
    display_max_Pune_loan; 
END; 
/
-- 9b) Trigger to prevent updates to loan amount
CREATE OR REPLACE TRIGGER loan_update_NA 
   BEFORE UPDATE OF loanamt ON Loan 
   FOR EACH ROW 
BEGIN     
    RAISE_APPLICATION_ERROR(-20003, 'Update of loan amount is not allowed.'); 
END; 
/
