-- Create Customer table
CREATE TABLE
    Customer (
        cno NUMBER PRIMARY KEY, -- Primary key for Customer
        cname VARCHAR2(50), -- Name of the Customer
        city VARCHAR2(50), -- City of the Customer
    );

-- Create Loan table
CREATE TABLE
    Loan (
        lno NUMBER PRIMARY KEY, -- Primary key for Loan
        loan_amt NUMBER CHECK (loan_amt > 0), -- Loan amount, must be greater than 0
        no_of_years NUMBER, -- Number of years for the loan
        cno NUMBER, -- Foreign key linking to Customer table
        FOREIGN KEY (cno) REFERENCES Customer (cno)
    );

-- Insert data into Customer table
INSERT INTO
    Customer (cno, cname, city)
VALUES
    (1, 'John Doe', 'Mumbai');

-- Customer 1
INSERT INTO
    Customer (cno, cname, city)
VALUES
    (2, 'Jane Smith', 'Pune');

-- Customer 2
INSERT INTO
    Customer (cno, cname, city)
VALUES
    (3, 'Mike Johnson', 'Mumbai');

-- Customer 3
-- Insert data into Loan table
INSERT INTO
    Loan (lno, loan_amt, no_of_years, cno)
VALUES
    (101, 50000, 4, 1);

-- Loan 101 linked to Customer 1
INSERT INTO
    Loan (lno, loan_amt, no_of_years, cno)
VALUES
    (102, 30000, 2, 2);

-- Loan 102 linked to Customer 2
INSERT INTO
    Loan (lno, loan_amt, no_of_years, cno)
VALUES
    (103, 45000, 5, 3);

-- Loan 103 linked to Customer 3
-- a) PL/SQL function to find the total loan amount from 'Mumbai' city
CREATE
OR REPLACE FUNCTION totalLoanAmountMumbai RETURN NUMBER IS v_total_loan NUMBER;

BEGIN
-- Calculate the total loan amount for customers from 'Mumbai'
SELECT
    SUM(l.loan_amt) INTO v_total_loan
FROM
    Loan l
    JOIN Customer c ON l.cno = c.cno
WHERE
    c.city = 'Mumbai';

-- Return the total loan amount
RETURN v_total_loan;

END;

/
-- b) Cursor to display details of all customers who have taken a loan for more than 3 years
DECLARE CURSOR c_CustomersWithLoan IS
SELECT
    c.cno,
    c.cname,
    c.city,
    l.loan_amt,
    l.no_of_years
FROM
    Customer c
    JOIN Loan l ON c.cno = l.cno
WHERE
    l.no_of_years > 3;

v_cno Customer.cno % TYPE;

-- Variable for Customer number
v_cname Customer.cname % TYPE;

-- Variable for Customer name
v_city Customer.city % TYPE;

-- Variable for Customer city
v_loan_amt Loan.loan_amt % TYPE;

-- Variable for Loan amount
v_no_of_years Loan.no_of_years % TYPE;

-- Variable for number of years of the loan
BEGIN OPEN c_CustomersWithLoan;

-- Open the cursor to fetch customer details
DBMS_OUTPUT.PUT_LINE (
    'Displaying customers with loans for more than 3 years:'
);

-- Loop through each record fetched by the cursor
LOOP FETCH c_CustomersWithLoan INTO v_cno,
v_cname,
v_city,
v_loan_amt,
v_no_of_years;

EXIT WHEN c_CustomersWithLoan % NOTFOUND;

-- Exit loop when no more records are found
-- Display customer and loan details
DBMS_OUTPUT.PUT_LINE (
    'Customer No: ' || v_cno || ', Customer Name: ' || v_cname || ', City: ' || v_city || ', Loan Amount: ' || v_loan_amt || ', Loan Years: ' || v_no_of_years
);

END
LOOP;

CLOSE c_CustomersWithLoan;

-- Close the cursor after fetching all records
END;

/