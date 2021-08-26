--select * from client

select *
  from
  ( select ltrim(sys_connect_by_path(id, ','), ',') as "IDs"
      from
      ( select id, lag(id) over (order by id) as prev_id
          from client
      )
      start with prev_id is null
      connect by prev_id = prior id
      order by 1 desc
  )
  where rownum = 1


select * from client
      