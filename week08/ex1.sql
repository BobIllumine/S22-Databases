drop index if exists b_id;
drop index if exists h_name;
-- name check (before) 34.460ms
explain analyse select * from customer where name not similar to 'J%';
-- address check (before) 59.390ms
explain analyse select * from customer where address !~ 'FPO';
-- id check (before) 9.450ms
explain analyse select * from customer where id % 2 = 0;

-- btree on id
create index if not exists b_id on customer(id);
-- hash on name
create index if not exists h_name on customer using hash (name);

-- name check (after) 33.394ms
explain analyse select * from customer where name not similar to 'J%';
-- address check (after) 54.099ms
explain analyse select * from customer where address !~ 'FPO';
-- id check (after) 10.069ms
explain analyse select * from customer where id % 2 = 0;
