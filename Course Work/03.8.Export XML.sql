-- directory_import
set serveroutput on;

CLEAR SCREEN

SET SERVEROUTPUT ON

--CREATE OR REPLACE procedure readfile (dir in varchar2, fil in varchar2) is
DECLARE
    
    cn varchar2(1000);
    s_file UTL_FILE.FILE_TYPE;
    d_file UTL_FILE.FILE_TYPE;
    cnt CLOB := '';

BEGIN
  
  s_file := UTL_FILE.FOPEN('DIRECTORY_IMPORT','report_template.xml','r');
  d_file := UTL_FILE.FOPEN('DIRECTORY_IMPORT','10.10.2020.xml','w');
  
  LOOP
      begin
        UTL_FILE.GET_LINE(s_file,cn); 
        IF cn != '<body/>' THEN
            UTL_FILE.PUTF(d_file,cn);
        END IF;

            
        --cnt := cnt || cn;
        --dbms_output.put_line(cn);
      exception
        WHEN NO_DATA_FOUND THEN EXIT;
      end;
  end loop;
  
  
  
  
  
  UTL_FILE.FCLOSE(d_file);
  UTL_FILE.FCLOSE(s_file);
  
EXCEPTION
  WHEN s_file.invalid_path THEN
     raise_application_error(-20000, 'ERROR: Invalid path for file.');
  WHEN d_file.invalid_path THEN
     raise_application_error(-20000, 'ERROR: Invalid path for file.');
END;