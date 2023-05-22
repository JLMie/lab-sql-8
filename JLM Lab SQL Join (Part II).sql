-- Lab | SQL Join (Part II)

USE sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
-- I use "USING" cluase. Otherwise I need to use ON and type all the path to connect the tables. 
SELECT st.store_id, ci.city, co.country
FROM store st
JOIN address ad
USING (address_id)
JOIN city ci
USING (city_id)
JOIN country co 
USING (country_id);

-- 2. Write a query to display how much business, in dollars, each store brought in.
-- PATH WAY: STORE -> INVENTORY -> RENTAL -> PAYMENT. 

SELECT st.store_id, CONCAT('$', SUM(py.amount)) AS total_dollars
FROM payment py
JOIN rental r ON py.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store st ON i.store_id = st.store_id
GROUP BY st.store_id;

-- 3. Which film categories are longest?

SELECT ca.name, SUM(fi.length) AS top_longest_categories
FROM category ca 
JOIN film_category fica ON ca.category_id = fica.category_id
JOIN film fi ON fica.film_id = fi.film_id
GROUP BY ca.name
ORDER BY top_longest_categories DESC;
-- WAY: CATEGORY -> FILM_CATEGORY -> FILM

-- Longest film. 
SELECT title, length AS longest_film
FROM film
ORDER BY length DESC
LIMIT 1;

-- 4. Display the most frequently rented movies in descending order.
-- Table Way:  rental_id -> RENTAL -> inventory_id -> INVENTORY -> film_id -> FILM 
SELECT COUNT(re.rental_id) as frequency_rented, fi.title
FROM rental re JOIN inventory USING (inventory_id)

JOIN film fi USING (film_id)

GROUP BY fi.title ORDER BY frequency_rented DESC;

-- 5. List the top five genres in gross revenue in descending order.
-- Table way CATEGORY -> category_id -> FILM_CATEGORY -> film_id -> FILM -> film_id -> INVENTORY -> inventory_id -> RENTAL -> rental_id -> PAYMENT -> customer_id
SELECT cat.name, SUM(py.amount) AS gross_revenue
FROM category cat JOIN film_category USING (category_id)

JOIN film USING (film_id)
JOIN inventory USING (inventory_id)
JOIN rental USING (rental_id)
JOIN payment USING (customer_id)

GROUP BY cat.name
ORDER BY gross_revenue DESC
LIMIT 1;
#WHY IT DOES NOT WORK?

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
-- JOIN PATH: INVENTORY -> store_id -> STORE -> inventory_id -> RENTAL
SELECT fi.film_id, fi.title, st.store_id, inv.inventory_id
FROM film fi 
JOIN inventory inv
USING (film_id) 
JOIN  store st
USING (store_id)
WHERE fi.title = 'Academy Dinosaur' AND st.store_id = 1;

-- 7. Get all pairs of actors that worked together.

SELECT f.film_id, fa1.actor_id, fa2.actor_id,CONCAT(a1.first_name," ", a1.last_name), CONCAT(a2.first_name," ", a2.last_name)
FROM film f
JOIN film_actor fa1
ON f.film_id=fa1.film_id
JOIN actor a1
ON fa1.actor_id=a1.actor_id
JOIN film_actor fa2
ON f.film_id=fa2.film_id
JOIN actor a2
ON fa2.actor_id=a2.actor_id;