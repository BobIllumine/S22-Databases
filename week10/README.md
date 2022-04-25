# Task 1
 
## Step 1
Let's create table:
 
```postgresql
create table accounts (
	id int primary key,
	name varchar(45),
	credit int,
	currency varchar(4)
);
 
insert into accounts (id, name, credit, currency)
    values (1, 'Vasiliy Pupkin', 1000, 'RUB'),
	   (2, 'Aleksandr Pupa', 1000, 'RUB'),
	   (3, 'Aleksei Lupa', 1000, 'RUB');
```
 
Now let's create transitions:
 
```postgresql
set transaction isolation level read committed read write;
begin;
	savepoint svp_1;
 
	update accounts
	    set credit = credit - 500
	    where id = 1;
 
	update accounts
	    set credit = credit + 500
	    where id = 3;
 
	savepoint svp_2;
 
	update accounts
	    set credit = credit - 700
	    where id = 2;
 
	update accounts
	    set credit = credit + 700
	    where id = 1;
 
	savepoint svp_3;
	update accounts
	    set credit = credit - 100
	    where id = 2;
 
	update accounts
	    set credit = credit + 100
	    where id = 3;
 
-- 	rollback to savepoint svp_1;
-- 	rollback to savepoint svp_2;
-- 	rollback to savepoint svp_3;
end;

-- update accounts set credit = 1000; -- uncomment if you are using pgAdmin
```
 
## Step 2

Now let's add new column:
 
```postgresql
alter table accounts add column bankName varchar(45);
update accounts 
    set bankname = 'Sberbank' 
    where id = 1 or id = 3;
update accounts 
    set bankname = 'Tinkoff' 
    where id = 2;
```
 
Adding a new row for containing fee information:

```postgresql
insert into accounts (id, name, credit, currency)
            values (4, 'Fees', 0, 'RUB');

-- uncomment if you use pgAdmin
-- update accounts set credit = 1000;
-- update accounts set credit = 0 where id = 4;
```

Making a transition yields:

```postgresql
set transaction isolation level read committed read write;
begin;
savepoint svp_1;
 
update accounts
    set credit = credit - 500
    where id = 1;

update accounts
    set credit = credit + 500
    where id = 3;

savepoint svp_2;

update accounts
    set credit = credit - 700
    where id = 2;

update accounts
    set credit = credit + 670
    where id = 1;

update accounts 
    set credit = credit + 30 
    where id = 4;

savepoint svp_3;
update accounts
    set credit = credit - 100
    where id = 2;

update accounts
    set credit = credit + 70
    where id = 3;

update accounts 
    set credit = credit + 30 
    where id = 4;

-- 	rollback to savepoint svp_1;
-- 	rollback to savepoint svp_2;
-- 	rollback to savepoint svp_3;
end;
```
## Step 3
 
Let us create a new table ```Ledger```:
 
```postgresql
create table ledger (
	id int primary key,
	fromID int,
	toID int,
	fee int,
	amount int,
	TransactionDateTime timestamp,
	constraint fk_from foreign key(fromID) references accounts(id),
	constraint fk_to foreign key(toID) references accounts(id)
);
```
And modify our transition:
```postgresql
set transaction isolation level read committed read write;
begin;
savepoint svp_1;
 
update accounts
    set credit = credit - 500
    where id = 1;

update accounts
    set credit = credit + 500
    where id = 3;

insert into ledger (id, fromID, toID, fee, amount, TransactionDateTime) 
            values (1, 1, 3, 0, 500, '2022-11-14');

savepoint svp_2;

update accounts
    set credit = credit - 700
    where id = 2;

update accounts
    set credit = credit + 670
    where id = 1;

update accounts 
    set credit = credit + 30 
    where id = 4;
insert into ledger (id, fromID, toID, fee, amount, TransactionDateTime) 
            values (2, 2, 1, 30, 670, '2022-11-13');

savepoint svp_3;

update accounts
    set credit = credit - 100
    where id = 2;

update accounts
    set credit = credit + 70
    where id = 3;

update accounts 
    set credit = credit + 30 
    where id = 4;
insert into ledger (id, fromID, toID, fee, amount, TransactionDateTime) 
values (3,2,3,30,70, '2022-11-12');
-- 	rollback to savepoint my_savepoint3;
-- 	rollback to savepoint my_savepoint2;
-- 	rollback to savepoint my_savepoint1;
end;
```
 
 
# Task 2
## Step 1
Let us create initial tables:
```postgresql
create table account (
    username varchar(45) primary key ,
    fullname varchar(45),
    balance int,
    group_id int
);
 
insert into account (username, fullname, balance, group_id)
            values  ('jones', 'Alice Jones', 82, 1),
                    ('bitdiddl', 'Ben Bitdiddle', 65, 1),
                    ('mike', 'Michael Dole', 73, 2),
                    ('alyssa', 'Alyssa P. Hacker', 79, 3),
                    ('bbrown', 'Bob Brown', 100, 3 );
```
### For ```read committed```
Terminal 1:
```postgresql
begin isolation level read committed; -- step 1
select * from account; -- step 1
select * from account; -- step 3
select * from account; -- step 5.2
update account 
    set balance = balance + 10 
    where fullname = 'Alice Jones'; -- step 7
commit; -- step 9
```
 
Terminal 2:
```postgresql
begin isolation level read committed; -- step 2
update account 
    set username = 'ajones' 
    where fullname = 'Alice Jones'; -- step 2
select * from account; -- step 4
commit; -- step 5.1

select * from account; -- step 5.2

begin isolation level read committed; -- step 6
update account 
    set balance = balance + 20 
    where fullname = 'Alice Jones'; -- step 8
rollback; -- step 10
```
 
1) Do both terminals show the same information? Explain the reason 

They will show different information since we use ```read committed``` isolation level, in which only committed difference will be applied to the database. So, Terminal 1 will see only ```'jones'```, not ```'ajones'```.
 
2) Explain the output form the second terminal:
 
After **step 2** Terminal 2 will wait until Terminal 1 will commit changes and Terminal 2 will consider information about balance after changes.
 
### For ```repeatable read```:
Terminal 1:
```postgresql
begin isolation level repeatable read; -- step 1
select * from account; -- step 1
select * from account; -- step 3
select * from account; -- step 5.2
update account 
    set balance = balance + 10 
    where fullname = 'Alice Jones'; -- step 7
commit; -- step 9
```
 
Terminal 2:
```postgresql
begin isolation level repeatable read; -- step 2
update account 
    set username = 'ajones' 
    where fullname = 'Alice Jones'; -- step 2
select * from account; -- step 4
commit; -- step 5.1

select * from account; -- step 5.2

begin isolation level repeatable read; -- step 6
    update account 
    set balance = balance + 20 where fullname = 'Alice Jones'; -- step 8
rollback; -- step 10
```
1) Do both terminals show the same information? Explain the reason
 
They will show different information since we use ```repeatable read``` isolation level, in which transactions only see data committed before the transaction began. So, in Terminal 1 we will not see any changes.
 
2) Explain the output form the second terminal:
 
```ERROR:  could not serialize access due to concurrent update``` - which indicates that the ```UPDATE``` statement was queued before another ```UPDATE``` statement on the same row.
 
## Step 2
### For ```read committed```
 
After committing T1 and T2, Mike's balance will be increased by 15, and Bob's group will be changed to 2.
Since all updates happened before commits, Bob's balance will not be increased. In other words, if update in Terminal 2 was committed before update in Terminal 1, then Bob's balance would change.

Terminal 1:
```postgresql
begin isolation level read committed; -- step 1
select * from account where group_id = 2; -- step 2
select * from account where group_id = 2; -- step 4
update account 
    set balance = balance + 15 
    where group_id = 2; -- step 5
commit; -- step 6
```
 
Terminal 2:
```postgresql
begin isolation level read committed; -- step 1
update account 
    set group_id = 2 
    where fullname = 'Bob Brown' -- step 3
commit; -- step 6
```
### For ```repeatable read```:
 
Situation will be the same as for ```read commited```. 
 
After committing T1 and T2, Mike's balance will be increased by 15, and Bob's group will be changed to 2.
However, even if update in T2 was committed before update in T1, Bob's balance would not increase.
 
Terminal 1:
```postgresql
begin isolation level repeatable read; -- step 1
select * from account where group_id = 2; -- step 2
select * from account where group_id = 2; -- step 4
update account 
    set balance = balance + 15 
    where group_id = 2; -- step 5
commit; -- step 6
```
 
Terminal 2:
```postgresql
begin isolation level repeatable read; -- step 1
update account 
    set group_id = 2 
    where fullname = 'Bob Brown'; -- step 3
commit; -- step 6
```