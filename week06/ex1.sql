-- task 1
SELECT (sname) FROM suppliers
    INNER JOIN catalog ON suppliers.sid = catalog.sid
    INNER JOIN parts ON catalog.pid = parts.pid
WHERE parts.color = 'Red' GROUP BY suppliers.sname;
-- task 2
SELECT (suppliers.sid) FROM suppliers
    INNER JOIN catalog ON suppliers.sid = catalog.sid
    INNER JOIN parts ON parts.pid = catalog.pid
WHERE parts.color = 'Red' OR parts.color = 'Green' GROUP BY suppliers.sid;
-- task 3
SELECT (suppliers.sid) FROM suppliers
    INNER JOIN catalog ON suppliers.sid = catalog.sid
    INNER JOIN parts ON parts.pid = catalog.pid
WHERE parts.color = 'Red' OR suppliers.address = '221 Packer Street' GROUP BY suppliers.sid;
-- task 4
SELECT (suppliers.sid) FROM suppliers
    WHERE suppliers.sid NOT IN ()
-- task 5

