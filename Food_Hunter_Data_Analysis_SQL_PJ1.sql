
use foodhunter;
##### SELECT STATEMENT ######
# get me all data from the orders data base?
select * from orders;

# show order_id, delivered_time, final_price, order_ating in the order table
select order_id, delivered_time, final_price, order_rating from orders;
# here you saw that we are only getting 1000 records from the data base. so to get more number of records we will use limit 

###### LIMIT #########

select order_id, delivered_time, final_price, order_rating 
from orders
limit 10000; 
# now our records showing for 10000

######## OFFSET ##########
# now if we want data from 10000 to 20000
select order_id, delivered_time, final_price, order_rating 
from orders
limit 20000 offset 10000; 


# PROBLEM: we heard that the orders or sales is going in downward direction so lets analyse the situation
######### COUNT and DISTINCT ##########
select count(distinct order_id) 
from orders;

# lets find out how many drivers delivered these 43118 orders
select count(distinct driver_id) 
from orders;



##################### ASSIGNMENT #########################
# Q1: show all the data in the restaurants table
select * 
from restaurants;


# Q2: Show only the dishes, their prices and the calories in them from the food items table. Item name: dishes
select item_name, price, calories 
from food_items;

#Q3: Write a query to retrive the order ids, customer_ids and total prices of all orders
select order_id, customer_id, total_price
from orders;

#Q4: write a code to count the number of restaurants in the restaurant table
select count(distinct restaurant_name) 
from restaurants;

#Q5: write a query to find the unique number of cusines served by the restaurants from the restaurants table
select distinct restaurant_name
from restaurants; 


#Q6: write a query to find the number of unique dishes served by the restaurant from the food_items table
select distinct(item_name)
from food_items;


##################### SECTION 2 #####################

####### MIN & MAX ###########

# Lets find out the start date and end date of the orders from orders table.
select min(order_date)
from orders;

select max(order_date)
from orders;


######### >, <, <=, >=, etc ##########


# let's find out the orders between 1st day of order to the last date of the order
select count(order_id)
from orders
where order_date >= '2022-06-01' and order_date <= '2022-06-30';

######### BETWEEN ##########

# same using between
select count(order_id)
from orders
where order_date between '2022-06-01' and '2022-06-30';


####### ALIASING ########
select count(order_id) AS orders
from orders
where order_date between '2022-06-01' and '2022-06-30';


####### GROUP BY ###########
# Definition: to summerise data  based on features or columns

# lets find out the total numbers of orders for each month

select order_date, count(order_id) as orderquantity 
from orders
group by order_date;

###### MONTH() FUNCTION ##########
select month(order_date) as ordermonth, count(order_id) as orderquantity 
from orders
group by month(order_date);


####### ORDER BY ############
select month(order_date) as ordermonth, count(order_id) as orderquantity 
from orders
group by month(order_date)
order by orderquantity desc;

####### SUM #########
select month(order_date) as ordermonth, sum(final_price) as totalrevenue 
from orders
group by month(order_date)
order by totalrevenue desc;

/* In this data set "FoodHunter", we have noticed the gradual decrease of sales and so of the revenue. 
So if we can analyse the factors which are affecting the revenue can be as below
Scenario 1. Time based problems: weekends - family cook together, weekdays - orders depends on time availability
Scenario 2. Revenue related factors: list price - higher listed price, lower order. low amount of offer, low orders
Scenario 3. Delivery partner problems: quality of delivery by delivery partner
Scenario 4. Food Preferences and food quality: breakfast, lunch etc
Scenario 5. Marketing factors: tv ade been decreased or something else marketing has been decreased
Scenario 6. Customer review: Review of the food has been decreased or not

*/

### Scenario 2. Revenue related factors: list price - higher listed price, lower order. low amount of offer, low orders 

# here we will check the discounts per month and the total amount of revenue generated for each month

select month(order_date) as months, sum(final_price) as total_revenue, sum(discount) as total_discount
# Note: "month(column_name) = 1" takes only the month number
from orders
group by months
order by months;

######### ROUND ##########
select month(order_date) as months, round(sum(final_price), 0) as total_revenue, sum(discount) as total_discount
from orders
group by months
order by months;


# Will check the discount and sales ratio
# here we will check if the discount and total revenue ratio to check if the decrease of discount affected the total revenue
select month(order_date) as months,
sum(final_price) as total_revenue, 
sum(discount)/sum(final_price) as discount_sales_ratio,
sum(discount) as total_discount,
count(order_id) as ordercounts
from orders
group by months
order by months;


### Scenario 1. Time based problems: weekends - family cook together, weekdays - orders depends on time availability


####### DAYOFWEEK() FUNCTION ##########
# here we will check the total revenue for week and weekends 
select dayofweek(order_date) as weekdays, sum(final_price) as totalrevenue, count(order_id) as ordercount
from orders
group by weekdays
order by weekdays;

###### CASE STATEMENT ######
# will check if on weekays or weekends have more sales

select sum(final_price) as totalrevenue, count(order_id) as ordercount,
case
when dayofweek(order_date) = 1 then "weekend"
when dayofweek(order_date) = 7 then "weekend"
else "weekday"
end as wdays 
from orders
group by wdays;





##################### ASSIGNMENT #########################
# Q1: Write a query to group the restaurants on the basis of the cuisines served from the restaurants table.
select restaurant_name, cuisine
from restaurants
order by cuisine asc;

# Q2: What is the total number of restaurants under each cuisine?
select count(restaurant_name) as rest_numbers, cuisine
from restaurants
group by cuisine;

# Q3: Write a query to retrieve the restaurant_id and item_names of all the non-vegetarian dishes from the food_items table.
select restaurant_id, item_name
from food_items
where food_type = "non-vegetarian";

# Q4: Write a query to find the number of orders placed on each Monday in the month of September. (Hint: The dates are 5th, 12th, 19th and 26th of September)
select count(order_id), order_date
from orders
where order_date in ( '2022-09-05', '2022-09-12', '2022-09-19', '2022-09-26')
group by order_date
;


# Q5: Write a query to find the number of orders placed during each week in the month of September. Hint: Use cases and group by
select count(order_id) as ordercount,
case
when dayofweek(order_date) between 1 and 7 then "weekone"
when dayofweek(order_date) between 7 and 14 then "weektwo"
when dayofweek(order_date) between 14 and 21 then "weekthree"
else "weekfour"
end as wdays 
from orders
where month(order_date) = 9
group by wdays; ### NOT A CORRECT ANSWER





################## SECTION 3 ###################


# Step 1: Find total revenue for weekdays and weekends over 4 months
# Step 2: Compare values with previous month for weekends and weekdays
# Step 3: Find the percentage change in revenue




/*Step 1: Find total revenue for weekdays and weekends over 4 months*/

# we will findout weekdays, weekends, all 4 months, total revenue

select
case 
when dayofweek(order_date) between 2 and 6 then 'weekdays'
when dayofweek(order_date) in (1, 7) then 'weekends'
end as day_of_week,
month(order_date) as months,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, months
order by day_of_week;

############### SUB-QUERY ################


/*Window functions are mainly of two types.
* Aggregate Window Functions: SUM(), AVG(), MAX(), MIN(), COUNT() 
  Analytical Windows Functions: LAG(), LEAD(), RANK(), DENSE RANK(), ROW NUMBER() */
  
  # Will compare month on month change in revenue
  # we are taking the previous query into next step as subquery
  # Note: we can alias a (table) formed by subquery to any name. (example is in the below query) 
  
### example sample query to understand concept of subquery
select * # outer query
from
(select # inner query
case 
when dayofweek(order_date) between 2 and 6 then 'weekdays'
when dayofweek(order_date) in (1, 7) then 'weekends'
end as day_of_week,
month(order_date) as months,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, months
order by day_of_week) table1 # we can learn here that, output or outcome of a query can act as an input for another select statement.
where day_of_week = 'weekdays';

/*Step 2: Compare values with previous month for weekends and weekdays*/

## WILL USE THE WINDOWS FUNCTION
select * # outer query
, lag(total_revenue) over (partition by day_of_week) as previous_rev
from
(select # inner query
case 
when dayofweek(order_date) between 2 and 6 then 'weekdays'
when dayofweek(order_date) in (1, 7) then 'weekends'
end as day_of_week,
month(order_date) as months,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, months
order by day_of_week) table1;


/*Step 3: Find the percentage change in revenue*/

select *, 
round(((total_revenue-previous_rev)/previous_rev)*100) as percentage_change
 from
(select * # outer query
, lag(total_revenue) over (partition by day_of_week) as previous_rev
from
(select # inner query
case 
when dayofweek(order_date) between 2 and 6 then 'weekdays'
when dayofweek(order_date) in (1, 7) then 'weekends'
end as day_of_week,
month(order_date) as months,
round(sum(final_price),0) as total_revenue
from orders
group by day_of_week, months
order by day_of_week) table1) table2;

## now we can conclude that there is a problem in the weekends only so to maximise the sales, sales should be more in the weekends.

### Task: try to find the percentage change for each days not the week by following the similar way



### Scenario 3. Delivery partner problems: quality of delivery by delivery partner, delivery time - the quicker delivery the more customer satisfaction


## will use the time diff function to check the average delivery time duration taken
# will create one table for average time
# will use grouping for month and also driver_id

# Step 1: finding the average time taken for the delivery
select month(order_date) as months, driver_id, avg(minute(timediff(delivered_time, order_time))) as avg_time
from orders
group by months, driver_id; # here we foundout the average time taken for the delivery

# Step 2: lets find the rank of the driver according to the average time


select months, driver_id, avg_time, rank() over (partition by months order by avg_time) as driver_rank
from
(select month(order_date) as months, driver_id, avg(minute(timediff(delivered_time, order_time))) as avg_time
from orders
group by months, driver_id) as query1;


# Step 3: lets find out the first 5 best performing delibery driver
select * from
(select months, driver_id, avg_time, rank() over (partition by months order by avg_time) as driver_rank
from
(select month(order_date) as months, driver_id, avg(minute(timediff(delivered_time, order_time))) as avg_time
from orders
group by months, driver_id) as query1) as query2
where driver_rank between 1 and 5;



# Step 3: lets find out the first 5 worst performing delibery driver
select * from
(select months, driver_id, avg_time, rank() over (partition by months order by avg_time desc) as driver_rank
from
(select month(order_date) as months, driver_id, avg(minute(timediff(delivered_time, order_time))) as avg_time
from orders
group by months, driver_id) as query1) as query2
where driver_rank between 1 and 5;




## OUTCOME OF FACTORS TILL NOW (DISCUSSED 3 SCENARIOS)

/* In this data set "FoodHunter", we have noticed the gradual decrease of sales and so of the revenue. 
So if we can analyse the factors which are affecting the revenue can be as below
Scenario 1. Time based problems: weekends - family cook together, weekdays - orders depends on time availability ---------------------> WEEKDAYS HAVE MORE REVENUE
Scenario 2. Revenue related factors: list price - higher listed price, lower order. low amount of offer, low orders ------------------> DOWNWARD TREND OVER THE MONTHS
Scenario 3. Delivery partner problems: quality of delivery by delivery partner -------------------------------------------------------> INCREASE IN AVERAGE DELIVERY TIME
Scenario 4. Food Preferences and food quality: breakfast, lunch etc
Scenario 5. Marketing factors: tv ade been decreased or something else marketing has been decreased
Scenario 6. Customer review: Review of the food has been decreased or not

*/



# Q1: Write a SQL query to rank restaurants based on the number of food items they offer. 
# Use a window function to achieve this.


# Step 1: we will find out the number of food items each restaurants offer
select count(distinct cuisine) as no_of_restaurants, restaurant_name
from restaurants
group by restaurant_name
order by no_of_restaurants desc;

# Step 2: finding the rank of the restaurants as per the count of the dishes
select restaurant_name, no_of_cousines, rank() over (order by no_of_cousines desc) as rank_of_rest
from
(select count(distinct cuisine) as no_of_cousines, restaurant_name
from restaurants
group by restaurant_name) as query1;





# Q2: How can we use ranking functions to find the top 3 food items (based on the quantity ordered) 
# for each restaurant?


# Step 1: we will find the item and the order quantity first 
select distinct item_id as items , sum(quantity) as total_ordered_quantity
from orders_items
group by item_id
order by total_ordered_quantity desc;

# Step 2: Now we will find the rank of the item according to the quantity ordered
select items, total_ordered_quantity, rank() over (order by total_ordered_quantity desc) as rank_of_item
from
(select distinct item_id as items , sum(quantity) as total_ordered_quantity
from orders_items
group by item_id
order by total_ordered_quantity ) as query1;

# Q3: How would you classify customers into different categories (like "low", "medium", and "high") 
# based on the total amount they've spent on orders? 
# Write a SQL query using the CASE statement to achieve this.

# Step 1: first we will find the total amount spend on orders
select customers, total_amount,
 case when total_amount >= 100 then 'High'
  when total_amount >= 50 then 'Medium'
  when total_amount >= 0 then 'Low'
  end as 'spent_cat'
from
(select distinct customer_id as customers, final_price as total_amount
from orders) as query1 ;

/* Q4: Write a SQL query to classify orders based on delivery time: "fast" if the delivery time 
is less than 30 minutes, "medium" if it's between 30 minutes and 
1 hour, and "slow" if it's more than 1 hour. 
Then find the number of deliveries that come under “fast” category. */

select count(orders)
from
(select orders,delivered_time,
case when time_to_sec(delivered_time) / 60 >= 60 then 'Slow'
when time_to_sec(delivered_time) / 60 between 30 and 60 then 'Medium'
when time_to_sec(delivered_time) / 60 <= 30 then 'Fast'
end as 'delivery_time'
from
(select distinct order_id as orders, delivered_time
from orders) as query1 /* Step 1: we found the delivery time for each orders */) as query2 /* Step2: case statement for slow, medium and fast delivery*/
where delivery_time = 'Fast' /*Step 3: found the count of deliveries which came for fast categories*/
;



/* Now we will discuss about 3 important factors such as below
1. which type of food was more preferred by the customers?
2. was there a change in monthly revenue based on food preferrences for vegeterian  and non-vegeterian food?
3. which restaurants had the least number of items ordered?
*/



-- Section 4
/*Join Operation in SQL*/

--  we need to find the insights of the food preferences of the customer from the order_items and food_items table.

-- lets have a look what is in there in the orders_items  and food_items table

select * from orders_items;
select * from food_items;
 
select * from orders_items
left join food_items
on orders_items. item_id = food_items. item_id
limit 10;

-- Question is : do we have any description in the food_items table for every item id present in the order_item table 
 

-- lets find out number of orders of each food type
select fi.food_type, sum(oi.quantity) as no_orders
from orders_items oi left join food_items fi
on oi.item_id = fi.item_id
group by fi.food_type;

-- Note: we are noticing that we have 4 different types of food types. veg is mentioned in 2 ways and same for non-veg
-- so we need to mention the vegeterian as veg and the non-vegeterian as non-veg
-- to achieve this goal we can follow the below query


-- Step 1: we will find the new food type and will make the vegeterian to veg and non-vegeterian to non-veg. 
-- we will also find out item_id in the food-items table so that we can easily do join opertation\
 
select item_id, 
case 
 when food_type like "veg%" 
then "veg"
else "non-veg"
end
as new_food_type
from food_items;


-- Step 2: now we got the food type change to our requirement type
-- we need to make the query to findout the numbers of orders for each food type using a single query

select t1. new_food_type, sum(oi. quantity) as total_quantity_ordered
from orders_items oi left join 
 (select item_id, 
 case 
     when food_type like "veg%" 
     then "veg"
     else "non-veg"
     end
     as new_food_type from food_items) as t1
on oi.item_id = t1.item_id
group by t1.new_food_type;




-- Task: find the number of items ordered from each of the restaurants
-- so here we will use trhe tables like restaurants and orders_items

select * from orders_items;
select * from restaurants;
select * from food_items;


-- WAY 1
-- now we will follow below structure
-- (order_items left join food_items) inner join resraurants

-- step 1: we will find out the number of orders with respect to the restaurant id of food items

select fi.restaurant_id, sum(oi.quantity) as order_nos
from orders_items oi left join food_items fi
on oi.item_id = fi.item_id
group by fi.restaurant_id
order by fi.restaurant_id;

-- step 2: now as we found the numbers of orders with respect to the restaurant id,
-- now we need to add the restaurant name for each id

select r.restaurant_name, t1. order_nos
from
(select fi.restaurant_id, sum(oi.quantity) as order_nos
from orders_items oi left join food_items fi
on oi.item_id = fi.item_id
group by fi.restaurant_id) as t1 inner join restaurants r
on r. restaurant_id = t1.restaurant_id
order by order_nos;

-- WAY 2

select r.restaurant_name, r.restaurant_id, r. cuisine, sum(oi.quantity) as total_orders
from restaurants r 
left join food_items fi on r. restaurant_id = fi. restaurant_id
left join orders_items oi on fi. item_id = oi. item_id
group by r. restaurant_id
order by total_orders;







-- Question 1:
-- what is the highest number of orders placed by any customer
select c.customer_id, c.first_name, count(o.order_id) as total_orders
from customers c left join orders o
on c.customer_id = o. customer_id
group by c.customer_id, c.first_name
order by total_orders desc
limit 1;
-- op: 14

-- Question 2: What are the top two most ordered items and their order count?
select fi.item_name, sum(oi. quantity) as count_orders
from orders_items oi inner join food_items fi
on oi. item_id = fi. item_id
group by fi.item_name, fi.item_id
order by count_orders desc
limit 2;
-- note: remember, if you use inner join and using any column from both the table then
-- use group by for both the columns
-- op: shrimp fried rice =341, fried calamari= 339


-- Question 3: what is the average calories per dish for each cuisine type?
-- values are close to nearest integer.
SELECT r.cuisine, AVG(fi.calories) AS avg_calories_per_order
FROM restaurants r
INNER JOIN food_items fi ON r.restaurant_id = fi.restaurant_id
GROUP BY r.cuisine;
-- op: italian - 663, chinese - 534, indian - 578, thai - 589

-- Question 4: what is the highest average order rating of a driver rounded to a decimal place?
SELECT d.name AS driver_name, round (AVG(o.order_rating), 2) AS avg_order_rating
FROM drivers d
LEFT JOIN orders o ON d.driver_id = o.driver_id
GROUP BY d.driver_id, d.name
ORDER BY avg_order_rating DESC
LIMIT 1;
-- op: 3.8



-- Question 5: Fill in the blanks in the below query to retrieve the names of all those customers who have placed an 
-- order with FoodHunter along with the total number of orders they have placed.
/*
SELECT c.customer_id, COUNT(o.order_id) AS total_orders
FROM customers c
__A__ orders o ON c.customer_id = o.customer_id
GROUP BY__B__;

*/
-- Note: You need to use RIGHT JOIN between customers and orders table as there are some customers who have not 
-- placed any order. The results need to be grouped on customer_id to get the count for each customer.


-- Question 6: Fill in the blanks in the below query to find the items which have not been ordered by any customer so far.


/*
SELECT f.item_id, COUNT(__A__) as item_count
FROM orders_items o __B__ food_items f
ON o.item_id = f.item_id
GROUP BY __C__ 
__D__
*/


select f.item_id, count(o.item_id) as item_count
from orders_items o right join food_items f
on o.item_id = f.item_id
group by f.item_id 
having item_count=0;