create or replace NONEDITIONABLE FUNCTION funConcat
   (
      st_part1 VARCHAR2,
      st_part2 VARCHAR2
   )
   RETURN VARCHAR2
   IS
      st_result VARCHAR2(400) := '';
BEGIN
    
    st_result := '11';
    st_result := st_part1 || st_part2;
    RETURN (st_result);
    
END funConcat;




