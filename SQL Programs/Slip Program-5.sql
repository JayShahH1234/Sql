-- Create Author table
CREATE TABLE Author (
    ano NUMBER PRIMARY KEY,
    aname VARCHAR2(100) NOT NULL
);

-- Create Book table
CREATE TABLE Book (
    bno NUMBER PRIMARY KEY,
    bname VARCHAR2(100),
    pubname VARCHAR2(100) NOT NULL,
    price NUMBER
);

-- Create Book_Author table (Many-to-Many Relationship)
CREATE TABLE Book_Author (
    bno NUMBER,
    ano NUMBER,
    PRIMARY KEY (bno, ano),
    FOREIGN KEY (bno) REFERENCES Book(bno),
    FOREIGN KEY (ano) REFERENCES Author(ano)
);

-- Insert authors into Author table
INSERT INTO Author (ano, aname) VALUES (1, 'Kanetkar');
INSERT INTO Author (ano, aname) VALUES (2, 'Robert Lafore');
INSERT INTO Author (ano, aname) VALUES (3, 'Herbert Schildt');

-- Insert books into Book table
INSERT INTO Book (bno, bname, pubname, price) VALUES (101, 'Let Us C', 'BPB Publications', 300);
INSERT INTO Book (bno, bname, pubname, price) VALUES (102, 'Data Structures Through C', 'BPB Publications', 400);
INSERT INTO Book (bno, bname, pubname, price) VALUES (103, 'C++ Programming', 'McGraw Hill', 500);
INSERT INTO Book (bno, bname, pubname, price) VALUES (104, 'Java: The Complete Reference', 'McGraw Hill', 600);

-- Insert relationships into Book_Author table
INSERT INTO Book_Author (bno, ano) VALUES (101, 1);
INSERT INTO Book_Author (bno, ano) VALUES (102, 1);
INSERT INTO Book_Author (bno, ano) VALUES (103, 2);
INSERT INTO Book_Author (bno, ano) VALUES (104, 3);

-- Create PL/SQL Procedure to display details of all books written by 'Kanetkar'
CREATE OR REPLACE PROCEDURE get_books_by_author_kanetkar AS
BEGIN
    FOR book_info IN (
        SELECT b.bno, b.bname, b.pubname, b.price
        FROM Book b
        JOIN Book_Author ba ON b.bno = ba.bno
        JOIN Author a ON a.ano = ba.ano
        WHERE a.aname = 'Kanetkar'
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Book No: ' || book_info.bno);
        DBMS_OUTPUT.PUT_LINE('Book Name: ' || book_info.bname);
        DBMS_OUTPUT.PUT_LINE('Publisher: ' || book_info.pubname);
        DBMS_OUTPUT.PUT_LINE('Price: ' || book_info.price);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
END;
/

-- Create Trigger to restrict insertion or update of books with price < 0
CREATE OR REPLACE TRIGGER check_price_before_insert_update
BEFORE INSERT OR UPDATE ON Book
FOR EACH ROW
BEGIN
    IF :NEW.price < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Price cannot be less than 0.');
    END IF;
END;
/
