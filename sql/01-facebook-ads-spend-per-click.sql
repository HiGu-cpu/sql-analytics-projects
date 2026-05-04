/*
Project: Facebook Ads Spend Per Click Analysis
Dataset: facebook_ads_basic_daily
Tool: PostgreSQL / DBeaver

Business Question:
How much money is spent per click on each advertising day?

Key SQL Concepts:
- SELECT statement
- Calculated fields
- NULLIF for division by zero handling
- WHERE filtering
- ORDER BY sorting
*/

SELECT
    ad_date,
    spend,
    clicks,
    spend / NULLIF(clicks, 0) AS spend_per_click
FROM facebook_ads_basic_daily
WHERE clicks > 0
ORDER BY ad_date DESC;
