
--1. �л���ȣ, �̸�, �����, ���� ���
SELECT S.STU_NO , S.STU_NAME, S.STU_DEPT , E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
;
--2. ������ 70�� �̻��� �л����� �̸� ���

SELECT S.STU_NAME , E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
WHERE ENR_GRADE >= 70
;

--3. ������ �л��� �����ϴ� ����� �ش� ���� ���

SELECT S.STU_NAME, S.STU_DEPT , SUB.SUB_PROF
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE STU_NAME = '������'
;

--4. ��ǻ�Ͱ��� ������ ��� �л��� �й�,  �̸� ���

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE SUB_NAME LIKE '%��ǻ�Ͱ���%'
;
--5. �����۹�, �������ڽ��� ������ ��� �л��� �й�, �̸�, ����� ���

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE SUB_NAME IN ('�����۹�','�������ڽ���')    -- �̷��� �� ���� ���δ�.
--WHERE SUB_NAME LIKE '%�����۹�%'OR SUB_NAME LIKE '%�������ڽ���%'

;
--6. �����̸鼭 ������ ������ ������ ��� �л� ���

SELECT S.STU_NO , S.STU_NAME , SUB.SUB_NAME , S.STU_GENDER
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
INNER JOIN SUBJECT SUB ON E.SUB_NO = SUB.SUB_NO
WHERE STU_GENDER = 'F' AND SUB.SUB_PROF = '������'
;

--7. �������� ���� ��� �������� ���� �л����� �̸�, ���� ���, �� ������ ���� �������.

SELECT S.STU_NAME, E.ENR_GRADE
FROM STUDENT S
INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
WHERE E.ENR_GRADE < (SELECT AVG(ENR_GRADE)
                    FROM STUDENT S
                    INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
                    WHERE STU_NAME = '������')

ORDER BY ENR_GRADE
;


--8. �� ���� �̻��� ������ �л�(enrol�� 2���̻� ������ �ִ�)���� �й�, �̸�, �����, ���� ���

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

-- INNER JOIN �� ����Ѱ� --
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


--9. �� �а��� ������� �� ���� ���� �������� ���� ������ ���� �л��� ���� ���

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

---8�� �ٽ�---

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
