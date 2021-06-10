
DROP SEQUENCE c##hr.seq1;
DROP SEQUENCE c##hr.seq2;

CREATE SEQUENCE c##hr.seq1;

CREATE SEQUENCE c##hr.seq2 INCREMENT BY 2;

SELECT
      c##hr.seq1.CURRVAL
    , c##hr.seq1.NEXTVAL
    , c##hr.seq1.CURRVAL
    , c##hr.seq2.CURRVAL
    , c##hr.seq2.NEXTVAL
    , c##hr.seq2.NEXTVAL
    FROM dual;
    
SELECT
      c##hr.seq1.CURRVAL
    , c##hr.seq1.NEXTVAL
    , c##hr.seq1.CURRVAL
    , c##hr.seq2.CURRVAL
    , c##hr.seq2.NEXTVAL
    , c##hr.seq2.NEXTVAL
    FROM dual;
    
SELECT
      c##hr.seq1.CURRVAL
    , c##hr.seq1.CURRVAL
    , c##hr.seq2.CURRVAL
    FROM dual;

    
    