DELIMITER //

drop table if exists events;

CREATE TABLE events (
  id int(11) NOT NULL auto_increment,
  event_type varchar(16) NOT NULL,
  event_value int(11) NOT NULL,
  created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
//

insert into events values(null,'a',3,now());
insert into events values(null,'b',5,now());
insert into events values(null,'a',1,now());
insert into events values(null,'b',2,now());
insert into events values(null,'a',3,now());
insert into events values(null,'b',7,now());
insert into events values(null,'b',4,now());


select event_type,
       sum(case when rownum=1 then event_value else 0 end) - sum(case when rownum=2 then event_value else 0 end) as event_value_sum
  from (
    select event_type,
           event_value,
           rownum
      from (
        select event_type,
               event_value,
               @curr:=if(@prev=event_type,@curr,0) + 1 as rownum,
               @prev:=event_type,
               created_at 
          from events, (select @curr:=0, @prev:=0) as dummmy_t
         order by event_type, created_at desc
    ) as x
    where rownum <= 2
) as a
group by event_type;
