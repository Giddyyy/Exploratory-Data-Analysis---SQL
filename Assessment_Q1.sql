-- Preprocessing:
-- Checked or duplicates and found none
-- Name column (first + last names) already exists in table, populated that beforehand
-- Generated queries for each columns
-- Combined all subqueries to produce the expected table

select u.id as owner_id,
-- Adding the concatenation of first and last names to form the 'name' column since the original dataset does not have it populated
CONCAT(u.first_name, ' ', u.last_name) AS `name`,
-- The addition of the above is to ensure that this script works immediately even if the name column is yet to be populated
COALESCE(s.savings_count, 0) AS savings_count,
COALESCE(i.investment_count, 0) AS investment_count,
ROUND(COALESCE(d.total_deposits, 0), 2) AS total_deposits
from users_customuser as u
-- Adding the savings_count column
left join (
		select owner_id, count(*) as savings_count
		from plans_plan
		where is_regular_savings = 1
		group by owner_id
) s on u.id = s.owner_id
-- Adding the investment_count column
left join (
		select owner_id, count(*) as investment_count
		from plans_plan
		where is_a_fund = 1
		group by owner_id
) i on u.id = i.owner_id
-- Adding the total_deposits column
left join (
		select owner_id, 
        sum(confirmed_amount) / 100 as total_deposits -- converting from kobo to naira
		from savings_savingsaccount
		group by owner_id
) d on u.id = d.owner_id
where s.savings_count is not null and i.investment_count is not null
order by total_deposits desc
;
