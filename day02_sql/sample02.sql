-- 1. å ��� ���� �ݾ��� 10000 ������ ����� �ڵ��� ��ȣ�� 1�� ����

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
    

-- 2. å ��� ���� �ݾ��� ���� ���� ����� �ڵ��� ��ȣ�� 2�� ����

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


-- 3. �л����� ��� ������ ���� ���� �л��� ���� ���� �л��� ���� ���ϱ�
SELECT MAX(AVG_GRADE) - MIN(AVG_GRADE)
FROM (
        SELECT AVG(ENR_GRADE) AS AVG_GRADE , STU_NO
        FROM ENROL
        GROUP BY STU_NO
        ORDER BY AVG_GRADE DESC
        )
;

-- 4. 2���� ������ ���� �л����� ��������� 1���� ������ ���� �л����� ��������� ���� ���ϱ�

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


-- 5. ��ǻ�� �а����� ����� ���� �а��� ���� ���

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
            WHERE STU_DEPT = '��ǻ������'
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
                WHERE S.STU_DEPT = '��ǻ������'
                GROUP BY S.STU_DEPT
        )
;







-- 6. ��ǻ�� ���� ������ ��� �л����� ��� �������� ���� ������ ������ �ִ� ��ǻ�������� �л� ���