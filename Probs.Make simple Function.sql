

CREATE OR REPLACE FUNCTION umnojenie
   (
      n1 number,
      n2 number
   )
   RETURN number
   IS
      n_result number := 0;
BEGIN
    n_result := 0;
    n_result := n1 * n2;
    RETURN (n_result);
END umnojenie;

