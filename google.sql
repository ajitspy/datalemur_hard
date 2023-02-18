/*Assume you are given the table below containing the information on the searches attempted and the percentage of invalid searches by country. Write a query to obtain the percentage of invalid searches.

Output the country in ascending order, total searches and overall percentage of invalid searches rounded to 2 decimal places.

Notes:

num_search = Number of searches attempted; invalid_result_pct = Percentage of invalid searches.
In cases where countries have search attempts but do not have a percentage of invalid searches in invalid_result_pct, it should be excluded, and vice versa.
To find the percentages, multiply by 100.0 and not 100 to avoid integer division.
search_category Table:
Column Name	Type
country	string
search_cat	string
num_search	integer
invalid_result_pct	decimal
search_category Example Input:
country	search_cat	num_search	invalid_result_pct
UK	home	null	null
UK	tax	98000	1.00
UK	travel	100000	3.25
Example Output:
country	total_search	invalid_searches_pct
UK	198000	2.14
Example: UK had 98,000 * 1% + 100,000 x 3.25% = 4,230 invalid searches, out of the total 198,000 searches, resulting in a percentage of 2.14%.

The dataset you are querying against may have different input & output - this is just an example! */
with cte as(select country,
      num_search,
      num_search*invalid_result_pct as ct_
      
from search_category
where invalid_result_pct is not null
)
select country ,
       sum(num_search),
      round(sum(ct_)/sum(num_search),2)
from cte
group by country

/*This is the same question as problem #28 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table containing measurement values obtained from a Google sensor over several days. Measurements are taken several times within a given day.

Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns. Refer to the Example Output below for the output format.

Definition:

1st, 3rd, and 5th measurements taken within a day are considered odd-numbered measurements and the 2nd, 4th, and 6th measurements are even-numbered measurements.
measurements Table:
Column Name	Type
measurement_id	integer
measurement_value	decimal
measurement_time	datetime
measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	1109.51	07/10/2022 09:00:00
135211	1662.74	07/10/2022 11:00:00
523542	1246.24	07/10/2022 13:15:00
143562	1124.50	07/11/2022 15:00:00
346462	1234.14	07/11/2022 16:45:00
Example Output:
measurement_day	odd_sum	even_sum
07/10/2022 00:00:00	2355.75	1662.74
07/11/2022 00:00:00	1124.50	1234.14
Explanation
On 07/11/2022, there are only two measurements. In chronological order, the first measurement (odd-numbered) is 1124.50, and the second measurement(even-numbered) is 1234.14.

The dataset you are querying against may have different input & output - this is just an example!

 */
 with cte as (
     SELECT *,
     row_number() over(partition by cast(measurement_time as date)
             order by measurement_time ) as rn_ 
FROM measurements
)
select cast(measurement_time as date),
        sum(case when rn_ % 2 != 0 then measurement_value end) as odd_value_sum,
       sum(case when rn_ % 2 = 0 then measurement_value end) as even_value_sum
       
from cte
group by cast(measurement_time as date)
order by cast(measurement_time as date)
/*As a Data Analyst on the Google Maps User Generated Content team, you and your Product Manager are investigating user-generated content (UGC) – photos and reviews that independent users upload to Google Maps.

Write a query to determine which type of place (place_category) attracts the most UGC tagged as "off-topic". In the case of a tie, show the output in ascending order of place_category.

Assumptions:

Some places may not have any tags.
Each UGC upload with the "off-topic" tag will be counted separately.
place_info Table:
Column Name	Type
place_id	integer
place_name	varchar
place_category	varchar
place_info Example Input:
place_id	place_name	place_category
1	Baar Baar	Restaurant
2	Rubirosa	Restaurant
3	Mr. Purple	Bar
4	La Caverna	Bar
maps_ugc_review Table:
Column Name	Type
content_id	integer
place_id	integer
content_tag	varchar
maps_ugc_review Example Input:
content_id	place_id	content_tag
101	1	Off-topic
110	2	Misinformation
153	2	Off-topic
176	3	Harassment
190	3	Off-topic
Example Output:
off_topic_places
Restaurant
Explanation
The restaurants (Baar Baar and Rubirosa) have a total of has 2 UGC posts tagged as "off-topic". The bars only have 1. Restaurant is shown here because it's the type of place with the most UGC tagged as "off-topic".

The dataset you are querying against may have different input & output - this is just an example! */
with cte as(select place_category , 
                  count(content_tag) as cnt_,
             rank() over(order by count(content_tag) desc)  rn   
       
from place_info join maps_ugc_review
      on place_info.place_id = maps_ugc_review.place_id
where lower(content_tag) = 'off-topic'
group by place_category
)
select place_category
from cte 
where rn=1
/*Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

search_frequency Table:
Column Name	Type
searches	integer
num_users	integer
search_frequency Example Input:
searches	num_users
1	2
2	2
3	3
4	1
Example Output:
median
2.5
By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.

The dataset you are querying against may have different input & output - this is just an example! */
with cte as(SELECT *  FROM generate_series(0,(select max(num_users) 
          from search_frequency))
          )--,
--gen as(
select searches
from search_frequency  left join cte 
on num_users > generate_series

--)
--select * --round(PERCENTILE_CONT(0.5) WITHIN group (order by searches asc):: decimal,1)
--from gen
/*Google marketing managers are analyzing the performance of various advertising accounts over the last month. They need your help to gather the relevant data.

Write a query to calculate the return on ad spend (ROAS) for each advertiser across all ad campaigns. Round your answer to 2 decimal places, and order your output by the advertiser_id.

Hint: ROAS = Ad Revenue / Ad Spend

ad_campaigns Table:
Column Name	Type
campaign_id	integer
spend	integer
revenue	float
advertiser_id	integer
ad_campaigns Example Input:
campaign_id	spend	revenue	advertiser_id
1	5000	7500	3
2	1000	900	1
3	3000	12000	2
4	500	2000	4
5	100	400	4
Example Output:
advertiser_id	ROAS
1	0.9
2	4
3	1.5
4	4
Explanation
The example output shows that advertiser_id 1 returned 90% of their ad spend, advertiser_id 2 returned 400% of their ad spend, and so on.

The dataset you are querying against may have different input & output - this is just an example! */
with cte as (select advertiser_id,
                    sum(revenue) as rev_,
                    sum(spend) as spend_
   from ad_campaigns
   group by advertiser_id
 )
 select advertiser_id, round(((rev_ / spend_) :: decimal ),2 )
 from cte
 order by advertiser_id
 /*In consulting, being "on the bench" means you have a gap between two client engagements. Google wants to know how many days of bench time each consultant had in 2021. Assume that each consultant is only staffed to one consulting engagement at a time.

Write a query to pull each employee ID and their total bench time in days during 2021.

Assumptions:

All listed employees are current employees who were hired before 2021.
The engagements in the consulting_engagements table are complete for the year 2022.
staffing Table:
Column Name	Type
employee_id	integer
is_consultant	boolean
job_id	integer
staffing Example Input:
employee_id	is_consultant	job_id
111	true	7898
121	false	6789
156	true	4455
consulting_engagements Table:
Column Name	Type
job_id	integer
client_id	integer
start_date	date
end_date	date
contract_amount	integer
consulting_engagements Example Input:
job_id	client_id	start_date	end_date	contract_amount
7898	20076	05/25/2021 00:00:00	06/30/2021 00:00:00	11290.00
6789	20045	06/01/2021 00:00:00	11/12/2021 00:00:00	33040.00
4455	20001	01/25/2021 00:00:00	05/31/2021 00:00:00	31839.00
Example Output:
employee_id	bench_days
111	328
156	238
Explanation
Employee 111 had 328 days of bench time in 2021.

To calculate the 328 days of bench time for employee id 111, we first calculate their total number of work days between start date 05/25/2021 and end date 06/30/2021. Then we subtract this work time from 365 (days in a year) to get the number of bench days: 328.

The dataset you are querying against may have different input & output - this is just an example! */
select employee_id,365-(
  sum((case when date_part('year', end_date)='2021' then end_date else '12/31/2021' end 
  - case when date_part('year', start_date)='2021' then start_date else '1/1/2021' end))+1) 

from staffing s   JOIN consulting_engagements  c
   on s.job_id = c.job_id
   where lower(is_consultant) ='true'
   group by employee_id
   

