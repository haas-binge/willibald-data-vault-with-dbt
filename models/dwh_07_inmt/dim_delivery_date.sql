SELECT 
date_day AS delivery_date
, CAST(year_actual AS char(4))||'-'||CAST(week_of_year AS char(2)) AS delivery_week
, month_name AS delivery_month 
, year_actual AS delivery_year
FROM {{ ref('date_bs')}}
WHERE date_day BETWEEN to_date('03/01/2022', 'mm/dd/yyyy') AND to_date('04/01/2022', 'mm/dd/yyyy')