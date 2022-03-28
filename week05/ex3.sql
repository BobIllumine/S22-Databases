create table Airport (
    IATACode int not null,
    primary key (IATACode)
);

create table AircraftType (
    typeId int not null,
    primary key (typeId)
);

create table FlightLeg (
    flightLegId int not null,
    primary key (flightLegId)
);

create table Flight (
    flightNum int not null,
    primary key (flightNum)
);

create table DailyFlightLegCombination (
    DFLegId int not null,
    primary key (DFLegId)
);

create table StartsAt (
    IATACode int not null,
    flightLegId int not null,
    primary key (IATACode, flightLegId),
    foreign key (IATACode) references Airport(IATACode),
    foreign key  (flightLegId) references FlightLeg(flightLegId)
);

create table EndsAt (
    IATACode int not null,
    flightLegId int not null,
    primary key (IATACode, flightLegId),
    foreign key (IATACode) references Airport(IATACode),
    foreign key  (flightLegId) references FlightLeg(flightLegId)
);

create table CanLand (
    IATACode int not null,
    typeId int not null,
    primary key (typeId, IATACode),
    foreign key (typeId) references AircraftType(typeId),
    foreign key (IATACode) references Airport(IATACode)
);

create table AssignedTo (
    typeId int not null,
    DFLegId int not null,
    primary key (typeId, DFLegId),
    foreign key (typeId) references AircraftType(typeId),
    foreign key (DFLegId) references DailyFlightLegCombination(DFLegId)
);

create table PartOf (
    flightLegId int not null,
    DFLegId int not null,
    primary key (flightLegId),
    foreign key (DFLegId) references DailyFlightLegCombination(DFLegId),
    foreign key (flightLegId) references FlightLeg(flightLegId)
);

create table BelongsTo (
    flightNum int not null,
    flightLegId int not null,
    primary key (flightNum),
    foreign key (flightLegId) references FlightLeg(flightLegId),
    foreign key (flightNum) references Flight(flightNum)
);