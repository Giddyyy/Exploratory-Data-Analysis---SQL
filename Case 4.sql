select u.id as customer_id,
-- Assuming 'name' column hasn't been populated up till this point...
concat(u.first_name, ' ', last_name) as `name`,
-- Account Tenure: Months since signup(date_joined)
-- Datediff returns values in days, so using TIMESTAMPDIFF instead as it is more flexible
timestampdiff(month, u.date_joined, current_date) as tenure_months,
-- Total transactions count
count(s.owner_id) as total_transactions,
-- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
-- profit_per_transaction is 0.1% of the transaction value
-- rounded up to 2 decimal place
round((count(s.owner_id) / nullif(timestampdiff(month, u.date_joined, current_date), 0)) * 12 * 0.001, 2) as estimated_clv
from users_customuser u
left join savings_savingsaccount s
	on u.id = s.owner_id
group by u.id, u.first_name, u.last_name, u.date_joined
order by estimated_clv desc
;
