-- Creating the Department table
CREATE TABLE Department (
    dno NUMBER PRIMARY KEY,       -- Department Number as Primary Key
    dname VARCHAR2(50)            -- Department Name
);

-- Creating the Book table
CREATE TABLE Book (
    bno NUMBER PRIMARY KEY,        -- Book Number as Primary Key
    bname VARCHAR2(100),           -- Book Name
    pubname VARCHAR2(100) NOT NULL,-- Publisher Name (cannot be null)
    price NUMBER,                  -- Book Price
    dno NUMBER,                    -- Foreign Key for Department (M:1 relationship)
    CONSTRAINT fk_department FOREIGN KEY (dno) REFERENCES Department(dno)
);

-- Creating or Replacing the PL/SQL Function
CREATE OR REPLACE FUNCTION get_total_books_by_dept(p_dno NUMBER) RETURN NUMBER IS
    v_total_books NUMBER;
BEGIN
    -- Calculating the total number of books for a given department
    SELECT COUNT(*)
    INTO v_total_books
    FROM Book
    WHERE dno = p_dno;

    -- Returning the total count of books
    RETURN v_total_books;
END;
/
DECLARE
v_total_books Number
begin
  v_total_books=Department Total Book(1);
  DBMS_OUTPUT.PUT_LINE ('TOTAL Books Purchased by Departmnet 1:'||v_total_books)
end;
-- Creating or Replacing the Trigger
CREATE OR REPLACE TRIGGER trg_check_book_price
BEFORE INSERT OR UPDATE ON Book
FOR EACH ROW
BEGIN
    -- Check if the price is less than 0
    IF :NEW.price < 0 THEN
        -- Raise an application error if the price is less than 0
        RAISE_APPLICATION_ERROR(-20001, 'Book price cannot be less than 0');
    END IF;
END;
/
