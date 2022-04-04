drop table if exists Relation;
drop table if exists NormalizedCustomers cascade;
drop table if exists NormalizedItems cascade;
drop table if exists NormalizedOrders cascade;
drop table if exists NormalizedPurchase cascade;


create table Relation (
    orderId int not null,
    date date not null,
    customerId int not null,
    customerName varchar(50) not null,
    city varchar(50) not null,
    itemId int not null,
    itemName varchar(50) not null,
    quant int not null,
    price real not null
);

insert into Relation(orderId, date, customerId, customerName, city, itemId, itemName, quant, price)
    values (2301, '2011-02-23', 101, 'Martin', 'Prague', 3786, 'Net', 3, 35.0),
           (2301, '2011-02-23', 101, 'Martin', 'Prague', 4011, 'Racket', 6, 65.0),
           (2301, '2011-02-23', 101, 'Martin', 'Prague', 9132, 'Pack-3', 8, 4.75),
           (2302, '2011-02-25', 107, 'Herman', 'Madrid', 5794, 'Pack-6', 4, 5.0),
           (2303, '2011-02-27', 110, 'Pedro', 'Moscow', 4011, 'Racket', 2, 65.0),
           (2303, '2011-02-27', 110, 'Pedro', 'Moscow', 3141, 'Cover', 2, 10.0);

create table NormalizedOrders(
    orderId int not null,
    date date not null,
    primary key (orderId)
);

create table NormalizedCustomers(
    customerId int not null,
    customerName varchar(50) not null,
    city varchar(50) not null,
    primary key (customerId)
);

create table NormalizedItems(
    itemId int not null,
    itemName varchar(50) not null,
    price real not null,
    primary key (itemId)
);

create table NormalizedPurchase (
    orderId int not null,
    customerId int not null,
    itemId int not null,
    quantity int not null,
    foreign key (orderId) references NormalizedOrders,
    foreign key (customerId) references NormalizedCustomers,
    foreign key (itemId) references NormalizedItems
);

insert into NormalizedOrders(orderId, date)
    select distinct orderId, date from Relation
    order by orderId;

insert into NormalizedCustomers(customerId, customerName, city)
    select distinct customerId, customerName, city from Relation
    order by customerId;

insert into NormalizedItems(itemId, itemName, price)
    select distinct itemId, itemName, price from Relation
    order by itemId;

insert into NormalizedPurchase(orderId, customerId, itemId, quantity)
    select distinct orderId, customerId, itemId, quant from Relation
    order by orderId;

-- Subtask 1

-- Getting number of elements in orders
select orderId, count(*) as amount
from NormalizedOrders
    natural join NormalizedPurchase
    natural join NormalizedCustomers
    natural join NormalizedItems
group by orderId;
-- Getting total cost
select customerName, sum(price * quantity) as cost
from NormalizedOrders
    natural join NormalizedPurchase
    natural join NormalizedCustomers
    natural join NormalizedItems
group by customerName;

-- Subtask 2

-- Getting the maximum cost
select customerName, Sum(price * quantity) as cost
from NormalizedOrders
    natural join NormalizedPurchase
    natural join NormalizedCustomers
    natural join NormalizedItems
group by customerName
having Sum(price * quantity) = (
    select max(cost) from (
        select customerName, sum(quantity * price) as cost
            from NormalizedOrders
                natural join NormalizedPurchase
                natural join NormalizedCustomers
                natural join NormalizedItems
        group by customerName
        ) as costs
    );
