-- compare key-figures in fact_sales with verified numbers
SELECT 
*
FROM 
(
SELECT 
ordersource
, reporting_date
, sum(gross_profit) gross_profit
, round(sum(revenue), 0) revenue
FROM {{ ref("fact_sales") }}
GROUP BY ordersource, reporting_date
) calc_values
LEFT join
(
SELECT
ordersource
, reporting_date
, gross_profit
, round(revenue, 0) revenue
FROM
(
	SELECT 'rs' ordersource, '2022-03-07 23:59:59.000' reporting_date, 114542.05 gross_profit, 109913.20 revenue
	UNION ALL
	SELECT 'rs' ordersource, '2022-03-14 23:59:59.000' reporting_date, 229069.70 gross_profit, 219821.54 revenue
	UNION ALL
	SELECT 'ws' ordersource, '2022-03-14 23:59:59.000' reporting_date, 32722.25 gross_profit, 32053.58 revenue
	UNION ALL
	SELECT 'ws' ordersource, '2022-03-21 23:59:59.000' reporting_date, 61783.35 gross_profit, 60514.53 revenue
	UNION ALL
	SELECT 'ws' ordersource, '2022-03-28 23:59:59.000' reporting_date, 71384.55 gross_profit, 69909.71 revenue
	UNION ALL
	-- different values due to different interpretation of the orders 'RS0001935', 'RS0001936' delivered in period 3 again... 
	-- ...we assume it to be a different (additional) part of the order, not replacing the first to positions (different products) 
	SELECT 'rs' ordersource, '2022-03-21 23:59:59.000' reporting_date, 340175.65+336 gross_profit, 326889.65+293.19 revenue
	UNION ALL
	SELECT 'rs' ordersource, '2022-03-28 23:59:59.000' reporting_date, 340175.65+336 gross_profit, 326889.65+293.19 revenue
)
) comp_values
ON calc_values.ordersource=comp_values.ordersource
AND calc_values.reporting_date=comp_values.reporting_date
WHERE 
calc_values.gross_profit<>COALESCE(comp_values.gross_profit, 0) 
OR  calc_values.revenue<> COALESCE(comp_values.revenue, 0)
ORDER BY calc_values.reporting_date, calc_values.ordersource