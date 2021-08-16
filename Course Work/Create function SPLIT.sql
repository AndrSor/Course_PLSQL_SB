CREATE OR REPLACE FUNCTION c##course.split(
         str        CLOB
        ,delim      CLOB
        ,get_index  PLS_INTEGER)
    RETURN CLOB
IS

    res CLOB := '';
  
BEGIN
  
    IF(LENGTH(str) > 0 AND INSTR(str, delim) = 0) THEN
        res := '';
    ELSIF (LENGTH(str) > 0 AND INSTR(str, delim) > 0 AND get_index = 0) THEN
        res := SUBSTR(str,1, INSTR(str, delim)-1);
    ELSIF (INSTR(str, delim, 1, get_index) > 0 AND INSTR(str, delim, 1, get_index + 1) = 0) THEN
        res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)));
    ELSE
        res := SUBSTR(str, (INSTR(str, delim, 1, get_index) + LENGTH(delim)),INSTR(str, delim, 1, get_index + 1)-(INSTR(str, delim, 1, get_index) + LENGTH(delim)));
    END IF;

    RETURN res;
  
EXCEPTION 
    WHEN OTHERS THEN
      IF SQLCODE = -06532 THEN
        RETURN '';
    END IF;
  
END;
/

SELECT c##course.split('ghghgh<tr>77777<tr>77777<tr>666<tr>','<tr>',4) st FROM DUAL; 