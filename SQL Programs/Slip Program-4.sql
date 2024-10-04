CREATE TABLE Department4 (
  dno NUMBER PRIMARY KEY,
  dname VARCHAR2(50)
);

CREATE TABLE Book4 (
  bno NUMBER PRIMARY KEY,
  bname VARCHAR2(100),
  pubname VARCHAR2(100),
  price NUMBER,
  dno NUMBER,
  FOREIGN KEY (dno) REFERENCES Department4(dno)
);

INSERT INTO Department4 (dno, dname) VALUES (1, 'Computer');
INSERT INTO Department4 (dno, dname) VALUES (2, 'Science');
INSERT INTO Book4 (bno, bname, pubname, price, dno) VALUES (101, 'Database Systems', 'Pearson', 500, 1);
INSERT INTO Book4 (bno, bname, pubname, price, dno) VALUES (102, 'Computer Networks', 'McGraw Hill', 700, 1);
INSERT INTO Book4 (bno, bname, pubname, price, dno) VALUES (103, 'Physics Fundamentals', 'OUP', 600, 2);
INSERT INTO Book4 (bno, bname, pubname, price, dno) VALUES (104, 'Organic Chemistry', 'Pearson', 800, 2);

CREATE OR REPLACE FUNCTION getTotalExpenses(p_dname IN VARCHAR2)
RETURN NUMBER
IS
  vtot NUMBER;
BEGIN
  SELECT SUM(price)
  INTO vtot
  FROM Book4 b
  JOIN Department4 d ON dno = d.dno
  WHERE dname = p_dname;
  RETURN vtot;
END;
/

DECLARE
  CURSOR c_Book IS
    SELECT bno, bname
    FROM Book4 b
    JOIN Department4 d ON b.dno = d.dno
    WHERE d.dname = 'Computer';
  vbno Book4.bno%TYPE;
  vbname Book4.bname%TYPE;
BEGIN
  OPEN c_Book;
  DBMS_OUTPUT.PUT_LINE('Displaying Books from Computer department');
  LOOP
    FETCH c_Book INTO vbno, vbname;
    EXIT WHEN c_Book%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Book No: ' || vbno || ', Book Name: ' || vbname);
  END LOOP;
  CLOSE c_Book;
END;
/
