-- Using savings_savingsaccount and plans_plan tables -- Join
-- Account type (Savings or Investment) column
-- using CASE to set type conditions
select s.plan_id, s.owner_id,
	case
		when p.is_regular_savings = 1 then 'Savings'
        when p.is_a_fund = 1 then 'Investment'
        else 'Other' -- undefined values for is_regular_savings and/or is_a_fund columns (could include nulls, 0)
	end as `type`,
    -- most recent transaction date 
    max(s.transaction_date) as last_transaction_date,
    -- measuring inactivity days:
    -- i.e, date of last transaction made till most current date
    datediff(current_date, max(s.transaction_date)) as inactivity_days
from savings_savingsaccount s
join plans_plan p
	on s.plan_id = p.id
-- Aggregrate function MAX requiring a group by to execute query
group by s.plan_id, s.owner_id, p.is_regular_savings, p.is_a_fund
-- Since Inactivity range is within the last year, that is 365 days
having datediff(current_date, max(s.transaction_date)) <= 365
order by inactivity_days 
;