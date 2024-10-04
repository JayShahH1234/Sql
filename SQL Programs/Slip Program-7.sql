CREATE TABLE Customer (
  cno NUMBER PRIMARY KEY,
  cname VARCHAR2(50),
  city VARCHAR2(50)
);

CREATE TABLE Account (
  ano NUMBER PRIMARY KEY,
  acc_type VARCHAR2(20),
  balance NUMBER CHECK (balance > 100),
  cno NUMBER,
  FOREIGN KEY (cno) REFERENCES Customer(cno)
);

INSERT INTO Customer (cno, cname, city) VALUES (1, 'John Doe', 'Pune');
INSERT INTO Customer (cno, cname, city) VALUES (2, 'Jane Smith', 'Mumbai');
INSERT INTO Customer (cno, cname, city) VALUES (3, 'Mike Ross', 'Pune');

INSERT INTO Account (ano, acc_type, balance, cno) VALUES (101, 'Savings', 12000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (102, 'Current', 5000, 1);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (103, 'Savings', 15000, 2);
INSERT INTO Account (ano, acc_type, balance, cno) VALUES (104, 'Savings', 3000, 3);

-- a) PL/SQL procedure to find total balance of all customers of 'Pune' city
CREATE OR REPLACE PROCEDURE getTotalBalancePune
IS
  v_total_balance NUMBER;
BEGIN
  SELECT SUM(a.balance)
  INTO v_total_balance
  FROM Account a
  JOIN Customer c ON a.cno = c.cno
  WHERE c.city = 'Pune';
  
  DBMS_OUTPUT.PUT_LINE('Total Balance of Pune Customers: ' || v_total_balance);
END;
/

-- b) Cursor to add interest of 3% to the balance of all accounts whose balance is greater than 10000
DECLARE
  CURSOR c_Account IS
    SELECT ano, balance
    FROM Account
    WHERE balance > 10000;
  v_ano Account.ano%TYPE;
  v_balance Account.balance%TYPE;
BEGIN
  OPEN c_Account;
  LOOP
    FETCH c_Account INTO v_ano, v_balance;
    EXIT WHEN c_Account%NOTFOUND;
    
    v_balance := v_balance + (v_balance * 0.03);
    
    UPDATE Account
    SET balance = v_balance
    WHERE ano = v_ano;
    
    DBMS_OUTPUT.PUT_LINE('Account No: ' || v_ano || ' New Balance: ' || v_balance);
  END LOOP;
  CLOSE c_Account;
END;
/


