
create table Bands(
    Band_no NUMBER(2) CONSTRAINT PK_Band_no PRIMARY KEY,
    name VARCHAR2(20) CONSTRAINT band_name_not_null NOT NULL,
    site VARCHAR2(15) CONSTRAINT site_unique unique,
    band_chief VARCHAR2(15) CONSTRAINT band_chief_unique unique
);

create table Functions(
    function varchar2(10) CONSTRAINT PK_functions PRIMARY KEY,
    min_mice NUMBER(3) CONSTRAINT min_min_mice check (min_mice >5),
    max_mice NUMBER(3) CONSTRAINT max_max_mice check (max_mice<200),
    CONSTRAINT min_max_mice check (max_mice>=min_mice)
);

create table Enemies(
    enemy_name VARCHAR2(15) CONSTRAINT PK_Enemies PRIMARY KEY,
    hostility_degree NUMBER(2) CONSTRAINT hostility_degree_correct check (hostility_degree BETWEEN 1 AND 10),
    species VARCHAR2(15),
    bride VARCHAR2(20)
);

create table Cats(
    name VARCHAR2(15) CONSTRAINT cat_name_not_null NOT NULL,
    gender VARCHAR(1) CONSTRAINT gender_correct check (gender in ('W', 'M')),
    nickname VARCHAR(15) CONSTRAINT PK_Cats PRIMARY KEY,
    function VARCHAR2(10) CONSTRAINT FK_function REFERENCES Functions(function),
    chief VARCHAR2(15) CONSTRAINT FK_chief REFERENCES Cats(nickname),
    in_herd_since DATE DEFAULT SYSDATE,
    mice_ration NUMBER(3),
    mice_extra NUMBER(3),
    band_no NUMBER(2) CONSTRAINT FK_band_no REFERENCES Bands(band_no)
);

create table Incidents(
    nickname VARCHAR2(15) CONSTRAINT FK_Nickname REFERENCES Cats(nickname),
    enemy_name VARCHAR2(15) CONSTRAINT FK_Enemy_name REFERENCES Enemies(enemy_name),
    incident_date DATE CONSTRAINT incident_date_not_null NOT NULL,
    incident_desc VARCHAR2(50),
    CONSTRAINT PK_Incident PRIMARY KEY (nickname, enemy_name)
);
INSERT ALL
    INTO Functions VALUES ('BOSS',90,110)
    INTO Functions VALUES ('THUG',70,90)
    INTO Functions VALUES ('CATCHING',60,70)
    INTO Functions VALUES ('CATCHER',50,60)
    INTO Functions VALUES ('CAT',40,50)
    INTO Functions VALUES ('NICE',20,30)
    INTO Functions VALUES ('DIVISIVE',45,55)
    INTO Functions VALUES ('HONORARY',6,25)
SELECT * FROM Dual;

INSERT ALL
    INTO Enemies VALUES ('KAZIO',10,'MAN','BOTTLE')
    INTO Enemies VALUES ('STUPID SOPHIA',1,'MAN','BEAD')
    INTO Enemies VALUES ('UNRULY DYZIO',7,'MAN','CHEWING GUM')
    INTO Enemies VALUES ('DUN',4,'DOG','BONE')
    INTO Enemies VALUES ('WILD BILL',10,'DOG',NULL)
    INTO Enemies VALUES ('REKS',2,'DOG','BONE')
    INTO Enemies VALUES ('BETHOVEN',1,'DOG','PEDIGRIPALL')
    INTO Enemies VALUES ('SLYBOOTS',5,'FOX','CHICKEN')
    INTO Enemies VALUES ('SLIM',1,'PINE',NULL)
    INTO Enemies VALUES ('BASIL',3,'ROOSTER','HEN TO THE HERD')
SELECT * FROM Dual;

INSERT ALL
    INTO Bands VALUES (1,'SUPERIORS','WHOLE AREA','TIGER')
    INTO Bands VALUES (2,'BLACK KNIGHTS','FIELD','BALD')
    INTO Bands VALUES (3,'WHITE HUNTERS','ORCHARD','ZOMBIES')
    INTO Bands VALUES (4,'PINTO HUNTERS','HILLOCK','REEF')
    INTO Bands VALUES (5,'ROCKERS','FARM',NULL)
SELECT * FROM Dual;

INSERT ALL
    INTO Cats VALUES ('MRUCZEK','M','TIGER','BOSS',NULL, DATE '2002-01-01',103,33,1)
    INTO Cats VALUES ('BOLEK','M','BALD','THUG','TIGER', DATE '2006-08-15',72,21,2)
    INTO Cats VALUES ('KOREK','M','ZOMBIES','THUG','TIGER', DATE '2004-03-16',75,13,3)
    INTO Cats VALUES ('PUNIA','W','HEN','CATCHING','ZOMBIES', DATE '2008-01-01',61,NULL,3)
    INTO Cats VALUES ('PUCEK','M','REEF','CATCHING','TIGER', DATE '2006-10-15',65,NULL,4)
    INTO Cats VALUES ('JACEK','M','CAKE','CATCHING','BALD', DATE '2008-12-01',67,NULL,2)
    INTO Cats VALUES ('BARI','M','TUBE','CATCHER','BALD', DATE '2009-09-01',56,NULL,2)
    INTO Cats VALUES ('MICKA','W','LOLA','NICE','TIGER', DATE '2009-10-14',25,47,1)
    INTO Cats VALUES ('LUCEK','M','ZERO','CAT','HEN', DATE '2010-03-01',43,NULL,3)
    INTO Cats VALUES ('SONIA','W','FLUFFY','NICE','ZOMBIES', DATE '2010-11-18',20,35,3)
    INTO Cats VALUES ('LATKA','W','EAR','CAT','REEF', DATE '2011-01-01',40,NULL,4)
    INTO Cats VALUES ('DUDEK','M','SMALL','CAT','REEF', DATE '2011-05-15',40,NULL,4)
    INTO Cats VALUES ('CHYTRY','M','BOLEK','DIVISIVE','TIGER', DATE '2002-05-05',50,NULL,1)
    INTO Cats VALUES ('ZUZIA','W','FAST','CATCHING','BALD', DATE '2006-07-21',65,NULL,2)
    INTO Cats VALUES ('RUDA','W','LITTLE','NICE','TIGER', DATE '2006-09-17',22,42,1)
    INTO Cats VALUES ('BELA','W','MISS','NICE','BALD', DATE '2008-02-01',24,28,2)
    INTO Cats VALUES ('KSAWERY','M','MAN','CATCHER','REEF', DATE '2008-07-12',51,NULL,4)
    INTO Cats VALUES ('MELA','W','LADY','CATCHER','REEF', DATE '2008-11-01',51,NULL,4)
SELECT * FROM Dual;

ALTER TABLE Bands ADD CONSTRAINT FK_band_chief FOREIGN KEY (band_chief) REFERENCES Cats(nickname);

INSERT ALL
    INTO Incidents VALUES ('TIGER','KAZIO', DATE '2004-10-13','HE HAS TRYING TO STICK ON THE FORK')
    INTO Incidents VALUES ('ZOMBIES', 'UNRULY DYZIO', DATE '2005-03-07','HE FOOTED AN EYE FROM PROCAST')
    INTO Incidents VALUES ('BOLEK','KAZIO', DATE '2005-03-29','HE CLEANED DOG')
    INTO Incidents VALUES ('FAST', 'STUPID SOPHIA' , DATE '2006-09-12','SHE USED THE CAT AS A CLOTH')
    INTO Incidents VALUES ('LITTLE','SLYBOOTS', DATE '2007-03-07','HE RECOMMENDED HIMSELF AS A HUSBAND')
    INTO Incidents VALUES ('TIGER','WILD BILL', DATE '2007-06-12','HE TRIED TO KILL')
    INTO Incidents VALUES ('BOLEK','WILD BILL', DATE '2007-11-10','HE BITE THE EAR')
    INTO Incidents VALUES ('MISS','WILD BILL', DATE '2008-12-12','HE BITCHED')
    INTO Incidents VALUES ('MISS','KAZIO', DATE '2009-01-07','HE CAUGHT THE TAIL AND MADE A WIND')
    INTO Incidents VALUES ('LADY','KAZIO', DATE '2009-02-07','HE WANTED TO SKIN OFF')
    INTO Incidents VALUES ('MAN','REKS', DATE '2009-04-14','HE BARKED EXTREMELY RUDELY')
    INTO Incidents VALUES ('BALD','BETHOVEN', DATE '2009-05-11','HE DID NOT SHARE THE PORRIDGE')
    INTO Incidents VALUES ('TUBE','WILD BILL', DATE '2009-09-03','HE TOOK THE TAIL')
    INTO Incidents VALUES ('CAKE','BASIL', DATE '2010-07-12','HE PREVENTED THE CHICKEN FROM BEING HUNTED')
    INTO Incidents VALUES ('FLUFFY','SLIM', DATE '2010-11-19','SHE THREW CONES')
    INTO Incidents VALUES ('HEN','DUN', DATE '2010-12-14','HE CHASED')
    INTO Incidents VALUES ('SMALL','SLYBOOTS', DATE '2011-07-13','HE TOOK THE STOLEN EGGS')
    INTO Incidents VALUES ('EAR', 'UNRULY DYZIO', DATE '2011-07-14','HE THREW STONES')
SELECT * FROM Dual;

#TASK 17
SELECT nickname







#TASK 1
SELECT enemy_name AS "Enemy", incident_desc AS "Fault description" from Incidents where EXTRACT(year from incident_date)=2009;

#TASK 2
SELECT name "NAME", function "Function", in_herd_since "WITH AS FROM" from Cats where in_herd_since BETWEEN DATE '2005-09-01' AND DATE '2007-07-31' AND gender='W';

#TASK 3
SELECT enemy_name "ENEMY", species "SPECIES", hostility_degree "HOSTILITY DEGREE" from Enemies WHERE bride is NULL ORDER BY hostility_degree ASC;

#TASK 4
SELECT (name || ' called ' || nickname || ' (fun. ' || function || ') has been catching mice in band ' || band_no || ' since ' || in_herd_since) "ALL_ABOUT_MALE_CATS" from Cats WHERE GENDER='M' ORDER BY in_herd_since DESC, nickname;

#TASK 5
SELECT nickname as "NICKNAME", REGEXP_REPLACE(REGEXP_REPLACE(nickname, 'A', '#', 1, 1), 'L', '%', 1, 1) FROM Cats WHERE nickname LIKE '%A%' AND nickname LIKE '%L%';

#TASK 6
SELECT name "NAME", in_herd_since "In herd", FLOOR(mice_ration/1.1) "Ate", ADD_MONTHS(in_herd_since, 6) "Increase", mice_ration "Eat" FROM Cats 
WHERE 
EXTRACT(MONTH FROM in_herd_since) BETWEEN 3 AND 9 AND 
EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM in_herd_since)>=11;

#TASK 7
SELECT name "NAME", (mice_ration*3) "MICE QUARTERLY", 
NVL(mice_extra,0)*3 "EXTRA QUARTERLY" 
FROM Cats 
WHERE mice_ration>=55 AND (mice_ration>mice_extra*2 OR mice_extra is NULL);

#TASK 8
SELECT name "NAME", 
CASE 
WHEN mice_ration*12 + NVL(mice_extra,0)*12<660 THEN 'BELOW 660' 
WHEN mice_ration*12 + NVL(mice_extra,0)*12=660 THEN 'Limit' 
ELSE TO_CHAR(mice_ration*12+NVL(mice_extra,0)*12) 
END "Eats annually" 
FROM Cats;

#TASK 9
SELECT nickname "NICKNAME", in_herd_since "IN HERD",
CASE
WHEN EXTRACT(DAY FROM in_herd_since) <=15 AND NEXT_DAY(LAST_DAY(DATE '2020-10-27') - 7, 'WEDNESDAY')>DATE '2020-10-27'
THEN NEXT_DAY(LAST_DAY(DATE '2020-10-27') - 7, 'WEDNESDAY')
ELSE NEXT_DAY(LAST_DAY(ADD_MONTHS(DATE '2020-10-27', 1)) - 7, 'WEDNESDAY')
END "PAYMENT"
FROM Cats;

#TASK 10
SELECT (nickname || ' - ' || NVL2(NULLIF(COUNT(nickname), 1), 'unique', 'non-unique')) "Uniqueness of the nickname"
FROM Cats
GROUP BY nickname;

SELECT (chief || ' - ' || NVL2(NULLIF(COUNT(chief), 1), 'unique', 'non-unique')) "Uniqueness of the nickname"
FROM Cats
GROUP BY chief
HAVING chief is NOT NULL;

#TASK 11
SELECT nickname, COUNT(nickname) "Number of enemies"
FROM Incidents
GROUP BY nickname
HAVING COUNT(nickname)>=2;

#TASK 12
SELECT 'Number of cats= ' || COUNT(function) || ' hunts as ' || function || ' and eats max. ' ||
MAX(mice_ration + NVL(mice_extra, 0)) || ' mice per month'
FROM Cats WHERE gender='W' AND function!='BOSS'
GROUP BY function
HAVING AVG(mice_ration + NVL(mice_extra, 0))>50;

#TASK 13
SELECT band_no "Band No", gender "Gender", MIN(mice_ration) "Minimum ration"
FROM Cats
GROUP BY band_no, gender;

#TASK 14
SELECT LEVEL "Level", nickname "Nickname", function "Function", band_no "Band No"
FROM Cats
WHERE Gender = 'M'
START WITH function = 'THUG' 
CONNECT BY chief = PRIOR nickname;

#TASK 15
SELECT (LPAD(TO_CHAR(LEVEL - 1), (LEVEL - 1) * 4 + LENGTH(TO_CHAR(LEVEL - 1)), '===>') || '           ' || name) "Hierarchy" , NVL(chief, 'Master yourself') "Nickname of the chief", function "Function"
FROM Cats
START WITH function='BOSS'
CONNECT BY chief = PRIOR nickname AND mice_extra IS NOT NULL;

#TASK 16
SELECT (LPAD(' ', (LEVEL - 1) * 4 + LENGTH(TO_CHAR(LEVEL - 1)), ' ') || 
nickname) "Path of chiefs"
FROM Cats
START WITH gender = 'M' AND EXTRACT(YEAR FROM CURRENT_DATE)-EXTRACT(YEAR FROM in_herd_since)>11 AND mice_extra IS NULL
CONNECT BY PRIOR chief =  nickname;

#TASK 17
SELECT nickname "Hunts in the field", mice_ration "Ration of mice", Bands.name "Band"
From Cats
LEFT JOIN Bands ON Cats.band_no = Bands.band_no
WHERE mice_ration>50 AND site in ('FIELD', 'WHOLE AREA');

#TASK 18
SELECT C1.name "Name", C1.in_herd_since "Hunts since"
FROM Cats C1, CATS C2
WHERE C2.name='JACEK' AND C1.in_herd_since < C2.in_herd_since
ORDER by C1.in_herd_since DESC;

#TASK 19a
SELECT C.name "Name", C.function "Function", NVL(C1.name, ' ') "Chief 1", NVL(C2.name, ' ') "Chief 2", NVL(C3.name, ' ') "Chief 3"
FROM Cats C
LEFT JOIN Cats C1 on C.chief = C1.nickname
LEFT JOIN Cats C2 on C1.chief = C2.nickname
LEFT JOIN Cats C3 on C2.chief = C3.nickname
WHERE C.function in ('CAT', 'NICE');

#TASK 19b
SELECT mainname "Name", mainfunction "Function", NVL(chief1, ' ') "Chief 1", NVL(chief2, ' ') "Chief 2", NVL(chief3, ' ') "Chief 3"
FROM (
    SELECT CONNECT_BY_ROOT name mainname, CONNECT_BY_ROOT function mainfunction, LEVEL lvl, name
    FROM Cats
    CONNECT BY PRIOR chief = nickname   
    START WITH function in ('CAT', 'NICE')
)
PIVOT(MIN(name) FOR lvl IN (2 chief1, 3 chief2, 4 chief3));

#TASK 19c
SELECT mainname, mainfunction, MAX(chiefs) "Names of subsequent chiefs"
FROM (
    SELECT CONNECT_BY_ROOT name mainname, CONNECT_BY_ROOT function mainfunction, SYS_CONNECT_BY_PATH(RPAD(name, 10), ' | ') chiefs
        FROM Cats
    CONNECT BY PRIOR chief = nickname   
    START WITH function in ('CAT', 'NICE')
)
GROUP BY mainname, mainfunction;

#TASK 20
SELECT Cats.name "name", Bands.name "Band name", Enemies.enemy_name, Enemies.hostility_degree, Incidents.incident_date
FROM Cats
LEFT JOIN Bands ON Cats.band_no = Bands.band_no
LEFT JOIN Incidents ON Cats.nickname = Incidents.nickname
LEFT JOIN Enemies ON Incidents.enemy_name = Enemies.enemy_name
WHERE incident_date> DATE '2007-01-01' AND gender = 'W'

#TASK 21
SELECT Bands.name, COUNT(DISTINCT Incidents.nickname)
FROM Bands
RIGHT JOIN Cats ON Cats.band_no = Bands.band_no
RIGHT JOIN Incidents ON Cats.nickname = Incidents.nickname
GROUP BY Bands.name;

#TASK 22
SELECT Cats.function, Cats.nickname, COUNT(Cats.nickname) "Number of enemies"
FROM Cats
LEFT JOIN Incidents on Cats.nickname = Incidents.nickname
GROUP BY Cats.function, Cats.nickname
HAVING COUNT(Cats.nickname)>1;

#TASK 23
SELECT name, 12 * (mice_ration + mice_extra) "Annual Dose", 'Over 864' "Dose"
FROM Cats
WHERE mice_extra is not null AND 12 * (mice_ration + mice_extra)>864
UNION ALL
SELECT name, 12 * (mice_ration + mice_extra) "Annual Dose", '864' "Dose"
FROM Cats
WHERE mice_extra is not null AND 12 * (mice_ration + mice_extra)=864
UNION ALL
SELECT name, 12 * (mice_ration + mice_extra) "Annual Dose", 'under 864' "Dose"
FROM Cats
WHERE mice_extra is not null AND 12 * (mice_ration + mice_extra)<864
ORDER BY "Annual Dose" DESC;

#TASK 24 no set operator
SELECT Bands.band_no, Bands.name, Bands.site
FROM Bands
LEFT JOIN Cats ON Bands.band_no=Cats.band_no
WHERE nickname is NULL

#TASK 24 set operator
SELECT Bands.band_no, Bands.name, Bands.site
FROM Bands
LEFT JOIN Cats ON Bands.band_no=Cats.band_no
MINUS
SELECT Bands.band_no, Bands.name, Bands.site
FROM Bands
RIGHT JOIN Cats ON Bands.band_no=Cats.band_no;

#TASK 25
SELECT name, function, mice_ration
FROM Cats
WHERE mice_ration >= (
    SELECT mice_ration 
    FROM (SELECT * FROM Cats ORDER BY mice_ration DESC)
    LEFT JOIN Bands ON Cats.band_no = Bands.band_no 
    WHERE site IN ('ORCHARD', 'WHOLE AREA') AND ROWNUM=1 AND function = 'NICE') *3

#TASK 26
SELECT function, ROUND(AVG(mice_ration+NVL(mice_extra, 0))) "Average min and max mice"
FROM Cats 
GROUP BY function
HAVING AVG(mice_ration+NVL(mice_extra, 0)) IN (
    (SELECT MAX(AVG(mice_ration+NVL(mice_extra, 0)))
    FROM Cats 
    WHERE function <> 'BOSS'
    GROUP BY function),
    (SELECT MIN(AVG(mice_ration+NVL(mice_extra, 0)))
    FROM Cats 
    WHERE function <> 'BOSS'
    GROUP BY function));

#TASK 27a
SELECT nickname, mice_ration+NVL(mice_extra, 0) "Eats"
FROM Cats C
WHERE (
    SELECT COUNT(DISTINCT mice_ration+NVL(mice_extra, 0))
    FROM Cats
    WHERE (mice_ration+NVL(mice_extra, 0)) >
              ( C.mice_ration+NVL(C.mice_extra, 0))
)<6
ORDER BY mice_ration+NVL(mice_extra, 0) DESC

#TASK 27b
SELECT nickname, mice_ration+NVL(mice_extra, 0) "Eats"
FROM Cats
WHERE mice_ration+NVL(mice_extra, 0) IN (
    SELECT *
    FROM (
        SELECT mice_ration+NVL(mice_extra, 0) "Eats"
        FROM Cats 
        GROUP BY (mice_ration+NVL(mice_extra, 0))
        ORDER BY "Eats" DESC
    )
    WHERE ROWNUM <= 6
)
ORDER BY mice_ration+NVL(mice_extra, 0) DESC;

#TASK 27c
SELECT c1.nickname, MAX(c1.mice_ration+NVL(c1.mice_extra, 0)) "Eats"
FROM Cats c1, Cats c2
WHERE (c1.mice_ration+NVL(c1.mice_extra, 0)) <=
      (c2.mice_ration+NVL(c2.mice_extra, 0))
GROUP BY c1.nickname
HAVING COUNT(DISTINCT c2.mice_ration+NVL(c2.mice_extra, 0)) < 7
ORDER BY "Eats" DESC;

#TASK 28
SELECT TO_CHAR(EXTRACT(YEAR FROM in_herd_since)) year,
       COUNT(*) "Number of entries"
FROM Cats
GROUP BY EXTRACT(YEAR FROM in_herd_since)
HAVING COUNT(*) IN (
    (
        SELECT MIN(COUNT(*))
        FROM Cats
        GROUP BY EXTRACT(YEAR FROM in_herd_since)
        HAVING COUNT(*) > (
            SELECT AVG(COUNT(*))
                FROM Cats
                GROUP BY EXTRACT(YEAR FROM in_herd_since)
            )
    ),
    (
        SELECT MAX(COUNT(*))
        FROM Cats
        GROUP BY EXTRACT(YEAR FROM in_herd_since)
        HAVING COUNT(*) < (
            SELECT AVG(COUNT(*))
                FROM Cats
                GROUP BY EXTRACT(YEAR FROM in_herd_since)
            )
    )
)
UNION ALL
SELECT 'Average' year, ROUND(AVG(COUNT(*)), 7) "Number of entries"
FROM Cats
GROUP BY EXTRACT(YEAR FROM in_herd_since)
ORDER BY "Number of entries";

#TASK 29a
SELECT c1.name, c1.mice_ration+NVL(c1.mice_extra, 0) "Eats", c1.band_no, AVG(c2.mice_ration+NVL(c2.mice_extra, 0))
FROM Cats c1 LEFT JOIN Cats c2 ON c1.band_no=c2.band_no
WHERE c1.gender='M'
GROUP BY c1.name, c1.mice_ration, c1.mice_extra, c1.band_no
HAVING (c1.mice_ration+NVL(c1.mice_extra, 0)) <=
       AVG(c2.mice_ration+NVL(c2.mice_extra, 0));

#TASK 29b
SELECT name, mice_ration+NVL(mice_extra, 0) "Eats", band_no, average "Average"
FROM (Select band_no, AVG(mice_ration+NVL(mice_extra, 0)) average
    FROM Cats
    GROUP by band_no)
JOIN Cats using (band_no)
WHERE mice_ration+NVL(mice_extra, 0)<average AND gender = 'M'

#TASK 29c
SELECT name, mice_ration+NVL(mice_extra, 0) "Eats", band_no, 
(SELECT AVG(mice_ration+NVL(mice_extra, 0)) FROM Cats WHERE band_no = C.band_no) "Average"
FROM Cats C
WHERE gender='M' AND mice_ration+NVL(mice_extra, 0)<(SELECT AVG(mice_ration+NVL(mice_extra, 0)) FROM Cats WHERE band_no = C.band_no);

#TASK 30
SELECT C.name, C.in_herd_since, '<--- SHORTEST TIME IN THE BAND ' || B.name " "
FROM Cats C LEFT JOIN Bands B on C.band_no=B.band_no
WHERE C.in_herd_since = (SELECT MAX(in_herd_since) FROM Cats WHERE C.band_no=band_no)
UNION ALL
SELECT C.name, C.in_herd_since, '<--- LONGEST TIME IN THE BAND ' || B.name
FROM Cats C LEFT JOIN Bands B on C.band_no=B.band_no
WHERE C.in_herd_since = (SELECT MIN(in_herd_since) FROM Cats WHERE C.band_no=band_no)
UNION ALL
SELECT C.name, C.in_herd_since, ' '
FROM Cats C
WHERE C.in_herd_since NOT IN ((SELECT MIN(in_herd_since) FROM Cats WHERE C.band_no=band_no),(SELECT MAX(in_herd_since) FROM Cats WHERE C.band_no=band_no))

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

#TASK 40 + 44
CREATE OR REPLACE PACKAGE PACK IS
    FUNCTION get_tax(cat_nickname CATS.NICKNAME%TYPE) RETURN NUMBER;
    PROCEDURE  AddBand(no_band Bands.band_no%TYPE,
                                    name_band Bands.name%TYPE,
                                    hunt_site Bands.site%TYPE);
END PACK;

CREATE OR REPLACE PACKAGE BODY PACK IS
    FUNCTION get_tax(cat_nickname CATS.NICKNAME%TYPE) RETURN NUMBER
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
            FROM CATS
            WHERE chief = cat_nickname;
            IF counter = 0 THEN
                tax := tax + 2;
            END IF;
            SELECT COUNT(nickname) INTO counter FROM INCIDENTS WHERE nickname = cat_nickname;
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