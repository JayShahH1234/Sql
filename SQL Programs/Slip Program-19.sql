-- Creating the Student table
CREATE TABLE Student (
    rollno NUMBER PRIMARY KEY,  -- Student Roll Number as Primary Key
    name VARCHAR2(50),          -- Student Name
    class VARCHAR2(20),         -- Class
    totalmarks NUMBER           -- Total Marks
);

-- Creating the Teacher table
CREATE TABLE Teacher (
    tno NUMBER PRIMARY KEY,     -- Teacher Number as Primary Key
    tname VARCHAR2(50)          -- Teacher Name
);

-- Creating the Student_Teacher table to associate students with teachers and subjects
CREATE TABLE Student_Teacher (
    tno NUMBER,                 -- Teacher Number (Foreign Key)
    rollno NUMBER,              -- Student Roll Number (Foreign Key)
    subject VARCHAR2(50),       -- Subject
    CONSTRAINT fk_teacher FOREIGN KEY (tno) REFERENCES Teacher(tno),
    CONSTRAINT fk_student FOREIGN KEY (rollno) REFERENCES Student(rollno)
);

-- Inserting sample data into Student table
INSERT INTO Student (rollno, name, class, totalmarks) VALUES (1, 'John Doe', 'CS101', 450);
INSERT INTO Student (rollno, name, class, totalmarks) VALUES (2, 'Jane Smith', 'CS102', 500);
INSERT INTO Student (rollno, name, class, totalmarks) VALUES (3, 'Alice Walker', 'CS101', 400);

-- Inserting sample data into Teacher table
INSERT INTO Teacher (tno, tname) VALUES (1, 'Mr. Johnson');
INSERT INTO Teacher (tno, tname) VALUES (2, 'Ms. Davis');

-- Inserting sample data into Student_Teacher table (Teacher-Student relationship with subjects)
INSERT INTO Student_Teacher (tno, rollno, subject) VALUES (1, 1, 'Data Structure');
INSERT INTO Student_Teacher (tno, rollno, subject) VALUES (2, 2, 'Mathematics');
INSERT INTO Student_Teacher (tno, rollno, subject) VALUES (1, 3, 'Data Structure');

-- 16a) Procedure to display details of all teachers who are teaching subject 'Data Structure'

CREATE OR REPLACE PROCEDURE display_teachers(subname IN VARCHAR2) IS
BEGIN
    -- Looping through the teachers who teach the given subject
    FOR rec IN (
        SELECT t.tno, t.tname
        FROM Teacher t
        JOIN Student_Teacher st ON t.tno = st.tno
        WHERE st.subject = subname
    ) LOOP
        -- Displaying the teacher details
        DBMS_OUTPUT.PUT_LINE('Teacher No: ' || rec.tno || ', Teacher Name: ' || rec.tname);
    END LOOP;
END;
/

-- Execute the Procedure
BEGIN
    display_teachers('Data Structure');
END;
/


CREATE OR REPLACE TRIGGER check_student
BEFORE INSERT OR UPDATE ON Student
FOR EACH ROW
BEGIN
    -- Checking if total marks exceed 500
    IF :NEW.totalmarks > 500 THEN
        -- Raise an error if total marks exceed the limit
        RAISE_APPLICATION_ERROR(-20001, 'Sorry, Total Marks cannot be GREATER than 500.');
    END IF;
END;
/
