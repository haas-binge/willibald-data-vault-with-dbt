SELECT 
date_day AS reporting_date
, month_name AS reporting_month 
, year_actual AS reporting_year
, CAST(year_actual AS char(4))||'-'||CAST(week_of_year AS char(2)) AS reporting_week
FROM {{ ref('date_bs')}}
WHERE date_day BETWEEN to_date('03/01/2022', 'mm/dd/yyyy') AND to_date('04/01/2022', 'mm/dd/yyyy')