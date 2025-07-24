-- Column for average monthly transaction(s) of each customer
-- Creating a cte for ease this query invloves calculations and referencing results..

with avg_trx_per_customer as (
		select owner_id, count(*) / 12 as avg_trx_per_month -- average monthly transaction per customer
		from savings_savingsaccount
        -- date segment range was not explicitly specified
        -- filter the date to cover transactions for the last 12 months so as to keep it more current
		where transaction_date >= date_sub(date_format(current_date, '%Y-%m-01'), interval 12 month)
		group by owner_id
),

-- Establishing freqeuncy categories
cus_category as (
		select owner_id,
			case
				when avg_trx_per_month >= 10 then 'High Frequency'
                when avg_trx_per_month >= 3 and avg_trx_per_month <= 9 then 'Medium Frequency'
                else 'Low Frequency'
			end as frequency_category,
            avg_trx_per_month
		from avg_trx_per_customer
)
select frequency_category, count(*) as customer_count,
round(avg(avg_trx_per_month), 1) as avg_transactions_per_month -- average of total monthly transactions
from cus_category
group by  frequency_category
order by field(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency')
;

-- The sum of customer_count is significantly less than the sum total of all registered customers
-- This is because this table only reflects only customers who have made transactions in the last 12 months
-- In other words, active customers totalling 742
