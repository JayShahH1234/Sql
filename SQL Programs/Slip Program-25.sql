-- Create Customer Table
CREATE TABLE Customer (
    cno INT PRIMARY KEY,
    cname VARCHAR(100),
    city VARCHAR(100)
);

-- Create Account Table
CREATE TABLE Account (
    ano INT PRIMARY KEY,
    acc_type VARCHAR(50) NOT NULL,  -- acc_type should not be null
    balance DECIMAL(10, 2),         -- balance must be a decimal
    cno INT,
    CONSTRAINT fk_customer FOREIGN KEY (cno) REFERENCES Customer(cno)
);

-- Insert Sample Data into Customer Table
INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'New York');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'Los Angeles');
INSERT INTO Customer (cno, cname, city) VALUES (3, 'Robert Brown', 'Chicago');

-- Insert Sample Data into Account Table
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (101, 'Savings', 500, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (102, 'Checking', 800, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (103, 'Savings', 900, 2);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (104, 'Checking', 700, 3);

-- Create PL/SQL Procedure to Transfer Amount
CREATE OR REPLACE PROCEDURE Transfer_Amount (
    p_from_account IN INT,
    p_to_account IN INT,
    p_withdraw_amount IN DECIMAL
) AS
    v_balance_from DECIMAL(10, 2);
    v_balance_to DECIMAL(10, 2);
BEGIN
    -- Fetch current balances of both accounts
    SELECT balance INTO v_balance_from FROM Account WHERE ano = p_from_account;
    SELECT balance INTO v_balance_to FROM Account WHERE ano = p_to_account;

    -- Check if the withdrawal amount is valid
    IF v_balance_from < p_withdraw_amount THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds in the source account.');
    END IF;

    -- Update balances
    UPDATE Account SET balance = balance - p_withdraw_amount WHERE ano = p_from_account;
    UPDATE Account SET balance = balance + p_withdraw_amount WHERE ano = p_to_account;

    COMMIT;  -- Commit the transaction
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'One or both account numbers do not exist.');
END Transfer_Amount;
/

-- Example: Call the procedure to transfer amount
-- BEGIN
--     Transfer_Amount(101, 102, 100);
-- END;
-- This will transfer $100 from account 101 to account 102

-- Create Trigger to Restrict Balance Less than 100
CREATE OR REPLACE TRIGGER balance_check
BEFORE INSERT OR UPDATE ON Account
FOR EACH ROW
BEGIN
    IF :new.balance < 100 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Account balance cannot be less than 100.');
    END IF;
END;
/

-- Example: Try to insert or update with a balance less than 100
-- This will fail because the balance is less than 100
-- INSERT INTO Account (ano, acc_type, balance, cno) VALUES (105, 'Savings', 50, 1);

-- This will succeed
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (106, 'Checking', 150, 2);

-- Update Example
-- UPDATE Account SET balance = 50 WHERE ano = 101;  -- This will fail because of the trigger
-- UPDATE Account SET balance = 200 WHERE ano = 101;  -- This will succeed
