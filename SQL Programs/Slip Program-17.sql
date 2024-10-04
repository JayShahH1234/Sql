-- Create Customer and Loan tables
CREATE TABLE Customer (
  cno NUMBER PRIMARY KEY,
  cname VARCHAR2(100),
  city VARCHAR2(50)
);

CREATE TABLE Loan (
  lno NUMBER PRIMARY KEY,
  loan_amt NUMBER CHECK (loan_amt > 0),
  no_of_years NUMBER,
  cno NUMBER,
  FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Insert data into Customer table
INSERT INTO Customer (cno, cname, city) 
VALUES (1, 'John Doe', 'Mumbai');

INSERT INTO Customer (cno, cname, city) 
VALUES (2, 'Jane Smith', 'Delhi');

INSERT INTO Customer (cno, cname, city) 
VALUES (3, 'Alice Brown', 'Mumbai');

-- Insert data into Loan table
INSERT INTO Loan (lno, loan_amt, no_of_years, cno) 
VALUES (101, 50000, 5, 1);

INSERT INTO Loan (lno, loan_amt, no_of_years, cno) 
VALUES (102, 30000, 2, 2);

INSERT INTO Loan (lno, loan_amt, no_of_years, cno) 
VALUES (103, 70000, 4, 3);

-- Create PL/SQL function to find total loan amount from Mumbai city
CREATE OR REPLACE FUNCTION total_loan_amount_mumbai
RETURN NUMBER
IS
  total_amount NUMBER := 0;
BEGIN
  SELECT SUM(l.loan_amt)
  INTO total_amount
  FROM Customer c
  JOIN Loan l ON c.cno = l.cno
  WHERE c.city = 'Mumbai';

  RETURN total_amount;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

-- PL/SQL block using cursor to display customers with loans for more than 3 years
DECLARE
  CURSOR customer_cursor IS
    SELECT c.cno, c.cname, c.city, l.loan_amt, l.no_of_years
    FROM Customer c
    JOIN Loan l ON c.cno = l.cno
    WHERE l.no_of_years > 3;

  customer_record customer_cursor%ROWTYPE;
BEGIN
  OPEN customer_cursor;

  LOOP
    FETCH customer_cursor INTO customer_record;
    EXIT WHEN customer_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Customer No: ' || customer_record.cno ||', Name: ' || customer_record.cname ||  ', City: ' || customer_record.city 
    ||  ', Loan Amount: ' || customer_record.loan_amt ||                      ', Loan Duration: ' || customer_record.no_of_years);
  END LOOP;

  CLOSE customer_cursor;
END;
/
