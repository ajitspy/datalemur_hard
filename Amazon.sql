/*
Given the reviews table, write a query to get the average stars for each product every month.

The output should include the month in numerical value, product id, and average star rating rounded to two decimal places. Sort the output based on month followed by the product id.

P.S. If you've read the Ace the Data Science Interview, and liked it, consider writing us a review?

reviews Table:
Column Name	Type
review_id	integer
user_id	integer
submit_date	datetime
product_id	integer
stars	integer (1-5)
reviews Example Input:
review_id	user_id	submit_date	product_id	stars
6171	123	06/08/2022 00:00:00	50001	4
7802	265	06/10/2022 00:00:00	69852	4
5293	362	06/18/2022 00:00:00	50001	3
6352	192	07/26/2022 00:00:00	69852	3
4517	981	07/05/2022 00:00:00	69852	2
Example Output:
mth	product	avg_stars
6	50001	3.50
6	69852	4.00
7	69852	2.50
Explanation
In June (month #6), product 50001 had two ratings - 4 and 3, resulting in an average star rating of 3.5.

The dataset you are querying against may have different input & output - this is just an example!**/
SELECT date_part('month',(submit_date)),product_id,round(avg(stars),2)
FROM reviews
group by date_part('month',(submit_date)),product_id
order by date_part('month',(submit_date)),product_id
/*Assume you are given the table containing information on Amazon customers and their spending on products in various categories.

Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.

product_spend Table:
Column Name	Type
category	string
product	string
user_id	integer
spend	decimal
transaction_date	timestamp
product_spend Example Input:
category	product	user_id	spend	transaction_date
appliance	refrigerator	165	246.00	12/26/2021 12:00:00
appliance	refrigerator	123	299.99	03/02/2022 12:00:00
appliance	washing machine	123	219.80	03/02/2022 12:00:00
electronics	vacuum	178	152.00	04/05/2022 12:00:00
electronics	wireless headset	156	249.90	07/08/2022 12:00:00
electronics	vacuum	145	189.00	07/15/2022 12:00:00
Example Output:
category	product	total_spend
appliance	refrigerator	299.99
appliance	washing machine	219.80
electronics	vacuum	341.00
electronics	wireless headset	249.90
The dataset you are querying against may have different input & output - this is just an example!
*/
with cte as (select category , 
        product ,
        sum(spend	) sm,
        row_number() over(partition by category order by sum(spend) desc) rn
from product_spend 
where EXTRACT(year from transaction_date) =2022
group by category, product
)
select category,
        product,
        sm
from cte 
where rn in (1,2)
/* In an effort to identify high-value customers, Amazon asked for your help to obtain data about users who go on shopping sprees. A shopping spree occurs when a user makes purchases on 3 or more consecutive days.

List the user IDs who have gone on at least 1 shopping spree in ascending order.

transactions Table:
Column Name	Type
user_id	integer
amount	float
transaction_date	timestamp
transactions Example Input:
user_id	amount	transaction_date
1	9.99	08/01/2022 10:00:00
1	55	08/17/2022 10:00:00
2	149.5	08/05/2022 10:00:00
2	4.89	08/06/2022 10:00:00
2	34	08/07/2022 10:00:00
Example Output:
user_id
2
Explanation
In this example, user_id 2 is the only one who has gone on a shopping spree.

The dataset you are querying against may have different input & output - this is just an example!*/
select t1.user_id 
from transactions t1 join transactions t2
  on date(t1.transaction_date) = date(t2.transaction_date) + 1
      and t1.user_id = t2.user_id
    join transactions t3 on date(t1.transaction_date) = date(t3.transaction_date) + 2
          and t1.user_id = t3.user_id
 /*Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse. It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a SQL query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. Output the item type and number of items to be stocked.

inventory table:
Column Name	Type
item_id	integer
item_type	string
item_category	string
square_footage	decimal
inventory Example Input:
item_id	item_type	item_category	square_footage
1374	prime_eligible	mini refrigerator	68.00
4245	not_prime	standing lamp	26.40
2452	prime_eligible	television	85.00
3255	not_prime	side table	22.60
1672	prime_eligible	laptop	8.50
Example Output:
item_type	item_count
prime_eligible	9285
not_prime	6
The dataset you are querying against may have different input & output - this is just an example!

To prioritise storage of prime_eligible items:

The combination of the prime_eligible items has a total square footage of 161.50 sq ft (68.00 sq ft + 85.00 sq ft + 8.50 sq ft).

To prioritise the storage of the prime_eligible items, we find the number of times that we can stock the combination of the prime_eligible items which are 3,095 times, mathematically expressed as: 500,000 sq ft / 161.50 sq ft = 3,095 items

Then, we multiply 3,095 times with 3 items (because we're asked to output the number of items to stock), which gives us 9,285 items.

Stocking not_prime items with remaining storage space:

After stocking the prime_eligible items, we have a remaining 157.50 sq ft (500,000 sq ft - (3,095 times x 161.50 sq ft).

Then, we divide by the total square footage for the combination of 2 not_prime items which is mathematically expressed as 157.50 sq ft / (26.40 sq ft + 22.60 sq ft) = 3 times so the total number of not_prime items that we can stock is 6 items (3 times x (26.40 sq ft + 22.60 sq ft)). */
WITH summary AS (  
  SELECT  
    item_type,  
    SUM(square_footage) AS total_sqft,  
    COUNT(*) AS item_count  
  FROM inventory  
  GROUP BY item_type
),
prime_items AS (  
  SELECT  
    DISTINCT item_type,
    total_sqft,
    TRUNC(500000/total_sqft,0) AS prime_item_combo,
    (TRUNC(500000/total_sqft,0) * item_count) AS prime_item_count
  FROM summary  
  WHERE item_type = 'prime_eligible'
),
non_prime_items AS (  
  SELECT
    DISTINCT item_type,
    total_sqft,  
    TRUNC(
      (500000 - (SELECT prime_item_combo * total_sqft FROM prime_items))  
      / total_sqft, 0) * item_count AS non_prime_item_count  
  FROM summary
  WHERE item_type = 'not_prime')

SELECT 
  item_type,  
  prime_item_count AS item_count  
FROM prime_items  
UNION ALL  
SELECT  
  item_type,  
  non_prime_item_count AS item_count  
FROM non_prime_items;
/* Amazon is trying to identify their high-end customers. To do so, they first need your help to write a query that obtains the most expensive purchase made by each customer. Order the results by the most expensive purchase first.

transactions Table:
Column Name	Type
transaction_id	integer
customer_id	integer
purchase_amount	integer
transactions Example Input:
transaction_id	customer_id	purchase_amount
1	1	150
2	1	35.90
3	2	349.99
4	2	199.95
5	2	551.20
6	3	13.30
Example Output:
customer_id	purchase_amount
2	551.20
1	150
3	13.30
Explanation:
User 1 have 2 purchases (150 and 35.90) with 150 being the most expensive purchase whereas user 2 have 3 purchases (349.99, 199.95, and 551.20) and 551.20 is their most expensive purchase.

User 3 only have 1 purchase at 13.30 and hence it's their most expensive purchase. The output is then sorted by the most expensive purchase to the least expensive.

The dataset you are querying against may have different input & output - this is just an example! */
/*select distinct customer_id,
       max(purchase_amount) over(partition by customer_id) as max_
from transactions
order by max_ desc
*/
select customer_id , 
      max(purchase_amount) as mx_
from transactions
group by customer_id
order by mx_ desc
/*Assume you are given the table below for the purchasing activity by order date and product type. Write a query to calculate the cumulative purchases for each product type over time in chronological order.

Output the order date, product, and the cumulative number of quantities purchased.

total_trans Table:
Column Name	Type
order_id	integer
product_type	string
quantity	integer
order_date	datetime
total_trans Example Input:
order_id	product_type	quantity	order_date
213824	printer	20	06/27/2022 12:00:00
132842	printer	18	06/28/2022 12:00:00
Example Output:
order_date	product_type	cum_purchased
06/27/2022 12:00:00	printer	20
06/28/2022 12:00:00	printer	38
Explanation
On 06/27/2022, 20 printers were purchased. Subsequently, on 06/28/2022, 38 printers were purchased cumulatively (20 + 18 printers).

The dataset you are querying against may have different input & output - this is just an example! */
select order_date,
        product_type,
        sum(quantity) over( partition by product_type order by order_date )
from total_trans 
order by order_date

