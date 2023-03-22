-- 1. 책 평균 구매 금액이 10000 이하인 사람의 핸드폰 번호를 1로 변경

UPDATE CUSTOMER 
SET PHONE = '1'
WHERE CUSTID IN (
        SELECT CUSTID
        FROM (
             SELECT AVG(SALEPRICE) AS AVG_P , CUSTID
              FROM ORDERS
               GROUP BY CUSTID
          ) 
          WHERE AVG_P <= 10000
     )
;
    

-- 2. 책 평균 구매 금액이 가장 낮은 사람의 핸드폰 번호를 2로 변경

UPDATE CUSTOMER 
SET PHONE = '2'
WHERE CUSTID IN (
        SELECT CUSTID
        FROM (
             SELECT AVG(SALEPRICE) AS AVG_P , CUSTID
              FROM ORDERS
               GROUP BY CUSTID
               ORDER BY AVG_P
          ) 
          WHERE ROWNUM = 1
     )
;


-- 3. 학생들의 평균 성적이 가장 높은 학생과 가장 낮은 학생의 차이 구하기
SELECT MAX(AVG_GRADE) - MIN(AVG_GRADE)
FROM (
        SELECT AVG(ENR_GRADE) AS AVG_GRADE , STU_NO
        FROM ENROL
        GROUP BY STU_NO
        ORDER BY AVG_GRADE DESC
        )
;

-- 4. 2개의 수업을 들은 학생들의 평균점수와 1개의 수업을 들은 학생들의 평균점수의 차이 구하기

SELECT AVG(ENR_GRADE) , E.SUB_NO
FROM ENROL E
INNER JOIN SUBJECT SUB ON SUB.SUB_NO = E.SUB_NO
INNER JOIN
        (
            SELECT *
            FROM(
                     SELECT COUNT(*) AS CNT , SUB_NO
                     FROM ENROL
                     GROUP BY SUB_NO
                )
                
            WHERE CNT = 2
        )T ON E.SUB_NO = T.SUB_NO
 ;


-- 5. 컴퓨터 학과보다 평균이 낮은 학과와 점수 출력

WHERE (





) <
(

SELECT 
FROM
(
        SELECT AVG_GRADE
        FROM (
                SELECT AVG(ENR_GRADE) AS AVG_GRADE,E.STU_NO , S.STU_DEPT
                FROM ENROL E
                INNER JOIN STUDENT S ON S.STU_NO = E.STU_NO
                GROUP BY E.STU_NO , S.STU_DEPT
                )
            WHERE STU_DEPT = '컴퓨터정보'
            ORDER BY A
)
WHERE ROWNUM = 1
;


SELECT S.STU_DEPT , E.ENR_GRADE 
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
WHERE E.ENR_GRADE < (

                SELECT AVG(ENR_GRADE) AVG_GRADE , S.STU_DEPT
                FROM ENROL E
                INNER JOIN STUDENT S ON S.STU_NO = E.STU_NO
                WHERE S.STU_DEPT = '컴퓨터정보'
                GROUP BY S.STU_DEPT
        )
;







-- 6. 컴퓨터 개론 수업을 듣는 학생들의 평균 점수보다 높은 점수를 가지고 있는 컴퓨터정보과 학생 출력