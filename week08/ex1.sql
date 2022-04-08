drop index if exists b_id;
drop index if exists h_name;
-- name check (before) 13.346ms
explain analyse select * from customer;
-- address check (before) 10.259ms
explain analyse select * from customer;
-- id check (before) 9.604ms
explain analyse select * from customer;

-- btree on id
create index if not exists b_id on customer(id);
-- hash on name
create index if not exists h_name on customer using hash (name);
-- hash on address
create index if not exists h_addr on customer using hash (address);


-- name check (after) 9.603ms
explain analyse select * from customer;
-- address check (after) 10.311ms
explain analyse select * from customer;
-- id check (after) 10.365ms
explain analyse select * from customer;
