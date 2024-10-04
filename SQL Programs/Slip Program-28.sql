-- Creating the Party table
CREATE TABLE Party (
    partycode NUMBER PRIMARY KEY,  -- Party Code as Primary Key
    partyname VARCHAR2(50) NOT NULL -- Party Name (should not be null)
);

-- Creating the Politician table
CREATE TABLE Politician (
    pno NUMBER PRIMARY KEY,          -- Politician Number as Primary Key
    pname VARCHAR2(50),              -- Politician Name
    description VARCHAR2(255),       -- Description of the Politician
    partycode NUMBER,                -- Foreign Key for Party (M:1 relationship)
    CONSTRAINT fk_party FOREIGN KEY (partycode) REFERENCES Party(partycode)
);

-- Inserting sample data into Party table
INSERT INTO Party (partycode, partyname) VALUES (1, 'BJP');
INSERT INTO Party (partycode, partyname) VALUES (2, 'Congress');
INSERT INTO Party (partycode, partyname) VALUES (3, 'AAP');

-- Inserting sample data into Politician table
INSERT INTO Politician (pno, pname, description, partycode) VALUES (101, 'Narendra Modi', 'Current Prime Minister of India', 1);
INSERT INTO Politician (pno, pname, description, partycode) VALUES (102, 'Amit Shah', 'Home Minister of India', 1);
INSERT INTO Politician (pno, pname, description, partycode) VALUES (201, 'Sonia Gandhi', 'Former President of Congress', 2);
INSERT INTO Politician (pno, pname, description, partycode) VALUES (301, 'Arvind Kejriwal', 'Chief Minister of Delhi', 3);

-- 18a. Function to return total number of politicians of a given party
CREATE OR REPLACE FUNCTION get_count(party_code NUMBER) 
RETURN NUMBER 
IS 
    total NUMBER; 
BEGIN 
    -- Query to count the number of politicians for the given party 
    SELECT COUNT(*) 
    INTO total 
    FROM Politician 
    WHERE partycode = party_code; 

    -- Return the total count 
    RETURN total; 
END; 
/

-- Example of executing the get_count function
DECLARE
    total_politicians NUMBER;
BEGIN
    total_politicians := get_count(1);  -- Get count for BJP (partycode = 1)
    dbms_output.put_line('Total number of politicians in BJP: ' || total_politicians);
END;
/

-- 18b. Cursor to display details of all politicians of ‘BJP’ party
DECLARE 
    v_partycode Party.partycode%TYPE; 
    -- Cursor to fetch details of politicians in the 'BJP' party 
    CURSOR C1 IS 
        SELECT p.pno, p.pname, p.description 
        FROM Politician p 
        WHERE p.partycode = v_partycode;    -- partycode for ‘BJP’ is selected in below code 

    -- Variables to hold fetched data 
    v_pno Politician.pno%TYPE; 
    v_pname Politician.pname%TYPE; 
    v_desc Politician.description%TYPE; 
     
BEGIN 
    -- Retrieve the partycode for 'BJP' 
    SELECT partycode INTO v_partycode 
    FROM Party WHERE partyname = 'BJP'; 
     
    OPEN C1;     
    LOOP 
        FETCH C1 INTO v_pno, v_pname, v_desc;         
        EXIT WHEN C1%NOTFOUND;         
        dbms_output.put_line('Politician No: ' || v_pno || ', Name: ' || v_pname || ', Desc: ' || v_desc); 
    END LOOP; 
    -- Close the cursor 
    CLOSE C1; 
END; 
/
