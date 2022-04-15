alter table if exists address
    add column if not exists longitude real,
    add column if not exists latitude real;

create or replace function get_regexp_and_id_range(reg_exp text, min_id integer, max_id integer) returns table(id integer, address text)
    language sql
as
$$
select address_id, address from address a
    where a.address like reg_exp and a.address_id > min_id and a.address_id < max_id;
$$;

-- select * from get_regexp_and_id_range('%11%', 400, 600);
