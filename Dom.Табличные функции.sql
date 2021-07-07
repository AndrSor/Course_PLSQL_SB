CREATE TYPE pet_t IS OBJECT ( 
   name VARCHAR2 (60), 
   breed VARCHAR2 (100), 
   dob DATE);
/

CREATE TYPE pet_nt IS TABLE OF pet_t;
/

CREATE OR REPLACE FUNCTION pet_family (dad_in IN pet_t, mom_in IN pet_t)
   RETURN pet_nt 
IS
   l_count PLS_INTEGER;
   retval pet_nt := pet_nt ();

   PROCEDURE extend_assign (pet_in IN pet_t) IS 
   BEGIN
      retval.EXTEND;
      retval (retval.LAST) := pet_in;
   END;

BEGIN
   extend_assign (dad_in); 
   extend_assign (mom_in);
   IF mom_in.breed =	'RABBIT'   THEN	
        l_count	:= 12;
   ELSIF mom_in.breed =	'DOG'      THEN	
        l_count	:= 4;
   ELSIF mom_in.breed = 'KANGAROO' THEN
        l_count	:= 1;
   END IF;
   FOR indx IN 1 .. l_count 
   LOOP
      extend_assign (pet_t ('BABY' || indx, mom_in.breed, SYSDATE));
    END LOOP;
   RETURN retval; 
END;

/

SELECT 
    pets.NAME, 
    pets.dob
    FROM TABLE
        (
            pet_family (pet_t ('Hoppy', 'RABBIT', SYSDATE), pet_t ('Hippy', 'RABBIT', SYSDATE) )
        ) pets;
        
/