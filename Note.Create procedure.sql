/*
Во-первых, если вы собираетесь создать процедуру / функцию, сделайте это на отдельном листе, а затем скомпилируйте. 
Не компилируйте его вместе с другими анонимными блоками, потому что в большинстве случаев, если вы не заканчиваете другие блоки символом '/', 
обязательно будут возникать ошибки.

Во-вторых, ваш оператор DECLARE неуместен. Если вы собираетесь создать анонимный блок, убедитесь, что DECLARE, BEGIN и 
END находятся в строке, не создавайте процедуру / функцию внутри анонимного блока.

В-третьих, вы объявляете переменные в своих процедурах и используете их, но у них нет начального значения, 
поэтому он просто передаст пустое значение в оператор DML в вашей процедуре. просто используйте параметр напрямую.

В-четвертых, избегайте создания процедуры, содержащей только dbms_output.put_line. Это глупо.

Наконец, ваш анонимный блок, который должен вызывать вашу процедуру, использует '&', пожалуйста, избегайте использования '&' внутри pl / sql, поскольку '&' 
является функцией в SQL * Plus и не имеет никакого значения в PL / SQL. вместо этого вы можете использовать ":" как для переменных привязки . 
Но вы используете '&' не в переменных привязки, поэтому вам следует удалить это;

*/

drop table address;

 /

create table address(zipcode NUMBER, city varchar2(30), state varchar2(20));

 / 

create or replace procedure location(p_zipcode NUMBER, 
                                     p_city varchar2,    
                                     p_state varchar2) is

zip address.zipcode%type;


begin
  select count(*) 
    from address 
    into zip 
    where zipcode = p_zipcode 
             and city =p_city 
                and state = p_state;

  if zip > 0 then 
   dbms_output.put_line('Error Zip Code already found in table');
  else
  Insert into address values(p_zipcode, p_city, p_state);
  end if;
end location;

/


begin

 location(:zzip, :ccity, :sstate);

end;