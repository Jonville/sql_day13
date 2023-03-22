
--1. 학생번호, 이름, 과목명, 점수 출력
SELECT S.STU_NO , S.STU_NAME, S.STU_DEPT , E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
;
--2. 점수가 70점 이상인 학생들의 이름 출력

SELECT S.STU_NAME , E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
WHERE ENR_GRADE >= 70
;

--3. 김인중 학생이 수강하는 과목과 해당 교수 출력

SELECT S.STU_NAME, S.STU_DEPT , SUB.SUB_PROF
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE STU_NAME = '김인중'
;

--4. 컴퓨터개론 수업을 듣는 학생의 학번,  이름 출력

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE SUB_NAME LIKE '%컴퓨터개론%'
;
--5. 기계공작법, 기초전자실험 수업을 듣는 학생의 학번, 이름, 과목명 출력

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE SUB_NAME IN ('기계공작법','기초전자실험')    -- 이렇게 더 많이 쓰인다.
--WHERE SUB_NAME LIKE '%기계공작법%'OR SUB_NAME LIKE '%기초전자실험%'

;
--6. 여자이면서 구봉규 교수의 수업을 듣는 학생 출력

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME , S.STU_GENDER
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE STU_GENDER = 'F' AND SUB.SUB_PROF = '구봉규'
;

--7. 김인중의 과목 평균 점수보다 낮은 학생들의 이름, 점수 출력, 단 점수가 높은 순서대로.

SELECT S.STU_NAME, E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
WHERE E.ENR_GRADE < (SELECT AVG(ENR_GRADE)
                    FROM STUDENT S
                    INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
                    WHERE STU_NAME = '김인중')

ORDER BY ENR_GRADE
;


--8. 두 과목 이상을 수강한 학생(enrol에 2개이상 데이터 있는)들의 학번, 이름, 과목명, 점수 출력

SELECT S.STU_NO, STU_NAME, STU_DEPT, ENR_GRADE
FROM STUDENT S 
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON SUB.SUB_NO = E.SUB_NO
WHERE S.STU_NO IN (SELECT STU_NO
                     FROM (SELECT COUNT(*) AS CNT, STU_NO 
                            FROM ENROL  
                            GROUP BY STU_NO
                  ) 

WHERE CNT > 1
)
ORDER BY STU_NAME;

-- INNER JOIN 을 사용한거 --
SELECT S.STU_NO, STU_NAME, STU_DEPT, ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E  ON E.STU_NO = S.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
INNER JOIN  (
           SELECT CNT, STU_NO
        FROM(
            SELECT COUNT(*) AS CNT, STU_NO
            FROM ENROL
            GROUP BY STU_NO
            )
            
        WHERE CNT > 1
        ) T ON T.STU_NO = S.STU_NO
;


--9. 각 학과의 평균점수 중 가장 높은 점수보다 높은 점수를 받은 학생의 정보 출력

SELECT S.STU_NAME , SUB.SUB_NAME ,  E.ENR_GRADE , A.AVG_ALL
FROM ENROL E
INNER JOIN STUDENT S ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
INNER JOIN (
             SELECT AVG(ENR_GRADE) AS AVG_ALL 
             FROM ENROL E
             INNER JOIN SUBJECT SUB ON SUB.SUB_NO = E.SUB_NO
             GROUP BY SUB_NAME
             ) A ON E.ENR_GRADE > A.AVG_ALL
             
            ;

SELECT * 
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN (SELECT MAX(AVG_DEPT) AS AVG_MAX
            FROM ( 
                SELECT AVG(ENR_GRADE) AS AVG_DEPT
                FROM STUDENT S
                INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
                GROUP BY STU_DEPT)
            ) A ON E.ENR_GRADE > A.AVG_MAX;

---8번 다시---

SELECT S.STU_NO , S.STU_NAME , STU_DEPT , E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON SUB.SUB_NO = E.SUB_NO
INNER JOIN (
            SELECT CNT , STU_NO
            FROM ( 
                    SELECT COUNT(*) AS CNT , STU_NO
                    FROM ENROL
                    GROUP BY STU_NO
                    )
            WHERE CNT > 1
            ) T ON S.STU_NO = T.STU_NO
;
