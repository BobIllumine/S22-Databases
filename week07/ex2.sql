drop table if exists School cascade;
drop table if exists Teacher cascade;
drop table if exists Publisher cascade;
drop table if exists Book cascade;
drop table if exists Grade cascade;
drop table if exists Room cascade;
drop table if exists Course cascade;

create table if not exists School (
    schoolId int,
    school varchar(100),
    primary key (schoolId)
);

create table if not exists Teacher (
    teacherId int,
    teacher varchar(100),
    primary key (teacherId),
    schoolId int references School(schoolId)
);

create table if not exists Publisher (
    pubId int,
    publisher varchar(100),
    primary key (pubId)
);


create table if not exists Book (
    bookId int,
    book varchar(100),
    loanDate date,
    pubId integer references Publisher(pubId),
    primary key (bookId)
);

create table if not exists Grade (
    gradeId int,
    grade varchar(100),
    primary key (gradeId)
);

create table if not exists Room (
    room varchar(100) primary key
);

create table if not exists Course (
    courseId int,
    course varchar(100),
    teacherId int references Teacher(teacherId),
    room varchar(100) references Room(room),
    grade int references Grade(gradeId),
    bookId int references Book(bookId),
    schoolId int references School(schoolId),
    loanDate date,
    primary key (courseId)
);

insert into School(schoolId, school)
    values (0, 'Horizon Education Institute'),
           (1, 'Bright Institute');

insert into Teacher(teacherId, teacher, schoolId)
    values (0, 'Chad Russel', 0),
           (1, 'E.F.Codd', 0),
           (2, 'Jones Smith', 0),
           (3, 'Adam Baker', 1);

insert into Publisher(pubId, publisher)
    values (0, 'BOA Editions'),
           (1, 'Taylor & Francis Publishing'),
           (2, 'Prentice Hall'),
           (3, 'McGraw Hill');

insert into Book(bookId, book, pubId)
    values (0, 'Learning and teaching in early childhood',  0),
           (1, 'Preschool, N56', 1),
           (2, 'Early Childhood Education N9', 2),
           (3, 'Know how to educate: guide for Parents and', 3);

insert into Room(room)
    values ('1.A01'),
           ('1.B01'),
           ('2.B01');

insert into Grade (gradeId, grade)
    values (1, '1st grade'),
           (2, '2nd grade');

insert into Course(courseId, course, teacherId, room, grade, bookId, schoolId, loanDate)
    values (0, 'Logical thinking', 0, '1.A01', 1, 0, 0, '2010-09-09'),
           (1, 'Writing', 0, '1.A01', 1, 1, 0, '2010-05-05'),
           (2, 'Numerical Thinking', 0, '1.A01', 1, 0, 0, '2010-05-05'),
           (3, 'Spatial, Temporal and Casual Thinking', 1, '1.B01', 1, 2, 0, '2010-05-06'),
           (4, 'Numerical Thinking', 1, '1.B01', 1, 0, 0, '2010-05-06'),
           (5, 'Writing', 2, '1.A01', 2, 0, 0, '2010-09-09'),
           (6, 'English', 2, '1.A01', 2, 3, 0, '2010-05-05'),
           (7, 'Logical Thinking', 3, '2.B01', 1, 3, 1, '2010-12-18'),
           (8, 'Numerical Thinking', 3, '2.B01', 1, 0, 1, '2010-05-06');

-- Getting number of books loaned
select s.school, p.publisher, count(*)
from School s
    join Course C on s.schoolId = C.schoolId
    join Book B on B.bookId = C.bookId
    join Publisher P on P.pubId = B.pubId
group by s.school, p.publisher;

-- Getting the longest loaned book
select b.book, t.teacher, c.loanDate
from Book b
    join Course C on b.bookId = C.bookId
    join Teacher T on T.teacherId = C.teacherId
order by c.loanDate limit 1;