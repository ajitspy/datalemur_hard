/*UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.

If you like this question, try out Patient Support Analysis (Part 2)!

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_received	timestamp
call_duration_secs	integer
original_order	integer
callers Example Input:
policy_holder_id	case_id	call_category	call_received	call_duration_secs	original_order
50837000	dc63-acae-4f39-bb04	claims	03/09/2022 02:51:00	205	130
50837000	41be-bebe-4bd0-a1ba	IT_support	03/12/2022 05:37:00	254	129
50936674	12c8-b35c-48a3-b38d	claims	05/31/2022 7:27:00	240	31
50886837	d0b4-8ea7-4b8c-aa8b	IT_support	03/11/2022 3:38:00	276	16
50886837	a741-c279-41c0-90ba		03/19/2022 10:52:00	131	325
50837000	bab1-3ec5-4867-90ae	benefits	05/13/2022 18:19:00	228	339
Example Output:
member_count
1
Explanation:
The only caller who made 3 or more calls is member ID 50837000.

The dataset you are querying against may have different input & output - this is just an example! */
with cte as(select  policy_holder_id
from callers
where call_received is not null
group by policy_holder_id
having count(case_id) >=3
)
select count(policy_holder_id)
from cte
/*UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

Calls to the Advocate4Me call centre are categorised, but sometimes they can't fit neatly into a category. These uncategorised calls are labelled “n/a”, or are just empty (when a support agent enters nothing into the category field).

Write a query to find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_received	timestamp
call_duration_secs	integer
original_order	integer
callers Example Input:
policy_holder_id	case_id	call_category	call_received	call_duration_secs	original_order
52481621	a94c-2213-4ba5-812d		01/17/2022 19:37:00	286	161
51435044	f0b5-0eb0-4c49-b21e	n/a	01/18/2022 2:46:00	208	225
52082925	289b-d7e8-4527-bdf5	benefits	01/18/2022 3:01:00	291	352
54624612	62c2-d9a3-44d2-9065	IT_support	01/19/2022 0:27:00	273	358
54624612	9f57-164b-4a36-934e	claims	01/19/2022 6:33:00	157	362
Example Output:
call_percentage
40.0
Explanation:
A total of 5 calls were registered. Out of which 2 calls were not categorised. That makes 40.0% (2/5 x 100.0) of the calls uncategorised.

The dataset you are querying against may have different input & output - this is just an example! */
select round((100.0*count(policy_holder_id))/(select count(*) from callers),1)
from callers 
where call_category is NULL
      or call_category ='n/a'
/*UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

Write a query to get the patients who made a call within 7 days of their previous call. If a patient called more than twice in a span of 7 days, count them as once.

If you like this question, try out Patient Support Analysis (Part 4)!

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_received	timestamp
call_duration_secs	integer
original_order	integer
callers Example Input:
policy_holder_id	case_id	call_category	call_received	call_duration_secs	original_order
50837000	dc63-acae-4f39-bb04	claims	3/9/2022 2:51	205	130
50837000	41be-bebe-4bd0-a1ba	IT_support	3/12/2022 5:37	254	129
50837000	bab1-3ec5-4867-90ae	benefits	5/13/2022 18:19	228	339
50936674	12c8-b35c-48a3-b38d	claims	5/31/2022 7:27	240	31
50886837	d0b4-8ea7-4b8c-aa8b	IT_support	3/11/2022 3:38	276	16
50886837	a741-c279-41c0-90ba		3/19/2022 10:52	131	325
Example Output:
patient_count
1
Explanation:
Only patient 50837000 made another call (on March 12th, 2022) within 7 days of the last call (on March 9th, 2022).

The dataset you are querying against may have different input & output - this is just an example!

*/
 WITH CTE AS (select policy_holder_id,
       (extract (EPOCH FROM call_received -
        lead(call_received)
        over(partition by policy_holder_id 
        order by call_received desc)))/(24*60*60) as diff
from callers 
        )
SELECT count(distinct policy_holder_id)
FROM CTE 
where diff <=7
/*UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

A long-call is categorised as any call that lasts more than 5 minutes (300 seconds). What's the month-over-month growth of long-calls?

Output the year, month (both in numerical and chronological order) and growth percentage rounded to 1 decimal place.

callers Table:
Column Name	Type
policy_holder_id	integer
case_id	varchar
call_category	varchar
call_received	timestamp
call_duration_secs	integer
original_order	integer
callers Example Input:
policy_holder_id	case_id	call_category	call_received	call_duration_secs	original_order
50986511	b274-c8f0-4d5c-8704		2022-01-28T09:46:00	252	456
54026568	405a-b9be-45c2-b311	n/a	2022-01-29T16:19:00	397	217
54026568	c4cc-fd40-4780-8a53	benefits	2022-01-30T08:18:00	320	134
54026568	81e8-6abf-425b-add2	n/a	2022-02-20T17:26:00	1324	83
54475101	5919-b9c2-49a5-8091		2022-02-24T18:07:00	206	498
54624612	a17f-a415-4727-9a3f	benefits	2022-02-27T10:56:00	435	19
53777383	dfa9-e5a7-4a9b-a756	benefits	2022-03-19T00:10:00	318	69
52880317	cf00-56c4-4e76-963a	claims	2022-03-21T01:12:00	340	254
52680969	0c3c-7b87-489a-9857		2022-03-21T14:00:00	310	213
54574775	ca73-bf99-46b2-a79b	billing	2022-04-18T14:09:00	181	312
51435044	6546-61b4-4a05-9a5e		2022-04-18T21:58:00	354	439
52780643	e35a-a7c2-4718-a65d	n/a	2022-05-06T14:31:00	318	186
54026568	61ac-eee7-42fa-a674		2022-05-07T01:27:00	404	341
54674449	3d9d-e6e2-49d5-a1a0	billing	2022-05-09T11:00:00	107	450
54026568	c516-0063-4b8f-aa74		2022-05-13T01:06:00	404	270
Example Output:
yr	mth	growth_pct
2022	1	0
2022	2	0
2022	3	50.0
2022	4	-66.7
2022	5	200.0
Explanation:
Call counts: Jan - 2 calls; Feb - 2 calls; Mar - 3 calls; Apr - 1 call; May - 3 calls

In January, the percentage is 0% as there is no previous month's call info.
In February, the percentage is 0% as there is no increase/decrease from January.
In March, the growth is +50.0% as there is an increase of 1 call from February.
In April, drop by 66.7% as there is a reduction of 2 calls from March.
Finally, in May, there were 3 calls thus a 200.0% growth from April.
The dataset you are querying against may have different input & output - this is just an example! */
with cte as(SELECT date_part('year',call_received) as year_,
        date_part('month',call_received) as month_,
         count(call_duration_secs) as no_of_call
FROM callers
where call_duration_secs >300
group by 1,2 

)
select year_ , month_ ,round( 100.0 *(no_of_call - 
      lag(no_of_call) over(  order by month_ asc ))/lag(no_of_call) over(  order by month_ asc )
,1) from cte
