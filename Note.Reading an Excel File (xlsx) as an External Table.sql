------
------ https://odieweblog.wordpress.com/2016/06/21/reading-an-excel-file-xlsx-as-an-external-table/
------


function getRows (
    p_file   in  blob
  , p_sheet  in  varchar2
  , p_cols   in  varchar2
  , p_range  in  varchar2 default null
  ) 
  return anydataset pipelined
  using ExcelTableImpl;



  select t.*
    from table(
           ExcelTable.getRows(
             ExcelTable.getFile('TMP_DIR','ooxdata3.xlsx')
           , 'DataSource'
           , ' "SRNO"    number
             , "NAME"    varchar2(10)
             , "VAL"     number
             , "DT"      date
            , "SPARE1"  varchar2(6)
            , "SPARE2"  varchar2(6)'
          , 'A2'
          )
        ) t
   ;