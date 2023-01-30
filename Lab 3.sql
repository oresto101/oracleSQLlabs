#TASK 34
DECLARE
    catfunction Cats.function%TYPE;
BEGIN
    SELECT function INTO catfunction
    FROM Cats
    WHERE function = UPPER('&functionname');
    DBMS_OUTPUT.PUT_LINE(catfunction || ' - function found');
EXCEPTION
    WHEN TOO_MANY_ROWS 
        THEN DBMS_OUTPUT.PUT_LINE(catfunction || ' - function found more than once');
    WHEN NO_DATA_FOUND 
        THEN DBMS_OUTPUT.PUT_LINE(' - function not found');
END;

#TASK 35
DECLARE 
    cat_name Cats.name%TYPE;
    cat_ration NUMBER;
    cat_join_month NUMBER;
    cat_found BOOLEAN DEFAULT FALSE;
BEGIN
    SELECT name, (NVL(mice_ration, 0) + NVL(mice_extra,0))*12, EXTRACT(MONTH FROM in_herd_since)
    INTO cat_name, cat_ration, cat_join_month
    FROM Cats
    WHERE nickname ='&nickname';
    IF cat_ration > 700 
        THEN DBMS_OUTPUT.PUT_LINE('total annual mice ration> 700');
    ELSIF cat_name LIKE '%A%'
        THEN DBMS_OUTPUT.PUT_LINE('name contains the letter A');
    ELSIF cat_join_month = 5 
        THEN DBMS_OUTPUT.PUT_LINE('May is the month of joining the herd');
    ELSE DBMS_OUTPUT.PUT_LINE('does not match the criteria');
    END IF;
END;

#TASK 36
DECLARE 
    CURSOR queue IS
        SELECT nickname, NVL(mice_ration,0) eats, Functions.max_mice max
        FROM Cats JOIN Functions ON Cats.function = Functions.function
        ORDER BY NVL(mice_ration,0)
        FOR UPDATE OF mice_ration;
    changes NUMBER:=0;
    total NUMBER:=0;
    cat queue%ROWTYPE;
BEGIN
    SELECT SUM(NVL(mice_ration,0)) INTO total
    FROM Cats;
    WHILE total <= 1050
        LOOP
        FOR cat IN queue
        LOOP
            IF ROUND(cat.eats * 1.1) <= cat.max THEN
                UPDATE Cats
                SET mice_ration = ROUND(mice_ration * 1.1)
                WHERE CURRENT OF queue;
                total := total + ROUND(cat.eats * 0.1);
                changes := changes + 1;
            ELSIF cat.eats <> cat.max THEN
                UPDATE Cats
                SET mice_ration = cat.max
                WHERE CURRENT OF queue;
                total := total + cat.max - cat.eats;
                changes := changes + 1;
            END IF;
        END LOOP;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total ration ' || TO_CHAR(total) || 'Changes: ' || TO_CHAR(changes));
END;

SELECT name, mice_ration "Eats"
FROM Cats
ORDER BY mice_ration DESC;

ROLLBACK;

#TASK 37
DECLARE 
    CURSOR top_5_cats IS
        SELECT nickname, NVL(mice_ration,0) +  NVL(mice_extra, 0) eats
        FROM Cats
        ORDER BY eats DESC;
    top top_5_cats%ROWTYPE;
BEGIN
    OPEN top_5_cats;
    DBMS_OUTPUT.PUT_LINE('No   Nickname   Eats');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    FOR i IN 1..5
    LOOP
        FETCH top_5_cats INTO top;
        EXIT WHEN top_5_cats%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(i) ||'    '|| RPAD(top.nickname, 8) || '    ' || LPAD(TO_CHAR(top.eats), 5));
    END LOOP;
END;

#TASK 38
DECLARE
    no_of_superiors NUMBER := :no_of_superiors;
    current_nickname Cats.nickname%TYPE;
    current_name Cats.name%TYPE;
    chief_nickname Cats.chief%TYPE;
    CURSOR under_cats IS SELECT nickname, name
                        FROM Cats
                        WHERE function in ('CAT', 'NICE');
BEGIN
    DBMS_OUTPUT.PUT(RPAD('name ', 15));
    FOR no IN 1..no_of_superiors
        LOOP
            DBMS_OUTPUT.PUT(RPAD('|  Chief ' || no, 15));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 15 * (no_of_superiors + 1), '-'));
    FOR cat IN under_cats
        LOOP
            DBMS_OUTPUT.PUT(RPAD(cat.name, 15));
            SELECT chief INTO chief_nickname FROM Cats WHERE nickname = cat.nickname;
            FOR cnt IN 1..no_of_superiors
                LOOP
                    IF chief_nickname IS NULL THEN
                        DBMS_OUTPUT.PUT(RPAD('|  ', 15));
                    ELSE
                        SELECT C.name, C.nickname, C.chief
                        INTO current_name, current_nickname, chief_nickname
                        FROM Cats C
                        WHERE C.nickname = chief_nickname;
                        DBMS_OUTPUT.PUT(RPAD('|  ' || current_name, 15));
                    END IF;
                END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
END;

#TASK 39
DECLARE
    no_band NUMBER:= &number_of_band;
    name_band Bands.name%TYPE := '&band_name';
    hunt_site Bands.site%TYPE := '&hunt_site';
    bands_found NUMBER;
    already_exists EXCEPTION;
    invalid_band_no EXCEPTION;
    exception_message    VARCHAR2(50) := '';
BEGIN
    IF no_band <= 0 THEN RAISE invalid_band_no;
    END IF;
    
    SELECT COUNT(*) INTO bands_found
    FROM Bands
    WHERE band_no = no_band;
    IF bands_found <> 0 
        THEN exception_message := exception_message || ' ' || no_band || ',';
    END IF;
    
    SELECT COUNT(*) INTO bands_found
    FROM Bands
    WHERE name_band = name;
    IF bands_found <> 0 
        THEN exception_message := exception_message || ' ' || name_band || ',';
    END IF;
    
    SELECT COUNT(*) INTO bands_found
    FROM Bands
    WHERE site = hunt_site;
    IF bands_found <> 0 
        THEN exception_message := exception_message || ' ' || hunt_site || ',';
    END IF;
    
    IF LENGTH(exception_message) > 0 THEN
        RAISE already_exists;
    END IF;
    
    INSERT INTO Bands(band_no, name, site) VALUES (no_band, name_band, hunt_site);
    
EXCEPTION
    WHEN invalid_band_no THEN
        DBMS_OUTPUT.PUT_LINE(no_band || '<=0 !');
    WHEN already_exists THEN
        DBMS_OUTPUT.PUT_LINE(TRIM(TRAILING ',' FROM exception_message) || ': already exists');
END;

#TASK 40
CREATE OR REPLACE PROCEDURE AddBand(no_band Bands.band_no%TYPE,
                                    name_band Bands.name%TYPE,
                                    hunt_site Bands.site%TYPE)
        IS
             bands_found NUMBER;
             already_exists EXCEPTION;
             invalid_band_no EXCEPTION;
             exception_message    VARCHAR2(50) := '';
        BEGIN
          IF no_band <= 0 THEN RAISE invalid_band_no;
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE band_no = no_band;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || no_band || ',';
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE name_band = name;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || name_band || ',';
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE site = hunt_site;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || hunt_site || ',';
          END IF;
    
          IF LENGTH(exception_message) > 0 THEN
            RAISE already_exists;
          END IF;
    
        INSERT INTO Bands(band_no, name, site) VALUES (no_band, name_band, hunt_site);
    
        EXCEPTION
          WHEN invalid_band_no THEN
            DBMS_OUTPUT.PUT_LINE(no_band || '<=0 !');
          WHEN already_exists THEN
            DBMS_OUTPUT.PUT_LINE(TRIM(TRAILING ',' FROM exception_message) || ': already exists');
    END;
    
EXECUTE AddBand(2, 'BLACK KNIGHTS', 'FIELD');
EXECUTE AddBand(6, 'SUPERIORS', 'CELLAR');
EXECUTE AddBand(7, 'PINTO HUNTERS', 'HILLOCK');
EXECUTE AddBand(0, 'NEW', 'CELLAR');


#TASK 44
CREATE OR REPLACE PACKAGE PACK IS
    FUNCTION get_tax(cat_nickname Cats.nickname%TYPE) RETURN NUMBER;
    PROCEDURE  AddBand(no_band Bands.band_no%TYPE,
                                    name_band Bands.name%TYPE,
                                    hunt_site Bands.site%TYPE);
END PACK;

CREATE OR REPLACE PACKAGE BODY PACK IS
    FUNCTION get_tax(cat_nickname Cats.nickname%TYPE) RETURN NUMBER
         IS
            tax NUMBER := 0;
            counter NUMBER := 0;
        BEGIN
            SELECT
                CEIL(0.05 * (mice_ration + NVL(mice_extra, 0))) INTO tax
            FROM CATS
            WHERE nickname = cat_nickname;
            SELECT COUNT(nickname) 
            INTO counter 
            FROM Cats
            WHERE chief = cat_nickname;
            IF counter = 0 THEN
                tax := tax + 2;
            END IF;
            SELECT COUNT(nickname) INTO counter FROM Incidents WHERE nickname = cat_nickname;
            if counter = 0 THEN
                tax := tax + 1;
            END IF;
            SELECT NVL(mice_ration,0) INTO counter FROM CATS WHERE nickname = cat_nickname;
            IF counter > 20 THEN
                tax := tax_price + 5;
            END IF;
        RETURN tax;
        END;


    PROCEDURE AddBand(no_band Bands.band_no%TYPE,
                                    name_band Bands.name%TYPE,
                                    hunt_site Bands.site%TYPE)
        IS
             bands_found NUMBER;
             already_exists EXCEPTION;
             invalid_band_no EXCEPTION;
             exception_message    VARCHAR2(50) := '';
        BEGIN
          IF no_band <= 0 THEN RAISE invalid_band_no;
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE band_no = no_band;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || no_band || ',';
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE name_band = name;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || name_band || ',';
          END IF;
    
          SELECT COUNT(*) INTO bands_found
          FROM Bands
          WHERE site = hunt_site;
          IF bands_found <> 0 
            THEN exception_message := exception_message || ' ' || hunt_site || ',';
          END IF;
    
          IF LENGTH(exception_message) > 0 THEN
            RAISE already_exists;
          END IF;
    
        INSERT INTO Bands(band_no, name, site) VALUES (no_band, name_band, hunt_site);
    
        EXCEPTION
          WHEN invalid_band_no THEN
            DBMS_OUTPUT.PUT_LINE(no_band || '<=0 !');
          WHEN already_exists THEN
            DBMS_OUTPUT.PUT_LINE(TRIM(TRAILING ',' FROM exception_message) || ': already exists');
    END;
END PACK;

EXECUTE PACK.AddBands(2, 'BLACK KNIGHTS', 'FIELD');
EXECUTE PACK.AddBands(6, 'SUPERIORS', 'CELLAR');
EXECUTE PACK.AddBands(7, 'PINTO HUNTERS', 'HILLOCK');
EXECUTE PACK.AddBands(0, 'NEW', 'CELLAR');
SELECT * FROM bandy;

ROLLBACK;
BEGIN
        FOR cat IN (SELECT nickname FROM Cats)
        LOOP
            DBMS_OUTPUT.PUT_LINE(RPAD(cat.nickname, 8) || ' tax ' || task_44.find_tax(cat.nickname));
        END LOOP;
END;

DROP PACKAGE task_44;


#TASK 41 
CREATE OR REPLACE TRIGGER always_only_increment_band_no
    BEFORE INSERT 
    ON Bands
    FOR EACH ROW
DECLARE
    last_no Bands.band_no%TYPE;
BEGIN
    SELECT MAX(band_no)
    INTO last_no
    FROM Bands;
    IF last_no + 1 <> :NEW.band_no THEN
        :NEW.band_no := last_no + 1;
    END IF;
END;




EXECUTE PACK.AddBand(69, 'NICE', 'NICEEE');

SELECT * FROM Bands;

DROP TRIGGER always_only_increment_band_no;
ROLLBACK;

#TASK 42A
CREATE OR REPLACE PACKAGE virus IS
    punishment NUMBER := 0;
    reward NUMBER := 0;
    tiger_ration Cats.mice_ration%TYPE;
END;

CREATE OR REPLACE TRIGGER virus_ration
    BEFORE UPDATE OF mice_ration
    ON Cats
DECLARE

BEGIN
    SELECT mice_ration INTO virus.tiger_ration FROM CATS WHERE nickname = 'TIGER';
END;

CREATE OR REPLACE TRIGGER adjust_rations
    BEFORE UPDATE OF mice_ration
    ON Cats
    FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.function = 'NICE' THEN
        IF :NEW.mice_ration <= :OLD.mice_ration THEN
            :NEW.mice_ration := :OLD.mice_ration;
        ELSIF :NEW.mice_ration - :OLD.mice_ration < 0.1 * virus.tiger_ration THEN
            :NEW.mice_ration := :NEW.mice_ration + ROUND(0.1 * virus.tiger_ration);
            :NEW.mice_extra := NVL(:NEW.mice_extra, 0) + 5;
            virus.punishment := virus.punishment + ROUND(0.1 * virus.tiger_ration);
        ELSE
            virus.reward := virus.reward + 5;
        END IF;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER virus_update
    AFTER UPDATE OF mice_ration
    ON Cats
DECLARE
    ration CATS.mice_ration%TYPE;
    extra CATS.mice_extra%TYPE;
BEGIN
    SELECT mice_ration, mice_extra
    INTO ration, extra
    FROM CATS
    WHERE nickname = 'TIGER';
    ration := ration - virus.punishment;
    extra := extra + virus.reward;
    IF virus.punishment <> 0 OR virus.reward <> 0 THEN
        virus.punishment := 0;
        virus.reward := 0;
        IF ration > 0 THEN
            UPDATE Cats
            SET mice_ration = ration, mice_extra = extra
            WHERE nickname = 'TIGER';
        ELSE
            UPDATE CATS
            SET mice_ration = 0, mice_extra = extra
            WHERE nickname = 'TIGER';
        END IF;
    END IF;
END;

UPDATE Cats
SET mice_ration = 69
WHERE nickname = 'NICE';

UPDATE Cats
SET mice_ration = mice_ration + 22
WHERE function = 'ZOMBIES';

UPDATE Cats
SET mice_ration = mice_ration + 69
WHERE function = 'NICE';

SELECT *
FROM CATS
WHERE nickname IN ('ZOMBIES', 'NICE');

ROLLBACK;

DROP TRIGGER virus_update;
DROP TRIGGER virus_ration;
DROP TRIGGER adjust_rations;
DROP PACKAGE virus;

#TASK 42B
CREATE OR REPLACE TRIGGER virus_compound
    FOR UPDATE OF mice_ration
    ON CATS
    COMPOUND TRIGGER
    tiger_ration Cats.mice_ration%TYPE;
    extra Cats.mice_extra%TYPE;
    punishment NUMBER := 0;
    reward NUMBER := 0;
BEFORE STATEMENT IS
BEGIN
    SELECT mice_ration INTO tiger_ration
    FROM Cats
    WHERE nickname = 'TIGER';
END BEFORE STATEMENT;
BEFORE EACH ROW IS
BEGIN
    IF :NEW.function = 'NICE' THEN
        IF :NEW.mice_ration <= :OLD.mice_ration THEN
            :NEW.mice_ration := :OLD.mice_ration;
        ELSIF :NEW.mice_ration - :OLD.mice_ration < 0.1 * tiger_ration THEN
            :NEW.mice_ration := :NEW.mice_ration + ROUND(0.1 * tiger_ration);
            :NEW.mice_extra := NVL(:NEW.mice_extra, 0) + 5;
            punishment := punishment + ROUND(0.1 * tiger_ration);
        ELSE
            reward := reward + 5;
        END IF;
    END IF;
END BEFORE EACH ROW;
AFTER STATEMENT IS
BEGIN
    SELECT mice_extra INTO extra
    FROM Cats
    WHERE nickname = 'TIGER';
    tiger_ration := tiger_ration - punishment;
    extra := extra + reward;
    IF punishment <> 0 OR reward <> 0 THEN
        punishment := 0;
        reward := 0;
        IF tiger_ration > 0 THEN
            UPDATE Cats
            SET mice_ration = tiger_ration, mice_extra = extra
            WHERE nickname = 'TIGER';
        ELSE
            UPDATE CATS
            SET mice_ration = 0, mice_extra = extra
            WHERE nickname = 'TIGER';
        END IF;
    END IF;
END AFTER STATEMENT;
END;
/

UPDATE Cats
SET mice_ration = 69
WHERE nickname = 'NICE';

UPDATE Cats
SET mice_ration = mice_ration + 22
WHERE function = 'ZOMBIES';

UPDATE Cats
SET mice_ration = mice_ration + 69
WHERE function = 'NICE';

SELECT *
FROM CATS
WHERE nickname IN ('ZOMBIES', 'NICE');

ROLLBACK;

-- Task 43
DECLARE
    CURSOR cursor_functions IS (SELECT function FROM FUNCTIONS);
    counter NUMBER;
BEGIN
    DBMS_OUTPUT.PUT('BAND NAME            GENDER         HOW MANY ');
    FOR curr_function IN cursor_functions LOOP
      DBMS_OUTPUT.PUT(RPAD(curr_function.function, 10));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('SUM');
    DBMS_OUTPUT.PUT('-------------------- -------------- --------');
    FOR curr_function IN cursor_functions LOOP
          DBMS_OUTPUT.PUT(' ---------');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' --------');
    FOR curr_band IN (SELECT name, band_no FROM BANDS) LOOP
        FOR curr_gender IN (SELECT gender FROM CATS GROUP BY gender) LOOP
            DBMS_OUTPUT.PUT(RPAD(curr_band.name, 21));
            DBMS_OUTPUT.PUT(CASE WHEN curr_gender.gender = 'M' THEN RPAD('Male cat', 15) else RPAD('Female cat', 15) END);
            SELECT COUNT(*) INTO counter FROM CATS WHERE CATS.band_no = curr_band.band_no AND CATS.gender=curr_gender.gender;
            DBMS_OUTPUT.PUT(RPAD(counter, 9));
            FOR curr_function IN cursor_functions LOOP
                SELECT sum(mice_ration + NVL(mice_extra, 0)) INTO counter FROM CATS c WHERE c.gender=curr_gender.gender AND c.function=curr_function.function AND c.band_no=curr_band.band_no;
                DBMS_OUTPUT.PUT(RPAD(NVL(counter, 0), 10));
            END LOOP;
            SELECT SUM(mice_ration + NVL(mice_extra, 0)) INTO counter FROM CATS c WHERE c.band_no=curr_band.band_no AND curr_gender.gender=c.gender;
            DBMS_OUTPUT.PUT(RPAD(NVL(counter, 0), 10));
            DBMS_OUTPUT.new_line();
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT('-------------------- -------------- --------');
    FOR curr_function IN cursor_functions LOOP DBMS_OUTPUT.PUT(' ---------');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' --------');
    DBMS_OUTPUT.PUT('Eats in total                                ');
    FOR curr_function IN cursor_functions LOOP
        SELECT SUM(mice_ration + NVL(mice_extra, 0)) INTO counter FROM CATS c WHERE c.function=curr_function.function;
        DBMS_OUTPUT.PUT(RPAD(NVL(counter, 0), 10));
    END LOOP;
    SELECT sum(mice_ration + nvl(mice_extra,0)) INTO counter FROM CATS;
    DBMS_OUTPUT.PUT(RPAD(counter, 10));
    DBMS_OUTPUT.new_line();
END;

#TASK 45
CREATE TABLE Extra_extra_rations(
    catnickname VARCHAR2(15) PRIMARY KEY CONSTRAINT fk_extra_extra_rations_nickname REFERENCES Cats(nickname),
    extra_rations NUMBER(3) DEFAULT 0    
);

CREATE OR REPLACE TRIGGER tigers_trigger
    BEFORE UPDATE OF mice_ration
    ON Cats
    FOR EACH ROW
DECLARE
    CURSOR queue IS SELECT nickname
                FROM Cats
                WHERE function = 'NICE';
    counter NUMBER;
    command VARCHAR(100);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    IF LOGIN_USER <> 'TIGER' AND :NEW.mice_ration > :OLD.mice_ration AND :NEW.function = 'NICE' THEN
        DBMS_OUTPUT.PUT_LINE('Found change in mice ration of ' || :NEW.nickname || '; punishment is used');
        FOR cat IN queue LOOP
            SELECT COUNT(*) INTO counter FROM Extra_extra_rations WHERE nickname = catnickname;
            IF counter > 0 THEN
                command_to_execute := 'UPDATE Extra_extra_rations SET extra_rations = extra_rations - 10 WHERE :catnickname = nickname';
            ELSE 
                command_to_execute := 'INSERT INTO Extra_extra_rations (catnickname, extra_rations) VALUES (:catnickname, -10)';
            END IF;

            EXECUTE IMMEDIATE command_to_execute USING cat.nickname;
        END LOOP;
        COMMIT;
    END IF;
END;
/

SET SERVEROUTPUT ON;

UPDATE Cats
SET mice_ration = 150
WHERE nickname = 'LITTLE';

SELECT *
FROM Cats
WHERE function = 'NICE';

SELECT * FROM Extra_extra_rations;

ROLLBACK;

DROP TRIGGER tigers_trigger;

DROP TABLE Extra_extra_rations;

-- Task 46
CREATE TABLE invalid_change_attempts 
(
    who_id number(2) GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    who VARCHAR2(15) NOT NULL, 
    when DATE NOT NULL,
    for VARCHAR2(25) NOT NULL,
    operation VARCHAR2(25) NOT NULL
);

CREATE OR REPLACE TRIGGER change_attempts_trigger
    BEFORE INSERT OR UPDATE OF mice_ration
    ON CATS
    FOR EACH ROW
DECLARE
    min_mice Functions.min_mice%TYPE;
    max_mice Functions.max_mice%TYPE;
    current_date DATE DEFAULT SYSDATE;
    operation_performed VARCHAR2(20);
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    SELECT min_mice, max_mice INTO min_mice, max_mice FROM Functions WHERE Function = :NEW.Function;
    IF max_mice < :NEW.mice_ration OR min_mice > :NEW.mice_ration THEN
        IF INSERTING THEN 
            operation_performed := 'INSERT';
        ELSIF UPDATING THEN
            operation_performed := 'UPDATE';
        END IF;
        INSERT INTO illegal_change_attempts(who, when, for, operation) VALUES (ORA_LOGIN_USER, current_date, :NEW.nickname, operation_performed);
        COMMIT;
        RAISE_APPLICATION_ERROR(-96, 'no changes!!');
    END IF;
END;
/

UPDATE CATS
SET mice_ration = 91
WHERE nickname = 'BALD';

ALTER SESSION SET nls_date_format='YYYY/MM/DD';

INSERT INTO Cats VALUES ('NEWCAT', 'M', 'NEWCAT', 'DIVISIVE', 'TIGER', '2022-12-11', 56, NULL, 1);

SELECT * FROM Cats;
SELECT * FROM invalid_change_attempts;

ROLLBACK;

DROP TRIGGER change_attempts_trigger;

DROP TABLE invalid_change_attempts;