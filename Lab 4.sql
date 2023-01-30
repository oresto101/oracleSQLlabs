
DROP TYPE BODY BandsO ;
DROP TYPE BandsO FORCE;
DROP TYPE BODY FunctionsO;
DROP TYPE FunctionsO FORCE;
DROP TYPE BODY EnemiesO;
DROP TYPE EnemiesO FORCE;
DROP TYPE BODY CatsO;
DROP TYPE CatsO FORCE;
DROP TYPE BODY IncidentsO;
DROP TYPE IncidentsO FORCE;
DROP TABLE BandsT CASCADE CONSTRAINTS;
DROP TABLE FunctionsT CASCADE CONSTRAINTS;
DROP TABLE EnemiesT CASCADE CONSTRAINTS;
DROP TABLE CatsT CASCADE CONSTRAINTS;
DROP TABLE IncidentsT CASCADE CONSTRAINTS;



create or replace type BandsO AS object(
    Band_no NUMBER(2),
    name VARCHAR2(20),
    site VARCHAR2(15),
    band_chief VARCHAR2(15),
    MAP MEMBER FUNCTION info RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY BandsO AS
    MAP MEMBER FUNCTION info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Band_no: ' || Band_no || ' Name: ' || name || ' site: ' || site || ' band_chief: ' || band_chief;
    END;
END;

create table BandsTab OF BandsO(
    Band_no CONSTRAINT odPK_Band_no PRIMARY KEY,
    name CONSTRAINT cobfand_name_not_null NOT NULL,
    site CONSTRAINT cosite_funique unique,
    band_chief CONSTRAINT cobacnd_chief_unique unique
);

create or replace type FunctionsO AS object(
    function varchar2(10),
    min_mice NUMBER(3),
    max_mice NUMBER(3),
    MAP MEMBER FUNCTION min_and_max RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY FunctionsO AS
    MAP MEMBER FUNCTION min_and_max RETURN VARCHAR2 IS
    BEGIN
        RETURN 'more than ' || min_mice || ' and less than ' || max_mice;
    END;
END;
create table FunctionsTab OF FunctionsO(
    function CONSTRAINT oacPK_functions PRIMARY KEY,
    min_mice CONSTRAINT comain_min_mice check (min_mice >5),
    max_mice CONSTRAINT ocamax_max_mice check (max_mice<200),
    CONSTRAINT ocmin_max_maice check (max_mice>=min_mice)
);

create or replace type EnemiesO AS object(
    enemy_name VARCHAR2(15),
    hostility_degree NUMBER(2),
    species VARCHAR2(15),
    bride VARCHAR2(20),
    MAP MEMBER FUNCTION info RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY EnemiesO AS
    MAP MEMBER FUNCTION info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Name: ' || enemy_name || ' Hostility degree: ' || hostility_degree || ' Species: ' || species || ' Bride: ' || bride;
    END;
END;

create table EnemiesTab of EnemiesO(
    enemy_name CONSTRAINT occPK_Enemies PRIMARY KEY,
    hostility_degree CONSTRAINT ochcostility_degree_correct check (hostility_degree BETWEEN 1 AND 10)
);

create or replace type CatsO AS object(
    name VARCHAR2(15),
    gender VARCHAR(1),
    nickname VARCHAR(15),
    function REF FunctionsO,
    chief REF CatsO,
    in_herd_since DATE,
    mice_ration NUMBER(3),
    mice_extra NUMBER(3),
    band REF BandsO,
    MEMBER FUNCTION total_ration RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY CatsO AS
    MEMBER FUNCTION total_ration RETURN NUMBER IS
    BEGIN
        RETURN mice_ration + NVL(mice_extra, 0);
    END;
END;

create table CatsTab of CatsO(
    name CONSTRAINT occcat_name_not_null NOT NULL,
    gender CONSTRAINT ogccender_correct check (gender in ('W', 'M')),
    nickname CONSTRAINT ocPcK_Cats PRIMARY KEY,
    in_herd_since DEFAULT SYSDATE
);

create or replace type IncidentsO AS object(
    cat ref CatsO,
    enemy ref EnemiesO,
    incident_date DATE,
    incident_desc VARCHAR2(50),
    MAP MEMBER FUNCTION info RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY IncidentsO
AS
    MAP MEMBER FUNCTION info RETURN VARCHAR2
        IS
        details VARCHAR2(400);
    BEGIN
        SELECT DEREF(cat).nickname || 'VS.' || DEREF(enemy).enemy_name INTO details FROM dual; --dual
        RETURN details;
    END;
END;


create table IncidentsTab of IncidentsO(
    incident_date CONSTRAINT oacincident_date_not_null NOT NULL
);

INSERT ALL
    INTO FunctionsTab VALUES (FunctionsO('BOSS',90,110))
    INTO FunctionsTab VALUES (FunctionsO('THUG',70,90))
    INTO FunctionsTab VALUES (FunctionsO('CATCHING',60,70))
    INTO FunctionsTab VALUES (FunctionsO('CATCHER',50,60))
    INTO FunctionsTab VALUES (FunctionsO('CAT',40,50))
    INTO FunctionsTab VALUES (FunctionsO('NICE',20,30))
    INTO FunctionsTab VALUES (FunctionsO('DIVISIVE',45,55))
    INTO FunctionsTab VALUES (FunctionsO('HONORARY',6,25))
SELECT * FROM Dual;

INSERT ALL
    INTO EnemiesTab VALUES (EnemiesO('KAZIO',10,'MAN','BOTTLE'))
    INTO EnemiesTab VALUES (EnemiesO('STUPID SOPHIA',1,'MAN','BEAD'))
    INTO EnemiesTab VALUES (EnemiesO('UNRULY DYZIO',7,'MAN','CHEWING GUM'))
    INTO EnemiesTab VALUES (EnemiesO('DUN',4,'DOG','BONE'))
    INTO EnemiesTab VALUES (EnemiesO('WILD BILL',10,'DOG',NULL))
    INTO EnemiesTab VALUES (EnemiesO('REKS',2,'DOG','BONE'))
    INTO EnemiesTab VALUES (EnemiesO('BETHOVEN',1,'DOG','PEDIGRIPALL'))
    INTO EnemiesTab VALUES (EnemiesO('SLYBOOTS',5,'FOX','CHICKEN'))
    INTO EnemiesTab VALUES (EnemiesO('SLIM',1,'PINE',NULL))
    INTO EnemiesTab VALUES (EnemiesO('BASIL',3,'ROOSTER','HEN TO THE HERD'))
SELECT * FROM Dual;

INSERT ALL
    INTO BandsTab VALUES (BandsO(1,'SUPERIORS','WHOLE AREA','TIGER'))
    INTO BandsTab VALUES (BandsO(2,'BLACK KNIGHTS','FIELD','BALD'))
    INTO BandsTab VALUES (BandsO(3,'WHITE HUNTERS','ORCHARD','ZOMBIES'))
    INTO BandsTab VALUES (BandsO(4,'PINTO HUNTERS','HILLOCK','REEF'))
    INTO BandsTab VALUES (BandsO(5,'ROCKERS','FARM',NULL))
SELECT * FROM Dual;

DECLARE
    CURSOR cat_cursor IS SELECT * FROM Cats
        CONNECT BY PRIOR nickname=chief
        START WITH chief IS NULL;
        sql_string VARCHAR2(1000);
BEGIN
    FOR cat in cat_cursor
    LOOP
        sql_string:='DECLARE
            func REF FunctionsO;
            chief REF CatsO;
            band REF BandsO;
            counter NUMBER(2);
        BEGIN
            chief:=NULL;
            SELECT COUNT(*) INTO counter FROM CatsTab T WHERE T.nickname='''|| cat.chief||''';
            IF (counter>0) THEN
                SELECT REF(T) INTO chief FROM CatsTab T WHERE T.nickname='''|| cat.chief||''';
            END IF;
            
            SELECT REF(F) INTO func FROM FunctionsTab F WHERE F.function='''|| cat.function||''';
            SELECT REF(B) INTO band FROM BandsTab B WHERE B.Band_no='''|| cat.band_no ||''';
            INSERT INTO CatsTab VALUES
                    (CatsO(''' || 
                    cat.name || ''', ''' || 
                    cat.gender || ''', ''' || 
                    cat.nickname || ''', ' || 
                    'func' || ',' ||
                    'chief' || ', ''' || 
                    cat.in_herd_since ||''', ''' ||
                    cat.mice_ration ||''', ''' || 
                    cat.mice_extra ||''',' || 
                    'band' || '));
            END;';
        DBMS_OUTPUT.PUT_LINE(sql_string);
        EXECUTE IMMEDIATE sql_string;
        END LOOP;
END;

DECLARE
    CURSOR incident_cursor IS SELECT * FROM Incidents;
    sql_string VARCHAR2(1000);
BEGIN
    FOR incident in incident_cursor
    LOOP
        sql_string:='DECLARE
            cat REF CatsO;
            enemy REF EnemiesO;
        BEGIN
            SELECT REF(F) INTO cat FROM CatsTab F WHERE F.nickname='''|| incident.nickname||''';
            SELECT REF(B) INTO enemy FROM EnemiesTab B WHERE B.enemy_name='''|| incident.enemy_name ||''';
            INSERT INTO IncidentsTab VALUES
                    (IncidentsO(' || 
                    'cat' || ', ' || 
                    'enemy' || ', ''' || 
                    incident.incident_date ||''', ''' || 
                    incident.incident_desc ||'''));
            END;';
        DBMS_OUTPUT.PUT_LINE(sql_string);
        EXECUTE IMMEDIATE sql_string;
        END LOOP;
END;
COMMIT;

#JOIN AND TYPE FUNCTION
SELECT E.nickname , DEREF(E.function).min_and_max() "Min and max for their function"
FROM CatsTab E;

#JOIN AND GROUPING
SELECT DEREF(C.function).function, SUM(C.total_ration()) "Total Ration"
FROM CatsTab C
GROUP BY C.function;

#OWN EXAMPLE
SELECT nickname, c1.total_ration() "Eats"
FROM CatsTab c1
WHERE c1.total_ration() IN (
    SELECT *
    FROM (
        SELECT c2.total_ration() "Eats"
        FROM CatsTab c2
        GROUP BY c2.total_ration()
        ORDER BY "Eats" DESC
    )
    WHERE ROWNUM <= 6
)
ORDER BY c1.total_ration() DESC;

#TASK 27c
SELECT c1.nickname, MAX(c1.total_ration()) "Eats"
FROM CatsTab c1, CatsTab c2
WHERE (c1.total_ration()) <=
      (c2.total_ration())
GROUP BY c1.nickname
HAVING COUNT(DISTINCT c2.total_ration()) < 7
ORDER BY "Eats" DESC;

#SUBQUERY AND TASK 25 
SELECT name, Deref(function).function, mice_ration
FROM CatsTab
WHERE mice_ration >= (
    SELECT mice_ration 
    FROM (SELECT * FROM CatsTab ORDER BY mice_ration DESC)
    WHERE DEREF(band).site IN ('ORCHARD', 'WHOLE AREA') AND ROWNUM=1 AND Deref(function).function = 'NICE') *3

#TASK 35
DECLARE 
    cat_name CatsTab.name%TYPE;
    cat_ration NUMBER;
    cat_join_month NUMBER;
    cat_found BOOLEAN DEFAULT FALSE;
BEGIN
    SELECT c.name, (c.total_ration())*12, EXTRACT(MONTH FROM c.in_herd_since)
    INTO cat_name, cat_ration, cat_join_month
    FROM CatsTab c
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

#TASK 37
DECLARE 
    CURSOR top_5_cats IS
        SELECT nickname, c.total_ration() eats
        FROM CatsTab c
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

#TASK 49
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE MICE(
    mouse_id NUMBER(7) CONSTRAINT mice_pk PRIMARY KEY,
    hunter VARCHAR2(15) CONSTRAINT mice_hunter_fk REFERENCES Cats(nickname),
    eater VARCHAR2(15) CONSTRAINT mice_eater_fk REFERENCES Cats(nickname),
    mouse_weight NUMBER(3) CONSTRAINT mice_weight CHECK (mouse_weight BETWEEN 10 AND 20),
    catch_date DATE,
    release_date DATE,
    CONSTRAINT dates_check CHECK (catch_date <= release_date))';
END;

ALTER SESSION SET NLS_DATE_FORMAT ='YYYY-MM-DD'

CREATE SEQUENCE mice_ids;

DECLARE
    date_begin DATE := '2004-01-01';
    last_wednesday_date DATE := NEXT_DAY(LAST_DAY(date_begin) - 7, 'WEDNESDAY');
    date_last DATE := '2023-01-25';
    mice_monthly NUMBER(5);
    TYPE tn IS TABLE OF Cats.nickname%TYPE;
    nicknames_table tn := tn();
    TYPE tm IS TABLE OF NUMBER(4);
    mice_table tm := tm();
    TYPE mice_table_raw IS TABLE OF Mice%ROWTYPE INDEX BY BINARY_INTEGER;
    mouses mice_table_raw;
    mouse_id BINARY_INTEGER := 0;
    eater_id NUMBER(2);
BEGIN
    LOOP
        EXIT WHEN date_begin >= date_last;

            IF date_begin < NEXT_DAY(LAST_DAY(date_begin), 'WEDNESDAY') - 7 THEN
                last_wednesday_date := LEAST(NEXT_DAY(LAST_DAY(date_begin), 'WEDNESDAY') - 7, date_last);
            ELSE
                last_wednesday_date :=
                        LEAST(NEXT_DAY(LAST_DAY(ADD_MONTHS(date_begin, 1)), 'WEDNESDAY') - 7, date_last);
            END IF;

            SELECT SUM(mice_ration, 0 + NVL(mice_extra, 0))
            INTO mice_monthly
            FROM Cats
            WHERE in_herd_since < last_wednesday_date;

            SELECT 
                nickname,
                mice_ration, 0 + NVL(mice_extra, 0)
                BULK COLLECT INTO nicknames_table, mice_table
            FROM Cats
            WHERE in_herd_since < last_wednesday_date;

            eater_id := 1;
            mice_monthly := CEIL(mice_monthly / nicknames_table.COUNT);

            FOR i IN 1..(mice_monthly * nicknames_table.COUNT)
                LOOP
                    mouse_id := mouse_id + 1;
                    mouses(mouse_id).mouse_id := mouse_id;
                    mouses(mouse_id).hunter := nicknames_table(MOD(i, nicknames_table.COUNT) + 1);
                    IF last_wednesday_date != date_last THEN
                        mouses(mouse_id).release_date := last_wednesday_date;
                        IF mice_table(eater_id) = 0 THEN
                            eater_id := eater_id + 1;
                        ELSE
                            mice_table(eater_id) := mice_table(eater_id) - 1;
                        end if;
                        IF eater_id > mice_table.COUNT THEN
                            eater_id := DBMS_RANDOM.VALUE(1, mice_table.COUNT);
                        end if;
                        mouses(mouse_id).eater := nicknames_table(eater_id);
                    end if;
                    mouses(mouse_id).mouse_weight := DBMS_RANDOM.VALUE(10, 20);
                    mouses(mouse_id).catch_date := date_begin + MOD(mouse_id, TRUNC(last_wednesday_date) - TRUNC(date_begin));
                end loop;
                date_begin := last_wednesday_date + 1;
                last_wednesday_date := NEXT_DAY(LAST_DAY(ADD_MONTHS(date_begin, 1)) - 7, 'WEDNESDAY');
            IF last_wednesday_date > date_last THEN
                last_wednesday_date := date_last;
            end if;
    END LOOP;

    FORALL i in 1..mouses.COUNT
        INSERT INTO Mice(mouse_id, hunter, eater, mouse_weight, catch_date, release_date)
        VALUES (mice_ids.NEXTVAL, mouses(i).hunter, mouses(i).eater, mouses(i).mouse_weight, mouses(i).catch_date, mouses(i).release_date);
END;

SELECT * FROM MICE;

SELECT  * FROM Mice WHERE EXTRACT(MONTH FROM catch_date)=1 AND EXTRACT(YEAR FROM catch_date) = 2023;

BEGIN
   FOR cat in (SELECT nickname FROM Cats)
    LOOP
       EXECUTE IMMEDIATE 'CREATE TABLE mice_caught_by_' || cat.nickname || '(' ||
           'mouse_id NUMBER(7) CONSTRAINT mice_caught_by_pk_' || cat.nickname || ' PRIMARY KEY,' ||
           'mouse_weight NUMBER(3) CONSTRAINT mice_weigth_' || cat.nickname || ' CHECK (mouse_weight BETWEEN 5 AND 15),' ||
           'catch_date DATE)' ;
       END LOOP;
END;


CREATE OR REPLACE PROCEDURE store_caught_mice(cat_nickname Cats.nickname%TYPE, catch_date DATE)
AS
    TYPE tmice IS TABLE OF NUMBER(3);
        table_weight tmice := tmice();
    TYPE tn IS TABLE OF NUMBER(7);
        table_no tn := tn();
    num_of_cats NUMBER(2);
BEGIN
    IF catch_date > SYSDATE  OR catch_date = NEXT_DAY(LAST_DAY(catch_date)-7, 'WEDNESDAY')
        raise_application_error(-20001,'invalid date');
    END IF;
    SELECT COUNT(c.nickname) INTO num_of_cats FROM Cats c  WHERE c.nickname = UPPER(cat_nickname);
    IF num_of_cats = 0 THEN 
        raise_application_error(-20001,'cat doesnt exist'); 
    END IF;
    EXECUTE IMMEDIATE 'SELECT mouse_id, mouse_weight FROM mice_caught_by_'|| cat_nickname || ' WHERE catch_date= ''' || catch_date || ''''
        BULK COLLECT INTO table_no, table_weight;
    IF table_no.COUNT = 0 THEN
       raise_application_error(-20001,'no mice caught then');
    END IF;
    FORALL i in 1..table_no.COUNT
        INSERT INTO Mice VALUES (table_no(i), UPPER(cat_nickname), NULL, table_weight(i), catch_date, NULL);
    EXECUTE IMMEDIATE 'DELETE FROM mice_caught_by_' || cat_nickname || ' WHERE catch_date= ''' || catch_date || '''';
END;

CREATE OR REPLACE PROCEDURE payment
AS
    TYPE tn IS TABLE OF Cats.nickname%TYPE;
        nicknames_table tn := tn();
    TYPE tm is TABLE OF NUMBER(4);
        mice_table tm := tm();
    TYPE tno IS TABLE OF NUMBER(7);
        table_no tno := tno();
    TYPE te IS TABLE OF Cats.nickname%TYPE INDEX BY BINARY_INTEGER;
        table_eater te;
    TYPE tmice IS TABLE OF Mice%ROWTYPE;
        mice_table_raw tmice;
    num_of_not_eaten NUMBER(2) := 0;
    eater_id NUMBER(2) := 1;
    counter NUMBER(5);
    repeated_release_exception EXCEPTION;
BEGIN
    SELECT nickname, mice_ration + NVL(mice_extra, 0)
        BULK COLLECT INTO nicknames_table, mice_table
    FROM Cats CONNECT BY PRIOR nickname = chief
    START WITH chief IS NULL
    ORDER BY level;

    SELECT COUNT(mouse_id)
        INTO counter
    FROM MICE
    WHERE release_date = NEXT_DAY(LAST_DAY(TRUNC(SYSDATE))-7, 'WEDNESDAY');
    DBMS_OUTPUT.PUT_LINE('counter: '||counter);
    IF counter > 0 THEN
        RAISE repeated_release_exception;
    END IF;
    SELECT * BULK COLLECT INTO mice_table_raw
    FROM Mice
    WHERE release_date IS NULL;
    FOR i IN 1..mice_table_raw.COUNT
        LOOP
            WHILE mice_table(eater_id) = 0 AND num_of_not_eaten < nicknames_table.COUNT
                LOOP
                    num_of_not_eaten := num_of_not_eaten + 1;
                    eater_id := MOD(eater_id + 1, nicknames_table.COUNT) + 1;
                END LOOP;
            IF num_of_not_eaten = nicknames_table.COUNT THEN
                table_eater(i) := 'TIGER';
            ELSE
                eater_id := MOD(eater_id + 1, nicknames_table.COUNT) + 1;
                table_eater(i) := nicknames_table(eater_id);
                mice_table(eater_id) := mice_table(eater_id) - 1;
            end if;

            IF NEXT_DAY(LAST_DAY(mice_table_raw(i).catch_date)-7, 'WEDNESDAY') < mice_table_raw(i).catch_date THEN
                mice_table_raw(i).release_date := NEXT_DAY(LAST_DAY(ADD_MONTHS(mice_table_raw(i).catch_date,1))-7, 'WEDNESDAY');
            ELSE
                mice_table_raw(i).release_date := NEXT_DAY(LAST_DAY(mice_table_raw(i).catch_date)-7, 'WEDNESDAY');
            end if;
        END LOOP;
    FORALL i IN 1..mice_table_raw.COUNT
            UPDATE Mice SET release_date=mice_table_raw(i).release_date , eater=table_eater(i)
            WHERE mouse_id=mice_table_raw(i).mouse_id;
    EXCEPTION
            WHEN repeated_release_exception THEN DBMS_OUTPUT.PUT_LINE('Repeated release');
END;


INSERT INTO mice_caught_by_MISS VALUES(mice_ids.nextval, 13, '2022-12-28');

BEGIN
    store_caught_mice('MISS', '2022-12-28');
end;


SELECT COUNT(mouse_id)
FROM MICE
WHERE release_date = NEXT_DAY(LAST_DAY(TRUNC(SYSDATE))-7, 'WEDNESDAY');


SELECT COUNT(mouse_id)
FROM MICE
WHERE TO_CHAR(release_date) = TO_CHAR(NEXT_DAY(LAST_DAY(SYSDATE)-7, 'WEDNESDAY'));


SELECT
TO_CHAR(NEXT_DAY(LAST_DAY(SYSDATE)-7, 'WEDNESDAY'))
FROM DUAL;

BEGIN
    payment();
END;

SELECT * FROM mice_caught_by_MISS;
SELECT COUNT(*) FROM Mice WHERE EXTRACT(YEAR FROM release_date)=2022 AND eater!='MISS';
SELECT * FROM Mice WHERE release_date IS NULL;

SELECT * FROM Mice;

ROLLBACK;

-- Clearing the data
BEGIN
    FOR cat IN (SELECT nickname FROM Cats)
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE mice_caught_by_' || cat.nickname;
        END LOOP;
END;
/

TRUNCATE TABLE MICE;
DROP SEQUENCE mice_ids;
DROP TABLE Mice;
DROP PROCEDURE store_caught_mice;
DROP PROCEDURE payment;