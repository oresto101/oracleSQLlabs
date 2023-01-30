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
SELECT c1.nickname, (c1.mice_ration+NVL(c1.mice_extra, 0)) "Eats"
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

#TASK 31
CREATE OR REPLACE VIEW Band_info AS
SELECT Bands.name, AVG(Cats.mice_ration) avg_ration, MAX(Cats.mice_ration) max_ration, MIN(Cats.mice_ration) min_ration, COUNT(*) "CAT", 
COUNT(mice_extra) "CAT_WITH_EXTRA"
FROM Bands 
RIGHT JOIN Cats ON Cats.band_no = Bands.band_no
GROUP BY Bands.name;

SELECT C.nickname, C.name, C.function, C.mice_ration, 'OD ' || BI.min_ration || ' DO ' || BI.max_ration "Ration range", C.in_herd_since
FROM Cats C LEFT JOIN Bands B ON C.band_no = B.band_no
            LEFT JOIN BAND_INFO BI ON BI.name=B.name
WHERE nickname = '&nickname';

#TASK 32
(SELECT nickname, gender, mice_ration "Mice before pay increase", NVL(mice_extra, 0) "Extra before pay increase"
FROM Cats
LEFT JOIN Bands on Cats.band_no = Bands.band_no
WHERE Bands.name ='BLACK KNIGHTS'
ORDER BY in_herd_since ASC
FETCH FIRST 3 ROWS ONLY)
UNION ALL
(SELECT nickname, gender, mice_ration "Mice before pay increase", NVL(mice_extra, 0) "Extra before pay increase"
FROM Cats
LEFT JOIN Bands on Cats.band_no = Bands.band_no
WHERE Bands.name ='PINTO HUNTERS'
ORDER BY in_herd_since ASC
FETCH FIRST 3 ROWS ONLY);

UPDATE Cats C 
SET 
  C.mice_ration = DECODE(
    C.gender, 
    'M', 
    C.mice_ration + 10, 
    'W', 
    C.mice_ration + (
      SELECT MIN(C1.mice_ration) 
      From Cats C1 LEFT JOIN Bands B ON B.Band_no = C1.Band_no 
      WHERE C1.Band_no = C.Band_no)* 0.1
  ), 
  C.mice_extra = NVL(C.mice_extra, 0) + (
    SELECT AVG(NVL(C1.mice_extra, 0)) 
    From Cats C1 LEFT JOIN Bands B ON B.Band_no = C1.Band_no 
    WHERE C1.Band_no = C.Band_no)* 0.15
WHERE C.nickname in (
    (SELECT * FROM 
        (
          SELECT nickname 
          FROM Cats LEFT JOIN Bands on Cats.band_no = Bands.band_no 
          WHERE Bands.name = 'BLACK KNIGHTS' 
          ORDER BY in_herd_since ASC FETCH FIRST 3 ROWS ONLY
        )
    ) 
    UNION ALL 
      (SELECT * FROM 
          (
            SELECT nickname 
            FROM Cats LEFT JOIN Bands on Cats.band_no = Bands.band_no 
            WHERE Bands.name = 'PINTO HUNTERS' 
            ORDER BY in_herd_since ASC FETCH FIRST 3 ROWS ONLY
          )
      )
  );

(SELECT nickname, gender, mice_ration "Mice after pay increase", NVL(mice_extra, 0) "Extra after pay increase"
FROM Cats
LEFT JOIN Bands on Cats.band_no = Bands.band_no
WHERE Bands.name ='BLACK KNIGHTS'
ORDER BY in_herd_since ASC
FETCH FIRST 3 ROWS ONLY)
UNION ALL
(SELECT nickname, gender, mice_ration "Mice after pay increase", NVL(mice_extra, 0) "Extra after pay increase"
FROM Cats
LEFT JOIN Bands on Cats.band_no = Bands.band_no
WHERE Bands.name ='PINTO HUNTERS'
ORDER BY in_herd_since ASC
FETCH FIRST 3 ROWS ONLY);

ROLLBACK;

#TASK 33a
SELECT bandname, genderi, how_many, boss, thug, catching, catcher, cat, nice, divisive, sum
FROM (SELECT Bands.name bandname,
            DECODE(gender, 'W', 'FEMALE CAT', 'MALE CAT') genderi,
             TO_CHAR(count(*)) how_many,
             SUM(DECODE(function,'BOSS', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) boss,
             SUM(DECODE(function,'THUG', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) thug,
             SUM(DECODE(function,'CATCHING', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) catching,
             SUM(DECODE(function,'CATCHER', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) catcher,
             SUM(DECODE(function,'CAT', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) cat,
             SUM(DECODE(function,'NICE', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) nice,
             SUM(DECODE(function,'DIVISIVE', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) divisive,
             SUM(NVL(mice_ration, 0) + NVL(mice_extra, 0)) sum
            FROM Cats LEFT JOIN Bands on Bands.band_no = Cats.band_no
            GROUP BY Bands.name, gender
            UNION ALL
            SELECT 'Z eats in total', ' ', ' ',
            SUM(DECODE(function, 'BOSS', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) boss,
            SUM(DECODE(function, 'THUG', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) thug,
            SUM(DECODE(function, 'CATCHING', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) catching,
            SUM(DECODE(function, 'CATCHER', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) catcher,
            SUM(DECODE(function, 'CAT', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) cat,
            SUM(DECODE(function, 'NICE', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) nice,
            SUM(DECODE(function, 'DIVISIVE', NVL(mice_ration, 0) + NVL(mice_extra, 0), 0)) divisive,
            SUM(NVL(mice_ration, 0) + NVL(mice_extra, 0)) sum
            FROM Cats LEFT JOIN Bands on Bands.band_no = Cats.band_no);

#TASK 33b
SELECT *
FROM(SELECT "BAND NAME",
            DECODE(gender, 'M', 'MALE CAT', 'FEMALE CAT') gender,
            TO_CHAR("HOW MANY") as "HOW MANY",
            NVL(BOSS, 0) BOSS,
            NVL(THUG, 0) THUG,
            NVL(CATCHING, 0) CATCHING,
            NVL(CATCHER, 0) CATCHER,
            NVL(CAT, 0) CAT,
            NVL(NICE, 0) NICE,
            NVL(DIVISIVE, 0) DIVISIVE,
            NVL(SUM, 0) SUM
        FROM (SELECT b.name "BAND NAME", gender, function, mice_ration + NVL(mice_extra, 0) RATION
                FROM Cats c LEFT JOIN Bands b ON c.band_no = b.band_no)
            PIVOT(SUM(RATION) FOR function IN (
                            'BOSS' BOSS,
                            'THUG' THUG,
                            'CATCHING' CATCHING,
                            'CATCHER' CATCHER,
                            'CAT' CAT,
                            'NICE' NICE,
                            'DIVISIVE' DIVISIVE
                        ))
            JOIN (SELECT b.name n, gender g, COUNT(nickname) "HOW MANY", SUM(mice_ration + NVL(mice_extra, 0)) SUM
                    FROM Cats c JOIN Bands b ON c.band_no = b.band_no
                    GROUP BY b.name, gender
                    ORDER BY b.name)
            ON "BAND NAME" = n AND g = gender)
    UNION ALL
    SELECT  'EATS TOTAL',
            ' ',
            ' ',
            NVL(BOSS, 0) BOSS,
            NVL(THUG, 0) THUG,
            NVL(CATCHING, 0) CATCHING,
            NVL(CATCHER, 0) CATCHER,
            NVL(CAT, 0) CAT,
            NVL(NICE, 0) NICE,
            NVL(DIVISIVE, 0) DIVISIVE,
            NVL(SUM, 0) SUM
    FROM 
        (
          SELECT function, mice_ration + NVL(mice_extra, 0) ration
          FROM Cats c JOIN Bands b ON c.band_no = b.band_no
        )
        PIVOT 
        (
            SUM(ration) FOR function IN 
                (
                    'BOSS' BOSS,
                    'THUG' THUG,
                    'CATCHING' CATCHING,
                    'CATCHER' CATCHER,
                    'CAT' CAT,
                    'NICE' NICE,
                    'DIVISIVE' DIVISIVE
                )
        ), 
        (
        SELECT SUM(mice_ration + NVL(mice_extra, 0)) SUM
        FROM Cats
        );