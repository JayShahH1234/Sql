CREATE TABLE Doctor (
  dno NUMBER PRIMARY KEY,
  dname VARCHAR2(50),
  dcity VARCHAR2(50) NOT NULL
);

CREATE TABLE Hospital (
  hno NUMBER PRIMARY KEY,
  hname VARCHAR2(50),
  hcity VARCHAR2(50) NOT NULL
);

CREATE TABLE Doctor_Hospital (
  dno NUMBER,
  hno NUMBER,
  PRIMARY KEY (dno, hno),
  FOREIGN KEY (dno) REFERENCES Doctor(dno),
  FOREIGN KEY (hno) REFERENCES Hospital(hno)
);

-- Insert data into Doctor table
INSERT INTO Doctor (dno, dname, dcity) VALUES (1, 'Dr. John', 'Pune');
INSERT INTO Doctor (dno, dname, dcity) VALUES (2, 'Dr. Smith', 'Mumbai');
INSERT INTO Doctor (dno, dname, dcity) VALUES (3, 'Dr. Mary', 'Pune');

-- Insert data into Hospital table
INSERT INTO Hospital (hno, hname, hcity) VALUES (101, 'City Hospital', 'Pune');
INSERT INTO Hospital (hno, hname, hcity) VALUES (102, 'Global Hospital', 'Mumbai');
INSERT INTO Hospital (hno, hname, hcity) VALUES (103, 'Sunrise Hospital', 'Pune');

-- Insert data into Doctor_Hospital table
INSERT INTO Doctor_Hospital (dno, hno) VALUES (1, 101);
INSERT INTO Doctor_Hospital (dno, hno) VALUES (1, 103);
INSERT INTO Doctor_Hospital (dno, hno) VALUES (2, 102);
INSERT INTO Doctor_Hospital (dno, hno) VALUES (3, 101);

-- a) PL/SQL Procedure to display details of all hospitals in 'Pune'
CREATE OR REPLACE PROCEDURE displayHospitalsInPune
IS
BEGIN
  FOR rec IN (SELECT hno, hname, hcity FROM Hospital WHERE hcity = 'Pune') 
  LOOP
    DBMS_OUTPUT.PUT_LINE('Hospital No: ' || rec.hno || ', Hospital Name: ' || rec.hname || ', City: ' || rec.hcity);
  END LOOP;
END;
/

-- b) Cursor to list all hospitals and their doctor's details
DECLARE
  CURSOR c_HospitalDoctor IS
    SELECT h.hno, h.hname, d.dno, d.dname
    FROM Hospital h
    JOIN Doctor_Hospital dh ON h.hno = dh.hno
    JOIN Doctor d ON dh.dno = d.dno;
  
  v_hno Hospital.hno%TYPE;
  v_hname Hospital.hname%TYPE;
  v_dno Doctor.dno%TYPE;
  v_dname Doctor.dname%TYPE;
BEGIN
  OPEN c_HospitalDoctor;
  DBMS_OUTPUT.PUT_LINE('Listing Hospitals and their Doctors:');
  
  LOOP
    FETCH c_HospitalDoctor INTO v_hno, v_hname, v_dno, v_dname;
    EXIT WHEN c_HospitalDoctor%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Hospital No: ' || v_hno || ', Hospital Name: ' || v_hname || ', Doctor No: ' || v_dno || ', Doctor Name: ' || v_dname);
  END LOOP;
  
  CLOSE c_HospitalDoctor;
END;
/
