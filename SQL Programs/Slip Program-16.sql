-- Creating the Customer table
CREATE TABLE Customer (
    cno NUMBER PRIMARY KEY,      -- Customer Number as Primary Key
    cname VARCHAR2(50),          -- Customer Name
    city VARCHAR2(50)            -- City
);

-- Creating the Account table
CREATE TABLE Account (
    ano NUMBER PRIMARY KEY,      -- Account Number as Primary Key
    acc_type VARCHAR2(20) NOT NULL, -- Account Type (cannot be null)
    balance NUMBER,              -- Account Balance
    cno NUMBER,                  -- Foreign Key for Customer (1:M relationship)
    CONSTRAINT fk_customer FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Inserting sample data into Customer table
INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'Mumbai');
INSERT INTO Customer (cno, cname, city) VALUES (3, 'Alice Walker', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (4, 'Bob Johnson', 'Delhi');

-- Inserting sample data into Account table
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (101, 'Saving', 25000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (102, 'Current', 10000, 2);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (103, 'Saving', 30000, 3);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (104, 'Saving', 15000, 4);

-- a) Cursor to display details of all customers from ‘Pune’ city 
-- having A/C balance between 20000 and 40000.

DECLARE
    -- Declare variables to hold data fetched from the cursor
    v_cno Customer.cno%TYPE;
    v_cname Customer.cname%TYPE;
    v_city Customer.city%TYPE;
    v_balance Account.balance%TYPE;
    
    -- Declare the cursor to select customers from Pune with balance between 20k and 40k
    CURSOR pune_customers_cursor IS
    SELECT c.cno, c.cname, c.city, a.balance
    FROM Customer c
    JOIN Account a ON c.cno = a.cno
    WHERE c.city = 'Pune' AND a.balance BETWEEN 20000 AND 40000;
    
BEGIN
    -- Open the cursor and fetch the data
    OPEN pune_customers_cursor;
    LOOP
        FETCH pune_customers_cursor INTO v_cno, v_cname, v_city, v_balance;
        EXIT WHEN pune_customers_cursor%NOTFOUND;
        -- Display the fetched records
        DBMS_OUTPUT.PUT_LINE('Customer No: ' || v_cno || ', Name: ' || v_cname || ', City: ' || v_city || ', Balance: ' || v_balance);
    END LOOP;
    CLOSE pune_customers_cursor;
END;
/
-- b) Create or Replace a PL/SQL function to return the total number 
-- of customers having 'Saving' account.

CREATE OR REPLACE FUNCTION get_total_saving_customers RETURN NUMBER IS
    v_total_saving_customers NUMBER;
BEGIN
    -- Query to count the number of customers with 'Saving' account
    SELECT COUNT(DISTINCT cno)
    INTO v_total_saving_customers
    FROM Account
    WHERE acc_type = 'Saving';
    
    -- Return the total count
    RETURN v_total_saving_customers;
END;
/

-- Example to call the function
DECLARE
    total_saving_customers NUMBER;
BEGIN
    -- Calling the function and displaying the result
    total_saving_customers := get_total_saving_customers;
    DBMS_OUTPUT.PUT_LINE('Total number of customers with Saving accounts: ' || total_saving_customers);
END;
/
