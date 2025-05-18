# DataAnalytics-Assessment

# 📊 Overview
This project focuses on analyzing customer behavior and financial activity using SQL. The data spans across multiple tables, including customer details, savings account transactions, and investment plans and withdrawal transactions. The goal is to derive actionable insights for cross-selling, transaction behavior, inactivity monitoring, and customer lifetime value estimation.

# 📁 Tables Used
~ users_customuser – Contains user profile information (e.g., name, date joined).
~ savings_savingsaccount – Logs all transactions (inflows and outflows) per customer.
~ plans_plan – Contains plan metadata including whether a plan is a regular savings or an investment fund

## 🧩 Q1: Cross-Selling Opportunity
Objective: Identify customers with funded savings and investment plans, to target for cross-sell campaigns.
Approach:
  •	Filter plans_plan where:
      •	is_regular_savings = 1 for savings
      •	is_a_fund = 1 for investments
  •	Join with savings_savingsaccount to check for confirmed inflows (confirmed_amount > 0).
  •	Count distinct funded plans per type (savings vs investment) per customer.
  •	Sum total deposits using confirmed_amount.
  •	Final query aggregates this into a customer-wise summary:
    -->	owner_id | full name | savings_count | investment_count | total_deposits

## 🧩 Q2: Transaction Frequency Analysis
Objective: Segment customers based on how often they transact monthly.
Approach:
  •	Limit to the last 12 months of data while storing into a temp table (cte) to be able to call it back for reference in the following subqueries.
  •	Use a CASE statement to categorize:
      •	High Frequency: ≥10/month
      •	Medium Frequency: 3–9/month
      •	Low Frequency: ≤2/month
  •	Count total transactions per customer, divide by 12 to get average monthly frequency.
  •	Group and count customers in each frequency category.
  •	Used ROUND() to format average values cleanly.
  •	Final query aggregates this into a customer-wise summary:
    --> frequency_category | customer_count | avg_transactions_per_month

## 
