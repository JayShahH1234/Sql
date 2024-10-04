-- Creating the Customer table
CREATE TABLE Customer (
    cno NUMBER PRIMARY KEY,       -- Customer Number as Primary Key
    cname VARCHAR2(50),           -- Customer Name
    city VARCHAR2(50)             -- City
);

-- Creating the Account table
CREATE TABLE Account (
    ano NUMBER PRIMARY KEY,       -- Account Number as Primary Key
    acc_type VARCHAR2(20) NOT NULL, -- Account Type (should not be null)
    balance NUMBER CHECK (balance >= 0), -- Account Balance (should be non-negative)
    cno NUMBER,                   -- Foreign Key for Customer (1:M relationship)
    CONSTRAINT fk_customer FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Inserting sample data into Customer table
INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'Mumbai');
INSERT INTO Customer (cno, cname, city) VALUES (3, 'Alice Walker', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (4, 'Bob Johnson', 'Delhi');

-- Inserting sample data into Account table
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (101, 'Saving', 30000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (102, 'Current', 25000, 2);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (103, 'Saving', 15000, 3);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (104, 'Current', 5000, 4);

-- 17a. Procedure to transfer withdrawal amount from one account to another
CREATE OR REPLACE PROCEDURE transferAmount (
    from_ano IN NUMBER,     -- Account number to withdraw from
    to_ano IN NUMBER,       -- Account number to transfer to
    amount IN NUMBER        -- Amount to transfer
) IS
    vfrom_balance Account.balance%TYPE;     
    vto_balance Account.balance%TYPE;     
BEGIN    
    SELECT balance INTO vfrom_balance FROM Account WHERE ano = from_ano;     
    SELECT balance INTO vto_balance FROM Account WHERE ano = to_ano;     

    -- Check if the from account has sufficient balance    
    IF vfrom_balance >= amount THEN         
        UPDATE Account SET balance = balance - amount WHERE ano = from_ano;         
        UPDATE Account SET balance = balance + amount WHERE ano = to_ano;         
        
        dbms_output.put_line('Transfer successful.');         
        dbms_output.put_line('New balance of account ' || from_ano || ': ' || (vfrom_balance - amount));         
        dbms_output.put_line('New balance of account ' || to_ano || ': ' || (vto_balance + amount));     
    ELSE         
        dbms_output.put_line('Insufficient balance in account ' || from_ano);     
    END IF; 
END; 
/

-- Example of executing the transferAmount procedure
BEGIN
    transferAmount(101, 102, 5000);  -- Transfer 5000 from account 101 to account 102
END;
/

-- 17b. Cursor to list all customers & their account details
DECLARE     
    CURSOR cust_cursor IS         
        SELECT c.cno, c.cname, c.city, a.ano, a.acc_type, a.balance 
        FROM Customer c           
        JOIN Account a ON c.cno = a.cno 
        ORDER BY c.cno;     

    v_cno Customer.cno%TYPE;    
    v_cname Customer.cname%TYPE;     
    v_city Customer.city%TYPE;     
    v_ano Account.ano%TYPE;     
    v_atype Account.acc_type%TYPE;     
    v_bal Account.balance%TYPE; 
BEGIN     
    OPEN cust_cursor;     
    LOOP         
        FETCH cust_cursor INTO v_cno, v_cname, v_city, v_ano, v_atype, v_bal;         
        EXIT WHEN cust_cursor%NOTFOUND;         
        
        dbms_output.put_line('Customer: ' || v_cname || ' (CNO: ' || v_cno || ')');         
        dbms_output.put_line('  Account No: ' || v_ano || ', Type: ' || v_atype || ', Balance: ' || v_bal);     
    END LOOP;     
    CLOSE cust_cursor; 
END; 
/
