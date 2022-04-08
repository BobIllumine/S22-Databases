drop index if exists b_id;
drop index if exists h_name;
drop index if exists h_addr;

-- name check (before) 65.258ms
explain analyse select name from customer;
-- address check (before) 18.259ms
explain analyse select address from customer;
-- id check (before) 9.604ms
explain analyse select id from customer;

-- btree on id
create index if not exists b_id on customer(id);
-- hash on name
create index if not exists h_name on customer using hash (name);
-- hash on address
create index if not exists h_addr on customer using hash (address);


-- name check (after) 15.603ms
explain analyse select name from customer;
-- address check (after) 17.311ms
explain analyse select address from customer;
-- id check (after) 10.365ms
explain analyse select id from customer;

drop index if exists b_id;
drop index if exists h_name;
drop index if exists h_addr;
