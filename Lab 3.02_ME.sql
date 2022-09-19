-- Lab | SQL Subqueries 3.03

USE sakila;


-- 1. How many copies of the film Hunchback Impossible exist in the inventory system

SELECT f.title, COUNT(i.inventory_id) AS 'Nr Copies'
FROM sakila.inventory i
INNER JOIN sakila.film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;


-- 2. List all films whose length is longer than the average of all the films.

SELECT title, length
FROM sakila.film
WHERE length > (SELECT AVG(length) AS 'Average length' FROM sakila.film)
ORDER BY length ASC;



-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id IN (SELECT actor_id
FROM sakila.film_actor
WHERE film_id in (SELECT film_id
FROM sakila.film
WHERE title = 'ALONE TRIP'));




-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT film_id, title FROM sakila.film
WHERE film_id IN (SELECT film_id
FROM sakila.film_category
WHERE category_id IN (SELECT category_id FROM sakila.category WHERE name = 'Family'));


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

	-- OPTION 1 - JOINS
SELECT c.first_name, c.last_name, c.email FROM sakila.customer c
INNER JOIN sakila.address a USING (address_id)
INNER JOIN sakila.city ci USING (city_id)
INNER JOIN sakila.country co USING (country_id)
WHERE co.country = 'Canada';


-- OPTION 2 - SUBQUERIES
SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (SELECT address_id FROM sakila.address
WHERE city_id IN (SELECT city_id FROM sakila.city
WHERE country_id IN (SELECT country_id FROM sakila.country
WHERE country = 'Canada')));


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT film_id
	FROM sakila.film_actor
	WHERE actor_id IN(SELECT actor_id
		FROM (SELECT actor_id, COUNT(actor_id) AS 'Count films'
			FROM sakila.film_actor
			GROUP BY actor_id
			ORDER BY actor_id DESC
            LIMIT 1) sub1
		);
            
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT film_id, title
FROM sakila.film
WHERE film_id IN (
SELECT inventory_id 
FROM sakila.rental
WHERE customer_id IN (
SELECT customer_id FROM (SELECT customer_id, SUM(amount) 
FROM sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1) sub1));

-- 8. Customers who spent more than the average payments.

SELECT customer_id, AVG(amount) AS 'Average payments'
FROM sakila.payment
GROUP BY customer_id
HAVING AVG(amount) > (SELECT AVG(amount) FROM sakila.payment)
ORDER BY AVG(amount) DESC;