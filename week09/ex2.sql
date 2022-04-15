create or replace function retrieve_customers(min_id integer, max_id integer) returns setof customer
    language plpgsql
as
$$
BEGIN
    IF min_id < 0 OR max_id > 600
    THEN
        RAISE NUMERIC_VALUE_OUT_OF_RANGE;
    END IF;
    RETURN QUERY
        SELECT *
        FROM customer
        WHERE customer_id >= min_id
          AND customer_id <= max_id;
END;
$$;

select *
from retrieve_customers(0, 10);