/*-- Exemple
-- I. variabile locale
-- 1. 
Declare
	FN varchar2(40);
	--	LN  FN%type;
	LN  employees.last_name%type;
Begin
	Select first_name, last_name INTO FN, LN  from employees where employee_id = 100;

	dbms_output.put_line('Valoarea variabilei FN este: '|| FN || ' iar LN este: '|| LN );
End;
/

-- 2. 
DECLARE
  totul employees%rowtype;
BEGIN 
  SELECT *
  INTO totul 
  FROM employees 
  WHERE employee_id = 101;
  
  dbms_output.put_line(totul.first_name ||' '|| totul.salary );
END;
/

-- II. variabile BIND(globale)
VARIABLE glob NUMBER;
BEGIN
  :glob := 103;
END;
/
--afisare var globale in afara blocurilor
PRINT glob;

DECLARE
  totul employees%rowtype;
BEGIN
  SELECT *
  INTO totul
  FROM employees
  WHERE employee_id = :glob;
  dbms_output.put_line(totul.first_name ||' '|| totul.salary );
END;
/
*/

--Exercitii antrenament
--- ex 2
<<principal>>
DECLARE
  v_client_id NUMBER(4):= 1600;
  v_client_nume VARCHAR2(50):= 'N1';
  v_nou_client_id NUMBER(3):= 500;
BEGIN
  <<secundar>>
  DECLARE
    v_client_id NUMBER(4) := 0;
    v_client_nume VARCHAR2(50) := 'N2';
    v_nou_client_id NUMBER(3) := 300;
    v_nou_client_nume VARCHAR2(50) := 'N3';
  BEGIN
    v_client_id:= v_nou_client_id;
    principal.v_client_nume:=v_client_nume ||' '|| v_nou_client_nume;
    --poziţia 1
     dbms_output.put_line('Poz1 v_client_id '||v_client_id);
     dbms_output.put_line('Poz1 v_client_nume '||v_client_nume);
     dbms_output.put_line('Poz1 v_nou_client_id '||v_nou_client_id);
     dbms_output.put_line('Poz1 v_nou_client_nume '||v_nou_client_nume);
  END;
  v_client_id:= (v_client_id *12)/10;
  --poziţia 2
  dbms_output.put_line('Poz2 v_client_id '||v_client_id);
  dbms_output.put_line('Poz2 v_client_nume '||v_client_nume);
END;
/

--ex 3
--varianta 1
VARIABLE g_mesaj VARCHAR2(50) 
BEGIN 
  :g_mesaj := 'Invat PL/SQL';
END; 
/ 
PRINT g_mesaj

--varianta 2
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Invat PL/SQL'); 
END; 
/

--ex 4
DECLARE 
  v_dep departments.department_name%TYPE; 
BEGIN 
  SELECT department_name 
  INTO v_dep FROM employees e, departments d 
  WHERE e.department_id=d.department_id 
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                    FROM employees
                    GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep);
END; 
/

--ex 5 la fel

--ex 6
DECLARE 
  v_dep departments.department_name%TYPE; 
  v_nr NUMBER;
BEGIN 
  SELECT department_name, COUNT(*)
  INTO v_dep, v_nr 
  FROM employees e, departments d 
  WHERE e.department_id=d.department_id 
  GROUP BY department_name 
  HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                    FROM employees
                    GROUP BY department_id);
  DBMS_OUTPUT.PUT_LINE('Departamentul '|| v_dep||' cu '||v_nr||' angajati.');
END; 
/

--ex 7
SET VERIFY OFF 
DECLARE 
  v_cod employees.employee_id%TYPE:=&p_cod;
  v_bonus NUMBER(8);
  v_salariu_anual NUMBER(8);
BEGIN 
  SELECT salary*12 
  INTO v_salariu_anual 
  FROM employees 
  WHERE employee_id = v_cod; 
  IF v_salariu_anual>=20001 
    THEN v_bonus:=2000; 
  ELSIF v_salariu_anual BETWEEN 10001 AND 20000 
    THEN v_bonus:=1000; 
  ELSE v_bonus:=500; 
  END IF; 
  DBMS_OUTPUT.PUT_LINE('Bonusul este ' || v_bonus); 
END; 
/ 
SET VERIFY ON

--ex 8 la fel, dar cu CASE

--ex 9
CREATE TABLE emp_dho
AS SELECT * FROM employees;

DEFINE p_cod_sal = 200 
DEFINE p_cod_dept = 80
DEFINE p_procent = 20 
DECLARE 
  v_cod_sal emp_dho.employee_id%TYPE:= &&p_cod_sal;
  v_cod_dept emp_dho.department_id%TYPE:= &&p_cod_dept;
  v_procent NUMBER(8):=&&p_procent;
BEGIN 
  UPDATE emp_dho
  SET department_id = v_cod_dept,
    salary=salary + (salary * v_procent/100) 
  WHERE employee_id= v_cod_sal; 
  IF SQL%ROWCOUNT = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod');
  ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
  END IF; 
END; 
/ 
ROLLBACK;

--ex 10
CREATE TABLE zile_dho(
    id NUMBER,
    data DATE,
    nume_zi VARCHAR2(20)
  );

DECLARE
  contor NUMBER(6) := 1;
  v_data DATE;
  maxim  NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_dho VALUES(contor,v_data,TO_CHAR(v_data,'Day'));
    contor := contor + 1;
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

SELECT * FROM zile_dho;

--ex 11 aceesi chestie cu WHILE

--ex 12 aceeasi cheste cu FOR
DECLARE
  v_data DATE;
  maxim  NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
  FOR contor IN 1..maxim LOOP
    v_data := sysdate+contor;
    INSERT INTO zile_*** VALUES (contor,v_data,TO_CHAR(v_data,'Day'));
  END LOOP;
END;
/

--ex 13
DECLARE
  i POSITIVE                :=1;
  max_loop CONSTANT POSITIVE:=10;
BEGIN
  LOOP
    i  :=i+1;
    IF i>max_loop THEN
      DBMS_OUTPUT.PUT_LINE('in loop i=' || i);
      GOTO urmator;
    END IF;
  END LOOP;
  <<urmator>>
  i:=1;
  DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/


--Exercitii
--ex 1
DECLARE 
  numar number(3):=100;
  mesaj1 varchar2(255):='text 1';
  mesaj2 varchar2(255):='text 2';
BEGIN 
  DECLARE 
    numar number(3):=1;
    mesaj1 varchar2(255):='text 2';
    mesaj2 varchar2(255):='text 3';
  BEGIN 
    numar := numar + 1;
    mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei numar în subbloc este: '||numar);
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj1 în subbloc este: '||mesaj1);
    DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj2  în subbloc este: '||mesaj2);
  END;
numar := numar + 1;
mesaj1:=mesaj1||' adaugat un blocul principal'; 
mesaj2:=mesaj2||' adaugat in blocul principal';
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei numar în bloc este: '||numar);
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj1 în bloc este: '||mesaj1);
DBMS_OUTPUT.PUT_LINE('Valoarea variabilei mesaj2  în bloc este: '||mesaj2);
END;
/

--ex 2
--b)
CREATE TABLE octombrie_dho (
  id NUMBER,
  data DATE
);
/*
DECLARE
  id NUMBER := 0;
BEGIN
  SELECT DT
  FROM(
  SELECT TRUNC (last_day(SYSDATE) - ROWNUM + 1) dt
    FROM DUAL CONNECT BY ROWNUM < 32
    )
    where DT >= trunc(sysdate,'mm');
END;
/
*/

DECLARE
  contor NUMBER(6) := 0;
  v_data DATE;
  first_date DATE := TO_DATE('2017-10-01', 'YYYY-MM-DD');
  maxim NUMBER(2) := 30;
BEGIN
  LOOP
    v_data := first_date + contor;
    contor := contor + 1;
    INSERT INTO octombrie_dho VALUES (contor, v_data );
    EXIT WHEN contor > maxim;
  END LOOP;
END;
/

--nu merge inca
SELECT oct.data, COUNT(*) numar_imprumuturi
FROM rental r JOIN octombrie_dho oct ON(oct.data = r.act_ret_date); 

select * from octombrie_dho;

declare
  zi_din_luna date := '01-oct-2017';
  cate_imprumuturi number(3);
begin
  for i in 1..31 loop
    select count(*)
    into cate_imprumuturi
    from rental
    where to_char(book_date, 'dd/mm/yyyy') = to_char(zi_din_luna, 'dd/mm/yyyy');
    
    dbms_output.put_line('In ziua ' || zi_din_luna || ' au fost imprumutate ' || cate_imprumuturi);
    zi_din_luna := zi_din_luna + 1;
  end loop;
end;
/

--ex3
declare
  nume member.last_name%type := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
begin
  select count(*)
  into cati
  from member
  where upper(last_name) = upper(nume);
  
  if cati > 1 then
    dbms_output.put_line('Sunt mai multi');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul');
  else
    select count(unique(title_id))
    into cate_imprumuturi
    from member, rental
    where upper(last_name) = upper(nume)
    and member.member_id = rental.member_id;
    
    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' || cate_imprumuturi || ' titluri.');
  end if;
end;
/

--ex4
declare
  nume member.last_name%type := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
  numar_titluri number(3);
begin
  select count(*)
  into cati
  from member
  where upper(last_name) = upper(nume);
  
  select count(unique(title_id))
  into numar_titluri
  from title;
  
  if cati > 1 then
    dbms_output.put_line('Sunt mai multi');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul');
  else
    select count(unique(title_id))
    into cate_imprumuturi
    from member, rental
    where upper(last_name) = upper(nume)
    and member.member_id = rental.member_id;
    
    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' || cate_imprumuturi || ' titluri.');
  end if;
  
  if cate_imprumuturi > numar_titluri * 75 / 100 then
     dbms_output.put_line('Categoria 1');
  elsif cate_imprumuturi > numar_titluri * 50 / 100 then
     dbms_output.put_line('Categoria 2');
  elsif cate_imprumuturi > numar_titluri * 25 / 100 then
     dbms_output.put_line('Categoria 3');
  else
     dbms_output.put_line('Categoria 4');
  end if;
end;
/

--ex5
CREATE TABLE member_dho
as select *
from member;

alter table member_dho
add discount number(2);

declare
  nume member.last_name%type := '&v_subs';
  cati number(2);
  cate_imprumuturi number(3);
  numar_titluri number(3);
begin
  select count(*)
  into cati
  from member
  where upper(last_name) = upper(nume);
  
  select count(unique(title_id))
  into numar_titluri
  from title;
  
  if cati > 1 then
    dbms_output.put_line('Sunt mai multi');
  elsif cati = 0 then
    dbms_output.put_line('Nu e niciunul');
  else
    select count(unique(title_id))
    into cate_imprumuturi
    from member, rental
    where upper(last_name) = upper(nume)
    and member.member_id = rental.member_id;
    
    dbms_output.put_line('Membrul ' || nume || ' a imprumutat ' || cate_imprumuturi || ' titluri.');
  end if;
  
  if cate_imprumuturi > numar_titluri * 75 / 100 then
     update member_dho
     set discount = 10
     where upper(last_name) = upper(nume);
  elsif cate_imprumuturi > numar_titluri * 50 / 100 then
     update member_dho
     set discount = 5
     where upper(last_name) = upper(nume);
  elsif cate_imprumuturi > numar_titluri * 25 / 100 then
     update member_dho
     set discount = 3
     where upper(last_name) = upper(nume);
  else
     update member_dho
     set discount = 0
     where upper(last_name) = upper(nume);
  end if;
end;
/

select * from member_dho;
