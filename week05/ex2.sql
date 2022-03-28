create table `Group` (
    groupId int not null,
    primary key (groupId)
);

create table `Company` (
    companyId int not null,
    coherentCompanyId int,
    primary key (companyId),
    foreign key (coherentCompanyId) references `Company`(companyId)
);

create table `Plant` (
    plantId int not null,
    primary key (plantId)
);

create table `Item` (
    itemId int not null,
    primary key (itemId)
);

create table `InGroup`(
    companyId int not null,
    groupId int not null,
    primary key (companyId),
    foreign key (companyId) references `Company`(companyId),
    foreign key (groupId) references `Group`(groupId)
);

create table `OwnedBy` (
    plantId int not null,
    companyId int not null,
    primary key (plantId),
    foreign key (companyId) references `Company`(companyId),
    foreign key (plantId) references `Plant`(plantId)
);

create table `ProducedBy` (
    itemId int not null,
    plantId int not null,
    primary key (itemId),
    foreign key (plantId) references `Plant`(plantId),
    foreign key (itemId) references `Item`(itemId)
);