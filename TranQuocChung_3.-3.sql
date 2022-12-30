-- BAI 1
-- 1.1

CREATE OR REPLACE PROCEDURE dept_info(dept_id IN NUMBER)
    IS
     D_dept DEPARTMENTS%ROWTYPE;
    BEGIN
        SELECT * INTO dept FROM DEPARTMENTS WHERE DEPARTMENT_ID = D_dept_id;
        DBMS_OUTPUT.put_line('DEPARTMENT ID = ' || D_dept.DEPARTMENT_ID);
        DBMS_OUTPUT.put_line('DEPARTMENT NAME = ' || D_dept.DEPARTMENT_NAME);
        DBMS_OUTPUT.put_line('MANAGER ID = ' || D_dept.MANAGER_ID);
        DBMS_OUTPUT.put_line('LOCATION ID = ' || D_dept.LOCATION_ID);
    END;
    

-- BEGIN
--     dept_info(8);
-- END;

-- 1.2

CREATE OR REPLACE PROCEDURE add_job
    (id IN NUMBER,title IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO JOBS(JOB_ID, JOB_TITLE) VALUES(id, title);
    END;

-- BEGIN
--     add_job('96', 'Java');
-- END;

-- 1.3

CREATE OR REPLACE PROCEDURE update_comm(EMP_ID IN NUMBER)
    IS
    BEGIN
        UPDATE EMPLOYEES SET COMMISSION_PCT = COMMISSION_PCT *1.05 
            WHERE EMPLOYEE_ID = EMP_ID ;
    END;

-- BEGIN 
--     update_comm(1);
-- END;

-- 1.4
CREATE OR REPLACE PROCEDURE add_emp (A_ID IN NUMBER,
                                     A_FIRST_NAME IN VARCHAR2,
                                     A_LAST_NAME  IN VARCHAR2,
                                     A_EMAIL IN VARCHAR2,
                                     A_PHONE_NUMBER IN VARCHAR2,
                                     A_HIRE_DATE IN DATE,
                                     A_JOB_ID IN VARCHAR2,
                                     A_SALARY IN NUMBER,
                                     A_COMMISSION_PCT IN NUMBER,
                                     A_MANAGER_ID IN NUMBER,
                                     A_DEPARTMENT_ID IN NUMBER)
    IS
    BEGIN
        INSERT INTO EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) 
            VALUES 
                (A_ID,A_FIRST_NAME,A_LAST_NAME,A_EMAIL,A_PHONE_NUMBER,A_HIRE_DATE,A_JOB_ID,A_SALARY,A_COMMISSION_PCT,A_MANAGER_ID,A_DEPARTMENT_ID);

    END;

-- BEGIN
--     add_emp(999,'CHUNG','TRAN','aabb','0909',to_date('28-FEB-96','DD-MON-RR'),'AD_PRES',10000,null,null,90);
-- END;

-- 1.5

CREATE OR REPLACE PROCEDURE delete_emp (emp_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = emp_id;
    END;

-- BEGIN 
--     delete_emp(96);
-- END;

-- 1.6

CREATE OR REPLACE PROCEDURE find_emp(F_job_id NUMBER)
    AS
        MAX_SALA NUMBER(10);
        MIN_SALA NUMBER(10);
    BEGIN
        SELECT MIN_SALARY, MAX_SALARY INTO MIN_SALA, MAX_SALA FROM JOBS WHERE JOB_ID = F_job_id;
        FOR EMP IN (SELECT * FROM EMPLOYEES WHERE (JOB_ID = F_job_id) AND  (SALARY BETWEEN MIN_SALA AND MAX_SALA))
        LOOP
            DBMS_OUTPUT.put_line(EMP.EMPLOYEE_ID || ', '|| EMP.FIRST_NAME || ', '|| EMP.LAST_NAME);
        END LOOP;
    END;



--  1.7
CREATE OR REPLACE PROCEDURE update_sal
    IS
        worktime DECIMAL(7,2);
    BEGIN
    
    FOR EMP IN (SELECT * FROM EMPLOYEES)
        LOOP
            worktime := (months_between(SYSDATE, EMP.HIRE_DATE) /12);
            IF(worktime > 2) THEN
                UPDATE EMPLOYEES SET SALARY = SALARY + 200  WHERE EMPLOYEE_ID = EMP.EMPLOYEE_ID;
            ELSIF (2 < worktime > 1) THEN
                UPDATE EMPLOYEES SET SALARY = SALARY + 100  WHERE EMPLOYEE_ID = EMP.EMPLOYEE_ID;
            ELSIF (worktime = 1) THEN
                UPDATE EMPLOYEES SET SALARY = SALARY + 50  WHERE EMPLOYEE_ID = EMP.EMPLOYEE_ID;
            END IF;
        END LOOP;
    END;

-- BEGIN 
--     update_sal();
-- END;

-- BAI 1.8
CREATE OR REPLACE PROCEDURE job_his(emp_id IN NUMBER,emp_his OUT JOB_HISTORY%ROWTYPE)
    IS
    BEGIN
        SELECT * INTO emp_his FROM JOB_HISTORY WHERE EMPLOYEE_ID = emp_id;
    END;
    
DECLARE
    emp_his JOB_HISTORY%ROWTYPE;
BEGIN
    job_his(102, emp_his);
    DBMS_OUTPUT.put_line('EMPLOYEE ID = ' || emp_his.EMPLOYEE_ID);
    DBMS_OUTPUT.put_line('START_DATE = ' || emp_his.START_DATE);
    DBMS_OUTPUT.put_line('END_DATE = ' || emp_his.END_DATE);
    DBMS_OUTPUT.put_line('JOB_ID = ' || emp_his.JOB_ID);
    DBMS_OUTPUT.put_line('DEPARTMENT_ID = ' || emp_his.DEPARTMENT_ID);
END;
--BAI2
--  2.1
CREATE OR REPLACE FUNCTION sum_salary(dept_id IN NUMBER)
RETURN NUMBER 
IS
    SUM_SALA NUMBER(10);
BEGIN
    SELECT SUM(SALARY) INTO SUM_SALA FROM EMPLOYEES WHERE DEPARTMENT_ID = dept_id;
    RETURN SUM_SALA;
END;



-- 2.2

CREATE OR REPLACE FUNCTION name_con(cont_id IN VARCHAR2)
RETURN VARCHAR2 
IS
    c_cont_name VARCHAR2(20);
BEGIN
    SELECT COUNTRY_NAME INTO c_cont_name FROM COUNTRIES WHERE COUNTRY_ID = cont_id;
    RETURN c_cont_name;
END;



--  2.3
CREATE OR REPLACE FUNCTION annual(sala IN NUMBER, comm IN NUMBER)
RETURN NUMBER
IS
    INCOME NUMBER;
BEGIN
    INCOME := sal *(1+ comm) * 12;
    RETURN INCOME;
END;


--  2.4 
CREATE OR REPLACE FUNCTION avg_salary(dept_id IN NUMBER)
RETURN NUMBER 
IS
    V_AVG NUMBER(10);
BEGIN
    SELECT AVG(SALARY) INTO V_AVG FROM EMPLOYEES WHERE DEPARTMENT_ID = dept_id;
    RETURN V_AVG;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'NO DEPARTMENT FOUND';
END;


--  2.5
CREATE OR REPLACE FUNCTION time_work(emp_id IN NUMBER)
RETURN NUMBER 
IS
    time_worked NUMBER(10);
BEGIN
    SELECT (months_between(SYSDATE, HIRE_DATE)) INTO time_worked FROM EMPLOYEES WHERE EMPLOYEE_ID = emp_id;
    RETURN time_worked;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RETURN 'EMPLOYEE NOT FOUND';
END;


--BAI 3
-- 3.1
CREATE OR REPLACE TRIGGER EMP_HIRE_DATE
BEFORE INSERT OR UPDATE
ON EMPLOYEES 
FOR EACH ROW
BEGIN 
    IF (:new.HIRE_DATE > SYSDATE) THEN
        raise_application_error(-20000, 'NGAY THUE NHAN VIEN PHAI NHO HON NGAY HIEN TAI');
    END IF;
END;

Insert into HR.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE_NUMBER,HIRE_DATE,JOB_ID,SALARY,COMMISSION_PCT,MANAGER_ID,DEPARTMENT_ID) values (888,'Steven','King','TEST','515.123.4567',to_date('17-JUN-24','DD-MON-RR'),'AD_PRES',24000,null,null,90);
UPDATE EMPLOYEES SET HIRE_DATE = to_date('31-DEC-22','DD-MON-RR') WHERE EMPLOYEE_ID = 99;  

-- 3.2

CREATE OR REPLACE TRIGGER JOBS_BEFORE_SALARY
BEFORE INSERT OR UPDATE
ON JOBS 
FOR EACH ROW
BEGIN 
    IF (:new.MIN_SALARY > :new.MAX_SALARY) OR (:new.MIN_SALARY > :old.MAX_SALARY) OR (:old.MIN_SALARY > :new.MAX_SALARY)THEN
        raise_application_error(-20001, 'MIN_SALARY PHAI NHO HON MAX_SALARY');
    END IF;
END;

Insert into HR.JOBS (JOB_ID,JOB_TITLE,MIN_SALARY,MAX_SALARY) values ('10','JAVA',41000,40000);
UPDATE JOBS SET MIN_SALARY = 41000 WHERE JOB_ID = 'AD_PRES';

--  3.3
CREATE OR REPLACE TRIGGER JOB_BEFORE_HIRE
BEFORE INSERT OR UPDATE
ON JOB_HISTORY FOR EACH ROW
BEGIN 
    IF (:new.START_DATE >= :new.END_DATE) OR(:new.START_DATE >= :old.END_DATE) OR (:old.START_DATE >= :new.END_DATE)THEN
        raise_application_error(-20002, 'NGAY BAT DAU PHAI NHO HON HOAC BANG NGAY KET THUC');
    END IF;
END;



--  3.4
CREATE OR REPLACE TRIGGER SALARY_COMMISSION_BEFORE
BEFORE UPDATE
ON EMPLOYEES FOR EACH ROW
BEGIN 
    IF (:new.SALARY < :old.SALARY) THEN
    raise_application_error(-20010, 'LUONG PHAI DUOC CAP NHAT');
    ELSIF (:new.COMMISSION_PCT < :old.COMMISSION_PCT) THEN
    raise_application_error(-20011, 'HOA HONG PHAI DUOC CAP NHAT');
    END IF;
END;


