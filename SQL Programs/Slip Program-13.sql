-- Create Movie table
CREATE TABLE Movie (
  mvno NUMBER PRIMARY KEY,        -- Primary key for Movie
  mvname VARCHAR2(100),           -- Movie name
  releaseyear NUMBER              -- Release year of the movie
);

-- Create Actor table
CREATE TABLE Actor (
  actno NUMBER PRIMARY KEY,       -- Primary key for Actor
  actname VARCHAR2(100)           -- Actor name
);

-- Create Movie_Actor table (Many-to-Many relationship with rate as descriptive attribute)
CREATE TABLE Movie_Actor (
  mvno NUMBER,                    -- Foreign key for Movie
  actno NUMBER,                   -- Foreign key for Actor
  rate NUMBER,                    -- Rate of actor in the movie
  PRIMARY KEY (mvno, actno),      -- Composite primary key
  FOREIGN KEY (mvno) REFERENCES Movie(mvno),
  FOREIGN KEY (actno) REFERENCES Actor(actno)
);

-- Insert data into Movie table
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (1, 'Devdas', 2002); -- Movie 1
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (2, 'Jodhaa Akbar', 2008); -- Movie 2
INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (3, 'Dhoom 2', 2006); -- Movie 3

-- Insert data into Actor table
INSERT INTO Actor (actno, actname) VALUES (101, 'Aishwarya Rai'); -- Actor 101
INSERT INTO Actor (actno, actname) VALUES (102, 'Hrithik Roshan'); -- Actor 102
INSERT INTO Actor (actno, actname) VALUES (103, 'Shah Rukh Khan'); -- Actor 103

-- Insert data into Movie_Actor table
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (1, 101, 8.5); -- Aishwarya in Devdas
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (2, 101, 9.0); -- Aishwarya in Jodhaa Akbar
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (3, 101, 8.7); -- Aishwarya in Dhoom 2
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (2, 102, 9.0); -- Hrithik in Jodhaa Akbar
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (3, 102, 8.7); -- Hrithik in Dhoom 2
INSERT INTO Movie_Actor (mvno, actno, rate) VALUES (1, 103, 8.5); -- Shah Rukh Khan in Devdas

-- a) PL/SQL function to return total number of movies of 'Aishwarya'
CREATE OR REPLACE FUNCTION totalMoviesAishwarya
RETURN NUMBER
IS
  v_total_movies NUMBER;
BEGIN
  -- Count the total number of movies where Aishwarya Rai has acted
  SELECT COUNT(*)
  INTO v_total_movies
  FROM Movie_Actor ma
  JOIN Actor a ON ma.actno = a.actno
  WHERE a.actname = 'Aishwarya Rai';
  
  -- Return the total number of movies
  RETURN v_total_movies;
END;
/

-- b) Trigger to restrict insertion/updation of movies released before the year 2005
CREATE OR REPLACE TRIGGER restrictBefore2005
BEFORE INSERT OR UPDATE ON Movie
FOR EACH ROW
BEGIN
  -- Check if the release year is less than 2005
  IF :NEW.releaseyear < 2005 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Movies released before the year 2005 are not allowed.');
  END IF;
END;
/

-- Test the trigger (will raise an error because release year is before 2005)
-- Uncomment to test the trigger
-- INSERT INTO Movie (mvno, mvname, releaseyear) VALUES (4, 'Old Movie', 1999); -- This will fail

-- Test PL/SQL function to return the number of movies of Aishwarya Rai
DECLARE
  v_total NUMBER;
BEGIN
  v_total := totalMoviesAishwarya;
  DBMS_OUTPUT.PUT_LINE('Total number of movies Aishwarya acted in: ' || v_total);
END;
/
