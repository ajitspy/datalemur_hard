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
