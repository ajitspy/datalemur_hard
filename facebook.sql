/*Assume you are given the tables below about Facebook pages and page likes. Write a query to return the page IDs of all the Facebook pages that don't have any likes. The output should be in ascending order.

pages Table:
Column Name	Type
page_id	integer
page_name	varchar
pages Example Input:
page_id	page_name
20001	SQL Solutions
20045	Brain Exercises
20701	Tips for Data Analysts
page_likes Table:
Column Name	Type
user_id	integer
page_id	integer
liked_date	datetime
page_likes Example Input:
user_id	page_id	liked_date
111	20001	04/08/2022 00:00:00
121	20045	03/12/2022 00:00:00
156	20001	07/25/2022 00:00:00
Example Output:
page_id
20701
Explanation: The page with ID 20701 has no likes.

The dataset you are querying against may have different input & output - this is just an example! */
SELECT p.page_id 
FROM pages p left join page_likes pl
on p.page_id = pl.page_id
where pl.liked_date is null
order by 1 asc
/* Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

p.s. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?

posts Table:
Column Name	Type
user_id	integer
post_id	integer
post_date	timestamp
post_content	text
posts Example Input:
user_id	post_id	post_date	post_content
151652	599415	07/10/2021 12:00:00	Need a hug
661093	624356	07/29/2021 13:00:00	Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend
004239	784254	07/04/2021 11:00:00	Happy 4th of July!
661093	442560	07/08/2021 14:00:00	Just going to cry myself to sleep after watching Marley and Me.
151652	111766	07/12/2021 19:00:00	I'm so done with covid - need travelling ASAP!
Example Output:
user_id	days_between
151652	2
661093	21
The dataset you are querying against may have different input & output - this is just an example!*/
SELECT user_id, 
       
      date_part('day',max(post_date) - min(post_date)) as diff_
FROM posts
where date_part('year',post_date) =2021
group by user_id 
having count(post_id)>1
/*Assume you have an events table on app analytics. Write a query to get the app’s click-through rate (CTR %) in 2022. Output the results in percentages rounded to 2 decimal places.

Notes:

Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions
To avoid integer division, you should multiply the click-through rate by 100.0, not 100.
events Table:
Column Name	Type
app_id	integer
event_type	string
timestamp	datetime
events Example Input:
app_id	event_type	timestamp
123	impression	07/18/2022 11:36:12
123	impression	07/18/2022 11:37:12
123	click	07/18/2022 11:37:42
234	impression	07/18/2022 14:15:12
234	click	07/18/2022 14:16:12
Example Output:
app_id	ctr
123	50.00
234	100.00
Explanation
App 123 has a CTR of 50.00% because this app receives 1 click out of the 2 impressions. Hence, it's 1/2 = 50.00%.

The dataset you are querying against may have different input & output - this is just an example! */
SELECT
  app_id,round((100.0*
  sum(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)) /
  sum(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) ,2)
FROM events
where date_part('year', timestamp) =2022
group by app_id
/* Assume you have the table below containing information on Facebook user actions. Write a query to obtain the active user retention in July 2022. Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).

Hint: An active user is a user who has user action ("sign-in", "like", or "comment") in the current month and last month.

user_actions Table:
Column Name	Type
user_id	integer
event_id	integer
event_type	string ("sign-in, "like", "comment")
event_date	datetime
user_actionsExample Input:
user_id	event_id	event_type	event_date
445	7765	sign-in	05/31/2022 12:00:00
742	6458	sign-in	06/03/2022 12:00:00
445	3634	like	06/05/2022 12:00:00
742	1374	comment	06/05/2022 12:00:00
648	3124	like	06/18/2022 12:00:00
Example Output for June 2022:
month	monthly_active_users
6	1
Example
In June 2022, there was only one monthly active user (MAU), user_id 445.

Note: We are showing you output for June 2022 as the user_actions table only have event_dates in June 2022. You should work out the solution for July 2022.

The dataset you are querying against may have different input & output - this is just an example!*/
with july as (select user_id
    from user_actions
      where date_part('month',event_date) =7
      and event_type in ('sign-in', 'like', 'comment')

),
june as(
select user_id	
from user_actions
      where date_part('month',event_date) =6
      and event_type in ('sign-in', 'like', 'comment')

   )
select 7  , count(distinct july.user_id)
from july join june
  on july.user_id = june.user_id
  


