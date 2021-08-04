SET SERVEROUTPUT ON;

DECLARE

  str CLOB := 'AA<tr>BBBB<tr>2<tr>3<tr>4<tr>33333';
  --v_str VARCHAR2(4000) := '1111';
  delim CLOB := '<tr>';
  get_index pls_integer := 1;
  
  TYPE tab_number IS TABLE OF VARCHAR(100);
  t_str tab_number := tab_number();
  
  res CLOB := '';
BEGIN

     DBMS_OUTPUT.PUT_LINE('--result = ');

    IF(LENGTH(str) > 0 AND INSTR(str, delim) = 0) THEN
        DBMS_OUTPUT.PUT_LINE('var1');
        res := '';
    ELSIF (LENGTH(str) > 0 AND INSTR(str, delim) > 0 AND get_index = 0) THEN
        DBMS_OUTPUT.PUT_LINE('var2');
        --DBMS_OUTPUT.PUT_LINE(INSTR(str, delim));
        res := SUBSTR(str,1, INSTR(str, delim)-1);
        DBMS_OUTPUT.PUT_LINE('result = ' || res);
    ELSIF (INSTR(str, delim, 1, get_index) > 0 AND INSTR(str, delim, 1, get_index + 1) = 0) THEN
        DBMS_OUTPUT.PUT_LINE('var3');
        DBMS_OUTPUT.PUT_LINE((INSTR(str, delim, 1, get_index) + LENGTH(delim)));
        res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)));
    ELSE
        DBMS_OUTPUT.PUT_LINE('var4');
        DBMS_OUTPUT.PUT_LINE(INSTR(str, delim, 1, get_index));
        DBMS_OUTPUT.PUT_LINE(INSTR(str, delim, 1, get_index + 1));
        res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)),INSTR(str, delim, 1, get_index + 1)+1);
    END IF;

    
    DBMS_OUTPUT.PUT_LINE('result = ' || res);
    
  --t_str.DELETE;
  
EXCEPTION 
    WHEN OTHERS THEN
      IF SQLCODE = -06532 THEN
        DBMS_OUTPUT.PUT_LINE('-----');
    END IF;
END;
