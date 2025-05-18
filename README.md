# DataAnalytics-Assessment

# 📊 Overview
This project focuses on analyzing customer behavior and financial activity using SQL. 

The data spans across multiple tables, including customer details, savings account transactions, and investment plans and withdrawal transactions.

The goal is to derive actionable insights for cross-selling, transaction behavior, inactivity monitoring, and customer lifetime value estimation.

## 📁 Tables Used
~ users_customuser – Contains customer demographic and contact information.

~ savings_savingsaccount – Contains records of deposit transactions.

~ plans_plan – Contains records of plans created by customers including whether a plan is a regular savings or an investment fund.

### 🧩 Q1: Cross-Selling Opportunity
Objective: Identify customers with funded savings and investment plans, to target for cross-sell campaigns.

Approach:

  •	Filter plans_plan where:
  
      •	is_regular_savings = 1 for savings
      
      •	is_a_fund = 1 for investments
  
  •	Join with savings_savingsaccount to check for confirmed inflows (confirmed_amount > 0).
  
  •	Count distinct funded plans per type (savings vs investment) per customer.
  
  •	Sum total deposits using confirmed_amount.

  • Converted total deposits from kobo to naira and rounded up.
  
  •	Final query summary:
  
    -->	owner_id | full name | savings_count | investment_count | total_deposits

### 🧩 Q2: Transaction Frequency Analysis

Objective: Segment customers based on how often they transact monthly.

Approach:

  •	Limit to the last 12 months of data while storing into a temp table (cte) to be able to call it back for reference in the following subqueries.
  
  •	Used a CASE statement to categorize:
  
      •	High Frequency: ≥10/month
      
      •	Medium Frequency: 3–9/month
      
      •	Low Frequency: ≤2/month
  
  •	Count total transactions per customer, divide by 12 to get average monthly frequency.
  
  •	Group and count customers in each frequency category.
  
  •	Used ROUND() to format average values cleanly.
  
  •	Final query summary:
  
    --> frequency_category | customer_count | avg_transactions_per_month

### 🧩 Q3: Account Inactivity Alert

Objective: Detect savings or investment accounts that haven’t had any inflow for over a year.

Approach:

  •	Join savings_savingsaccount with plans_plan to determine account type.
  
  •	Used MAX(transaction_date) per plan to find the last activity.
  
  •	Calculate inactivity_days.
  
  •	Filter for accounts with inactivity_days > 365 to flag long-term inactivity.
  
  •	Final query summary:
  
    --> plan_id | owner_id | account type | last_transaction_date | no. of days inactive

### 🧩 Q4: Customer Lifetime Value (CLV)

Objective: Estimate how much value each customer brings over their account lifetime.

Approach:

•	Used TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) to calculate account tenure.

•	Count total transactions per customer.

•	Assume profit per transaction = 0.1% of value.

•	CLV formula: CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

•	Ensure division safety using NULLIF(tenure, 0) to avoid errors.

•	Final query summary:

    --> customer_id | full name | tenure_months | total_transactions | estimated_clv

## 💡 Challenges and Solutions

### 1. Query Structuring & Readability

• Challenge: Queries became complex, especially when categorizing or computing over derived values.

• Solution: Broke queries into modular CTEs (Common Table Expressions) for clarity and reusability, then combined them into final outputs

### 2. SQL Function Compatibility

•	Challenge: Some SQL functions like DATE_TRUNC were not supported in my environment.

•	Solution: Replaced with portable alternatives like:

    --> DATE_FORMAT(current_date, '%Y-%m-01')

to simulate monthly truncation in MySQL

### 3. Syntax & Debugging Errors

•	Challenge: Faced multiple errors due to:

  •	Misplaced parentheses (e.g., in ROUND())
  
  •	Incorrect CASE syntax 

•	Solution: Resolved by isolating subqueries, testing piece by piece, and cleaning up SQL syntax as in order.

### 4. Partial User Representation in Outputs

•	Challenge: Not all users from users_customuser appeared in transaction-based outputs. This was evident in Q3 as the total customer count in the results did not tally with the overall registered users.

•	Reason: Only customers with valid transactions in the last 12 months were counted in frequency or CLV tasks.

•	Solution: Clarified scope and aligned expectations accordingly — results were intentional subsets, not total population metrics.

## 🧠 General Approach

For each analysis task, I followed a structured and repeatable process to ensure clarity, accuracy, and adaptability:

### 1. Understand the Business Scenario

  Each task began with a clear understanding of the business goal.

### 2. Inspect Data Structure

I reviewed all relevant tables (users_customuser, savings_savingsaccount, plans_plan) to:

  •	Identify necessary fields
  
  •	Understand foreign key relationships
  
  •	Note available data types (dates, booleans, monetary values)

### 3. Define Metrics Clearly

For each output column (e.g., total_deposits, tenure_months, frequency_category), I:

  •	Established logic for calculation
  
  •	Verified assumptions and given parameters (e.g., inflow = confirmed_amount).

### 4. Build Step-by-Step Queries
  
  Rather than writing complex queries all at once, I:
  
  •	Built each column independently
  
  •	Validated results and assumptions
  
  •	Gradually combined them into a full query, often using CTEs for clarity where necessary

### 5. Handle Edge Cases and Data Quality

  •	Ensured monetary values were converted from kobo to naira
  
  •	Filtered transactions by recency or status when relevant
  
  •	Used COALESCE and conditional logic to handle nulls and prevent skewed results

### 6. Test and Refine

Every query was tested iteratively:

  •	Debugged errors (syntax, logic, joins)
  
  •	Compared intermediate outputs against expectations
  
  •	Cleaned and structured the final results to match business-friendly formats

### 7. Document the Query

Each query includes clear inline comments to explain:
  
  •	Joins and filters
  
  •	Aggregations and logic
  
  •	Business reasoning (e.g., why a certain threshold or classification is used)

## ✅ Tools & Skills Demonstrated
  
  •	SQL Joins & Aggregations
  
  •	CTE usage
  
  •	Conditional logic (CASE)
  
  •	Date and time calculations
  
  •	Data cleaning and formatting (e.g., kobo to naira)
  
  •	Customer segmentation logic

