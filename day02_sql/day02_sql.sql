-- 1. 20153075 �й� �л��� ���� B�� ����

UPDATE STUDENT
SET STU_CLASS = 'B'
WHERE STU_NAME = '20153075'
;
-- 2. ��ü ��պ��� ���� Ű�� ���� �л��� Ű 1 ����

UPDATE STUDENT
SET STU_HEIGHT = STU_HEIGHT + 1
WHERE STU_HEIGHT < (
                    SELECT AVG(STU_HEIGHT)
                    FROM STUDENT)
;

-- 3. ��������� 65�� ������ �л����� ������ 1����

UPDATE STUDENT
SET 
    STU_WEIGHT = STU_WEIGHT + 1
WHERE STU_NO IN (
                SELECT STU_NO
                FROM (
                    SELECT AVG(ENR_GRADE) AS STU_AVG, E.STU_NO
                    FROM ENROL E
                    INNER JOIN STUDENT S ON S.STU_NO = E.STU_NO
                    GROUP BY E.STU_NO
                )
                WHERE STU_AVG <= 65
            )
;

-- 4. ��ǻ�Ͱ��� ������ ��� �л����� Ű�� �����Ը� 1�� ����

UPDATE STUDENT
SET STU_WEIGHT = STU_WEIGHT - 1 , STU_HEIGHT = STU_HEIGHT - 1 
WHERE  STU_NO  IN(
                SELECT S.STU_NO
                FROM STUDENT S
                INNER JOIN ENROL E ON S.STU_NO = E.STU_NO
                INNER JOIN SUBJECT SUB ON SUB.SUB_NO = E.SUB_NO
                WHERE SUB.SUB_NAME = '��ǻ�Ͱ���'
)
;


-- 5. å �� ���� ����� ���� ���� ����� �̸�, �ּ�, �� ���ž� ���

SELECT C.NAME, C.ADDRESS , T.MAX_PRICE
FROM BOOK B
INNER JOIN ORDERS O ON B.BOOKID = O.BOOKID
INNER JOIN CUSTOMER C ON O.CUSTID = C.CUSTID
INNER JOIN (  
             SELECT MAX(PRICE) AS MAX_PRICE 
                FROM (
               SELECT C.NAME , B.PRICE  
               FROM CUSTOMER C
              INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
               INNER JOIN BOOK B ON O.BOOKID = B.BOOKID
                    ) 
            )T ON O.CUSTID = C.CUSTID
            
WHERE ROWNUM = 1
;




SELECT C.NAME , C.ADDRESS , O.SALEPRICE
FROM CUSTOMER C
INNER JOIN ORDERS O ON C.CUSTID = O.CUSTID
INNER JOIN BOOK B ON B.BOOKID = O.BOOKID
INNER JOIN (
            SELECT COUNT(*) AS CNT , C.NAME 
            FROM ORDERS O
            INNER JOIN BOOK B ON B.BOOKID = O.BOOKID
            INNER JOIN CUSTOMER C ON O.CUSTID = C.CUSTID
            GROUP BY C.NAME
          )T ON C.NAME = T.NAME
          
WHERE CNT > 2
;
    
----Ǯ��----
SELECT NAME, ADDRESS, P_SUM
FROM ORDERS O
INNER JOIN CUSTOMER C ON O.CUSTID = C.CUSTID
INNER JOIN (
    SELECT P_SUM, CUSTID
    FROM (
        SELECT SUM(SALEPRICE) AS P_SUM, CUSTID
        FROM ORDERS
        GROUP BY CUSTID
        ORDER BY P_SUM DESC
    )
    WHERE ROWNUM = 1    -- �ֻ��� ��� 1���� ���
) A ON O.CUSTID = A.CUSTID
GROUP BY NAME, ADDRESS, P_SUM
;
-- 6. å �� ���� ����� ���� ���� ����� ���� ���� ����� ���� ���ϱ�
SELECT MAX(P_SUM) - MIN(P_SUM)
FROM (
        SELECT SUM(SALEPRICE) AS P_SUM, CUSTID
        FROM ORDERS
        GROUP BY CUSTID
        ORDER BY P_SUM DESC
)
;
-- 7. 3���� å�� ������ ����� �̸�, �ּ�, å ���� ���� ���

SELECT NAME, ADDRESS, CNT
FROM ORDERS O
INNER JOIN CUSTOMER C ON C.CUSTID = O.CUSTID
INNER JOIN (
            SELECT CUSTID, CNT
            FROM (
                SELECT COUNT(*) AS CNT, CUSTID
                FROM ORDERS
                GROUP BY CUSTID
                ) 
            WHERE CNT > 2
            ) A ON O.CUSTID = A.CUSTID
GROUP BY NAME, ADDRESS, CNT
;

--8. å �� ���� �ݾ��� 32000�� ������ ����� �ڵ��� ��ȣ�� 1234�� ����

UPDATE CUSTOMER
SET PHONE = 1234
WHERE CUSTID IN (
        SELECT CUSTID
        FROM (
                SELECT SUM(SALEPRICE) AS P_SUM, CUSTID 
                FROM ORDERS
                GROUP BY CUSTID
                ORDER BY P_SUM DESC
            )
            WHERE P_SUM <= 32000
        )
;
     
