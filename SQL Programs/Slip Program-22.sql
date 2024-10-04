-- Creating the Department table
CREATE TABLE Department (
    dno NUMBER PRIMARY KEY,          -- Department Number as Primary Key
    dname VARCHAR2(50) NOT NULL      -- Department Name (should not be null)
);

-- Creating the Book table
CREATE TABLE Book (
    bno NUMBER PRIMARY KEY,           -- Book Number as Primary Key
    bname VARCHAR2(100) NOT NULL,     -- Book Name (should not be null)
    pubname VARCHAR2(100) NOT NULL,   -- Publisher Name (should not be null)
    price NUMBER CHECK (price >= 0),   -- Price should be >= 0
    dno NUMBER,                       -- Foreign Key referencing Department
    FOREIGN KEY (dno) REFERENCES Department(dno)
);

-- Inserting sample data into Department table
INSERT INTO Department (dno, dname) VALUES (1, 'Computer Science');
INSERT INTO Department (dno, dname) VALUES (2, 'Mathematics');
INSERT INTO Department (dno, dname) VALUES (3, 'Physics');

-- Inserting sample data into Book table
INSERT INTO Book (bno, bname, pubname, price, dno) VALUES (101, 'Database Systems', 'Oxford', 300, 1);
INSERT INTO Book (bno, bname, pubname, price, dno) VALUES (102, 'Data Structures', 'McGraw Hill', 500, 1);
INSERT INTO Book (bno, bname, pubname, price, dno) VALUES (201, 'Calculus', 'Wiley', 400, 2);
INSERT INTO Book (bno, bname, pubname, price, dno) VALUES (202, 'Linear Algebra', 'Springer', 250, 2);
INSERT INTO Book (bno, bname, pubname, price, dno) VALUES (301, 'Quantum Mechanics', 'Cambridge', 600, 3);

-- 20a. Procedure to display the name of the department spending the maximum amount on books
CREATE OR REPLACE PROCEDURE p1 
IS    
    vdname VARCHAR2(50); 
BEGIN 
    SELECT d.dname INTO vdname    
    FROM Department d     
    WHERE d.dno = ( 
        SELECT dno 
        FROM ( 
            SELECT dno, SUM(price) AS total_spending   
            FROM Book                
            GROUP BY dno                
            ORDER BY total_spending DESC 
        )  
        WHERE ROWNUM = 1 
    );       
    DBMS_OUTPUT.PUT_LINE('Department spending the maximum on books is: ' || vdname); 
END; 
/

-- Execute the Procedure to display the department spending the maximum amount on books
BEGIN 
    p1; 
END; 
/

-- 20b. Cursor to display department-wise expenditure on books
DECLARE 
    CURSOR cursor_exp IS 
        SELECT d.dname, SUM(b.price) AS total_spending 
        FROM Department d 
        JOIN Book b ON d.dno = b.dno 
        GROUP BY d.dname; 
     
    v_dname Department.dname%TYPE; 
    v_total_spending NUMBER; 
BEGIN 
    OPEN cursor_exp; 
    LOOP 
        FETCH cursor_exp INTO v_dname, v_total_spending; 
        EXIT WHEN cursor_exp%NOTFOUND; 

        DBMS_OUTPUT.PUT_LINE('Dept: ' || v_dname || ' spent ' || v_total_spending || ' on books.'); 
    END LOOP; 
    CLOSE cursor_exp; 
END; 
/
