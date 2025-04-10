-- 1. Primary and Foreign Keys in Maven Movies DB
-- PRIMARY KEYS: actor.actor_id, customer.customer_id, film.film_id, rental.rental_id, payment.payment_id, inventory.inventory_id, store.store_id, address.address_id, city.city_id, country.country_id
-- FOREIGN KEYS: 
-- customer.address_id -> address.address_id
-- address.city_id -> city.city_id
-- city.country_id -> country.country_id
-- inventory.film_id -> film.film_id
-- inventory.store_id -> store.store_id
-- rental.inventory_id -> inventory.inventory_id
-- rental.customer_id -> customer.customer_id
-- payment.rental_id -> rental.rental_id
-- payment.customer_id -> customer.customer_id
-- payment.staff_id -> staff.staff_id
-- Differences: PRIMARY KEY uniquely identifies a row. FOREIGN KEY creates a relationship between two tables.

use  mavenmovies;
-- 2- List all details of actors
select * from actor;

-- 3 -List all customer information from DB.
select * from customer;

-- 4 -List different countries.
select* from country;

-- 5 -Display all active customers.
select * from customer
where active =1;

-- 6 -List of all rental IDs for customer with ID 1.
SELECT * FROM customer
WHERE customer_id=1;

-- 7 - Display all the films whose rental duration is greater than 5 .
SELECT * FROM FILM
WHERE RENTAL_DURATION >5;

-- 8 - List the total number of films whose replacement cost is greater than $15 and less than $20
SELECT * FROM FILM
WHERE REPLACEMENT_COST> 15 AND REPLACEMENT_COST<20;

-- 9 - Display the count of unique first names of actors
select COUNT(distinct first_name) from actor;

-- 10- Display the first 10 records from the customer table .
select * from customer
limit 10;

-- 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
select * from customer 
where first_name like 'b%'
limit 3;

-- 12 -Display the names of the first 5 movies which are rated as ‘G’.
select * from film
where rating='G'
limit 5;

-- 13-Find all customers whose first name starts with "a".
select * from customer
where first_name like 'a%';

-- 14- Find all customers whose first name ends with "a".
select * from customer
where first_name like '%a';

-- 15- Display the list of first 4 cities which start and end with ‘a’ .
select * from city
where trim(SUBSTRING_INDEX(city,'(',1)) like 'a%a';

-- 16- Find all customers whose first name have "NI" in any position.
select * from customer
where first_name like '%ni%';

-- 17- Find all customers whose first name have "r" in the second position .
select * from customer
where first_name like '_r%';

-- 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
select * from customer
where first_name like 'a____%';

-- 19- Find all customers whose first name starts with "a" and ends with "o".
select * from customer
where first_name like 'a%o';

-- 20 - Get the films with pg and pg-13 rating using IN operator
select * from film
where rating in ('pg','pg-13');

-- 21 - Get the films with length between 50 to 100 using between operator.
select  * from film
where length between 50 and 100;

-- 22 - Get the top 50 actors using limit operator.
select * from actor_award
limit 50;

-- 23 - Get the distinct film ids from inventory table.
select  distinct(film_id) from inventory ;


-- Question 1:
-- Retrieve the total number of rentals made in the Sakila database.
select count(distinct(rental_id)) from rental;

-- Question 2:
-- Find the average rental duration (in days) of movies rented from the Sakila database.
select avg(rental_date-return_date) as avg_rental_duration from rental;

-- Question 3:
-- Display the first name and last name of customers in uppercase
select upper(first_name),
upper(last_name) 
from customer;

-- Question 4:
-- Extract the month from the rental date and display it alongside the rental ID
select rental_id, 
month(RENTAL_DATE)
from rental;

-- Question 5:
-- Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
SELECT CUSTOMER_ID,
COUNT(RENTAL_ID) AS COUNT_RENTALS
FROM RENTAL
GROUP BY CUSTOMER_ID;

-- Question 6:
-- Find the total revenue generated by each store.
SELECT 
RENTAL_ID,
SUM(AMOUNT) AS REVENUE_OF_EACHSTORE
FROM PAYMENT
GROUP BY(RENTAL_ID);

-- Question 7:
-- Determine the total number of rentals for each category of movies
SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- Question 8:
-- Find the average rental rate of movies in each language.
SELECT l.name AS language_name, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY avg_rental_rate DESC; 	

-- Questions 9 -
-- Display the title of the movie, customer s first name, and last name who rented it.
SELECT f.title AS movie_title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY f.title, c.first_name, c.last_name;

-- Question 10:
-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
select a.first_name, 
      a.last_name
from actor as a
join film_actor as fa on fa.actor_id=a.actor_id
join film as f on f.film_id=fa.film_id 
where f.title = 'GONE WITH THE WIND';

-- Question 11:
-- Retrieve the customer names along with the total amount they've spent on rentals
SELECT 
    CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS FULLNAME,
	SUM(P.AMOUNT) AS RENT_by_CUSTOMER
FROM CUSTOMER AS C
JOIN RENTAL AS R ON C.CUSTOMER_ID=R.CUSTOMER_ID
JOIN PAYMENT AS P ON P.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY FULLNAME;

-- Question 12:
-- List the titles of movies rented by each customer in a particular city (e.g., 'London').
SELECT 
    CU.FIRST_NAME,CU.LAST_NAME,
    C.CITY,F.TITLE,
	COUNT(TITLE) OVER(PARTITION BY TITLE)
FROM city as c
JOIN address as a ON c.city_id=a.city_id
JOIN customer AS cu ON cu.address_id=a.address_id
JOIN RENTAL AS R ON R.CUSTOMER_ID=CU.CUSTOMER_ID
JOIN INVENTORY AS I ON I.INVENTORY_ID=R.RENTAL_ID
JOIN FILM AS F ON F.FILM_ID = I.FILM_ID
WHERE CITY ='LONDON';

-- Question 13:
-- Display the top 5 rented movies along with the number of times they've been rented.
SELECT TITLE, COUNT(R.CUSTOMER_ID) AS TOTAL_RENTAL  FROM FILM AS F
JOIN INVENTORY AS I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL AS R ON R.INVENTORY_ID = I.INVENTORY_ID
GROUP BY TITLE
ORDER BY COUNT(CUSTOMER_ID) DESC
LIMIT 5;

-- Question 14:
-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- window functions
-- 1. Rank the customers based on the total amount they've spent on rentals.
select * , dense_rank() over( order by customer_rent desc) as rank_of_customer_rent from
(select customer_id,
sum(amount) as customer_rent
 from payment
group by customer_id) t;

-- 2. Calculate the cumulative revenue generated by each film over time
SELECT  title,payment_date ,sum(amount) over(partition by title order by payment_date) as cumulative_revnue
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
Join film f on f.film_id=i.film_id
join payment p on p.customer_id=c.customer_id;

-- 3. Determine the average rental duration for each film, considering films with similar lengths.
select 
	film_id,
	title,
	round(avg(rental_duration) over(partition by film_id),2) as avg_rental_duration
from film;

-- 4. Identify the top 3 films in each category based on their rental counts.
select * from(
select 
	*,
	dense_rank() over(partition by name order by rental_counts desc) as rank_by_count
 from
(SELECT title,ct.name,count(rental_id) over(partition by title) rental_counts
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
Join film f on f.film_id=i.film_id
join film_category as fc on fc.film_id=f.film_id
join category as ct on ct.category_id=fc.category_id)t)k
where rank_by_count <=3;

-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
WITH CustomerRentals AS (
    SELECT customer_id, COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY customer_id
),
AvgRentals AS (
    SELECT AVG(total_rentals) AS avg_rentals
    FROM CustomerRentals
)
SELECT 
    c.customer_id, 
    c.total_rentals, 
    a.avg_rentals, 
    (c.total_rentals - a.avg_rentals) AS rental_difference
FROM CustomerRentals c
CROSS JOIN AvgRentals a;

-- 6. Find the monthly revenue trend for the entire rental store over time.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY month
ORDER BY month;

-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
select *
from (
select customer_id, 
sum(amount) as customer_spending,
round(percent_rank() over(order by sum(amount)),4) as percent_rank_
from payment
group by customer_id
order by customer_spending desc)t
where percent_rank_ >= 0.8;

-- 8. Calculate the running total of rentals per category, ordered by rental count.
SELECT 
	C.CATEGORY_ID,
    C.NAME AS category_name,
    COUNT(R.RENTAL_ID) AS rental_count,
    SUM(COUNT(R.RENTAL_ID)) OVER (ORDER BY COUNT(R.RENTAL_ID) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM RENTAL AS R
JOIN INVENTORY AS I ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN FILM AS F ON F.FILM_ID = I.FILM_ID
JOIN FILM_CATEGORY AS FC ON FC.FILM_ID = F.FILM_ID
JOIN CATEGORY AS C ON C.CATEGORY_ID = FC.CATEGORY_ID
GROUP BY  C.NAME,C.CATEGORY_ID;

-- 9. Find the films that have been rented less than the average rental count for their respective categories.
WITH FilmRentals AS (
    SELECT 
        FC.CATEGORY_ID,
        F.FILM_ID,
        COUNT(R.RENTAL_ID) AS RENTAL_COUNT
    FROM RENTAL AS R
    JOIN INVENTORY AS I ON R.INVENTORY_ID = I.INVENTORY_ID
    JOIN FILM AS F ON F.FILM_ID = I.FILM_ID
    JOIN FILM_CATEGORY AS FC ON FC.FILM_ID = F.FILM_ID
    GROUP BY FC.CATEGORY_ID, F.FILM_ID
),
CTE_RENTED_MOV_AVG AS (
    SELECT 
        CATEGORY_ID,
        AVG(RENTAL_COUNT) AS AVG_RENTED_MOVIE
    FROM FilmRentals
    GROUP BY CATEGORY_ID
)
SELECT 
    FR.CATEGORY_ID,
    F.TITLE,
    C.NAME AS CATEGORY_NAME,
    FR.RENTAL_COUNT,
    MA.AVG_RENTED_MOVIE
FROM FilmRentals AS FR
JOIN FILM AS F ON F.FILM_ID = FR.FILM_ID
JOIN CATEGORY AS C ON C.CATEGORY_ID = FR.CATEGORY_ID
JOIN CTE_RENTED_MOV_AVG AS MA ON MA.CATEGORY_ID = FR.CATEGORY_ID
WHERE FR.RENTAL_COUNT< MA.AVG_RENTED_MOVIE;


-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT 
* 
FROM(
	select 
		monthname(PAYMENT_DATE) PAYMENT_MONTH,
		SUM(AMOUNT) AMOUNT_PAID
	from payment
	GROUP BY monthname(PAYMENT_DATE)) T
ORDER BY AMOUNT_PAID DESC 
LIMIT 5;


-- 5. CTE Basics:
--  a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.

WITH ACTOR_INFO AS (
SELECT 
	ACTOR_ID,
	FIRST_NAME,
	LAST_NAME
 FROM ACTOR)
, ACTOR_FILMS AS (
SELECT 
	ACTOR_ID,
	COUNT(FILM_ID) AS TOTAL_FIMS
FROM FILM_ACTOR
GROUP BY ACTOR_ID)
SELECT 
AI.ACTOR_ID,
AI.FIRST_NAME,
AI.LAST_NAME,
AF.TOTAL_FIMS
 FROM ACTOR_INFO AS AI
JOIN ACTOR_FILMS AS AF ON AF.ACTOR_ID = AI.ACTOR_ID ;

-- 6. CTE with Joins:
--  a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.
WITH CTE_1 AS
(SELECT 
	TITLE,
	LANGUAGE_ID, 
	RENTAL_RATE
FROM FILM),
CTE_2 AS
(SELECT 
	LANGUAGE_ID,
	NAME 
FROM 
LANGUAGE)

SELECT 
	C1.TITLE,
    C2.NAME,
	C1.RENTAL_RATE
 FROM CTE_1 AS C1
JOIN CTE_2 AS C2 ON C1.LANGUAGE_ID=C2.LANGUAGE_ID;

-- 7. CTE for Aggregation:
-- query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.
WITH CUSTOMER_DETAILS AS
(SELECT 
	CUSTOMER_ID,
	FIRST_NAME,
	LAST_NAME
 FROM CUSTOMER)
 , CUSTOMER_PAYMENT AS(
 SELECT 
	 CUSTOMER_ID,
	 SUM(AMOUNT) AS AMOUNT_PAID
FROM PAYMENT
GROUP BY CUSTOMER_ID
)
SELECT 
	C.CUSTOMER_ID,
	C.FIRST_NAME,
	C.LAST_NAME,
    CP.AMOUNT_PAID
FROM CUSTOMER_PAYMENT AS CP
JOIN CUSTOMER_DETAILS AS C ON C.CUSTOMER_ID= CP.CUSTOMER_ID;

-- 8. CTE with Window Functions:
--  a. Utilize a CTE with a window function to rank films based on their rental duration from the film table
WITH RankedFilms AS (
SELECT 
	FILM_ID,
	TITLE,
	RENTAL_DURATION,
	RANK() OVER (ORDER BY RENTAL_DURATION DESC) AS DURATION_RANK
    FROM FILM
)
SELECT * 
FROM RankedFilms
ORDER BY DURATION_RANK;

-- 9. CTE and Filtering:
-- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.
WITH CTE_RENTAL AS (
SELECT 
		CUSTOMER_ID,
		COUNT(RENTAL_ID) TOTAL_RENTAL
	FROM RENTAL 
	group by CUSTOMER_ID
	HAVING COUNT(RENTAL_ID) >2
)
SELECT * FROM CUSTOMER AS C
JOIN CTE_RENTAL AS R ON R.CUSTOMER_ID=C.CUSTOMER_ID;

-- 10. CTE for Date Calculations:
-- a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table
WITH MonthlyRentals AS (
    SELECT 
        DATE_FORMAT(rental_date, '%Y-%m') AS rental_month,
        COUNT(*) AS total_rentals
    FROM RENTAL
    GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
)
SELECT *
FROM MonthlyRentals
ORDER BY rental_month;

-- 11. CTE and Self-Join:
-- CREate a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table
WITH ActorPairsInSameFilm AS (
SELECT
        fa1.film_id,          
        fa1.actor_id AS actor1_id, 
        fa2.actor_id AS actor2_id  
    FROM
        film_actor fa1    
    INNER JOIN
        film_actor fa2   
        ON fa1.film_id = fa2.film_id 
    WHERE
        fa1.actor_id < fa2.actor_id  
                                    
)
SELECT
    film_id,
    actor1_id,
    actor2_id
FROM
    ActorPairsInSameFilm
ORDER BY
    film_id,       
    actor1_id,
    actor2_id;

-- 12. CTE for Recursive Search:
-- a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column

ALTER VIEW Employee_details AS (
    SELECT
		st.staff_id,
        s.store_id,
        st.first_name,
        st.last_name,
        s.manager_staff_id
    FROM staff st
    JOIN store s ON s.store_id = st.store_id
);

WITH  RECURSIVE EMPLOYEE_LEVEL AS (
SELECT  
		staff_id
        store_id,
        first_name,
        last_name,
        manager_staff_id,
        0 as level
    FROM Employee_details
    where manager_staff_id = 1

    union all
    
SELECT 
        ED.staff_id,
        ED.store_id,
        ED.first_name,
        ED.last_name,
        ED.manager_staff_id,
		level + 1
	FROM  Employee_details AS ED
	JOIN EMPLOYEE_LEVEL AS EL ON EL.store_id = ED.manager_staff_id

)

SELECT * FROM EMPLOYEE_LEVEL;
