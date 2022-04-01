-- task 1
SELECT * FROM author
        INNER JOIN book ON author.author_id = book.editor;
-- task 2
SELECT (first_name, last_name) FROM author
    WHERE author_id IN (
        SELECT (author_id) FROM author
        EXCEPT (
            SELECT (editor) FROM book
                INNER JOIN author ON book.editor = author.author_id));
-- task 3
SELECT (author_id) FROM author
    EXCEPT
SELECT (editor) FROM book
