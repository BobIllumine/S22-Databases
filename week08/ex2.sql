explain analyse select fid, title from film_list fl
    join inventory i on i.film_id = fl.fid
    where (rating = 'R' or rating = 'PG-13')
        and (category = 'Horror' or category = 'Sci-Fi')
        and inventory_in_stock(i.inventory_id)
group by title, fid
order by fid;
-- the most expensive step - checking if the film is in stock (cost=0.00..1216.06, time=0.125..108.411ms)
-- can be reduced by implementing a better searching algorithm function



explain analyse select * from sales_by_store;
-- the most expensive step - join of inventory and store tables in the view
-- already sped up by hash joining