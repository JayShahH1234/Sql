-- Creating the Actor table
CREATE TABLE Actor (
    actno NUMBER PRIMARY KEY,    -- Actor Number as Primary Key
    actname VARCHAR2(50) NOT NULL -- Actor Name (should not be null)
);

-- Creating the Movie table
CREATE TABLE Movie (
    mvno NUMBER PRIMARY KEY,      -- Movie Number as Primary Key
    mvname VARCHAR2(100) NOT NULL, -- Movie Name (should not be null)
    releaseyear NUMBER CHECK (releaseyear > 1888) -- Valid release year (greater than 1888)
);

-- Creating the Movie_Actor junction table for many-to-many relationship
CREATE TABLE Movie_Actor (
    mvno NUMBER,                  -- Foreign Key referencing Movie
    actno NUMBER,                 -- Foreign Key referencing Actor
    PRIMARY KEY (mvno, actno),    -- Composite Primary Key
    FOREIGN KEY (mvno) REFERENCES Movie(mvno),
    FOREIGN KEY (actno) REFERENCES Actor(actno)
);

-- Inserting sample data into Actor table
INSERT INTO Actor (actno, actname) VALUES (1, 'Aamir Khan');
INSERT INTO Actor (actno, actname) VALUES (2, 'Katrina Kaif');
INSERT INTO Actor (actno, actname) VALUES (3, 'Suriya');

-- Inserting sample data into Movie table
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (101, 'Gajani', 2008);
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (102, 'Lagaan', 2001);
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (103, 'Dilwale Dulhania Le Jayenge', 1995); -- This should fail for trigger

-- Inserting sample data into Movie_Actor junction table
INSERT INTO Movie_Actor (mvno, actno) VALUES (101, 1); -- Aamir Khan in Gajani
INSERT INTO Movie_Actor (mvno, actno) VALUES (101, 2); -- Katrina Kaif in Gajani
INSERT INTO Movie_Actor (mvno, actno) VALUES (102, 1); -- Aamir Khan in Lagaan
INSERT INTO Movie_Actor (mvno, actno) VALUES (103, 3); -- Suriya in Dilwale Dulhania Le Jayenge

-- 19a. Trigger to restrict insertion or updating of movies released before year 2000
CREATE OR REPLACE TRIGGER trg_year_check 
BEFORE INSERT OR UPDATE ON Movie 
FOR EACH ROW 
BEGIN 
    IF :NEW.releaseyear < 2000 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Movies released before 2000 cannot be inserted/updated.'); 
    END IF; 
END; 
/

-- 19b. Function to return total number of actors acted in movie ‘Gajani’
CREATE OR REPLACE FUNCTION f1 
RETURN NUMBER 
IS 
    tot NUMBER; 
BEGIN 
    SELECT COUNT(DISTINCT actno) INTO tot 
    FROM Movie m 
    JOIN Movie_Actor ma ON m.mvno = ma.mvno 
    WHERE m.mvname = 'Gajani'; 
    RETURN tot; 
END; 
/

-- Example of executing the function to get total actors in 'Gajani'
DECLARE
    total_actors NUMBER;
BEGIN
    total_actors := f1();  -- Get count for 'Gajani'
    dbms_output.put_line('Total number of actors in Gajani: ' || total_actors);
END;
/
