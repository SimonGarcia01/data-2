DROP TABLESPACE tbs_twitter INCLUDING CONTENTS AND DATAFILES;

--Create the tablespace
CREATE TABLESPACE tbs_twitter DATAFILE 'C:\Users\kracr\OneDrive\Desktop\Datos 2\taller oracle\tablespace\tbs_twitter.dbf' SIZE 10M AUTOEXTEND ON SEGMENT SPACE MANAGEMENT AUTO;

--Create user tw1 with tables space tbs_twitter
CREATE USER tw1 IDENTIFIED BY tw123 DEFAULT TABLESPACE tbs_twitter;

--Privileges to connect and create objects
GRANT CREATE SESSION TO tw1;
--Privilages to create objects
GRANT CREATE TABLE, CREATE PROCEDURE, CREATE VIEW, CREATE SEQUENCE, CREATE TRIGGER TO tw1;

--Give the user a quota in the tablespace
ALTER USER tw1 QUOTA 10M on tbs_twitter;

--Create tweeter_reader role
CREATE ROLE twitter_reader;
GRANT SELECT ON tw1.comments TO twitter_reader;
GRANT SELECT ON tw1.users TO twitter_reader;

--Create user guest_user
CREATE USER guest_user IDENTIFIED BY guest123;
GRANT twitter_reader TO guest_user;
--Needed this to connect to the guest_user
GRANT CREATE SESSION TO guest_user;

