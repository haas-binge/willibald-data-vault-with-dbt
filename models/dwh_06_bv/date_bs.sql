{{ config(materialized='table') }}
WITH date_spine AS (

  {{ dbt_utils.date_spine(
      start_date="to_date('01/01/2022', 'mm/dd/yyyy')",
      datepart="day",
      end_date="dateadd(year, 1, current_date)"
     )
  }}

), calculated as (

    SELECT
      date_day,
      date_day                                                                                AS date_actual,

      DAYNAME(date_day)                                                                       AS day_name,

      DATE_PART('month', date_day)                                                            AS month_actual,
      DATE_PART('year', date_day)                                                             AS year_actual,
      DATE_PART(quarter, date_day)                                                            AS quarter_actual,

      DATE_PART(dayofweek, date_day) + 1                                                      AS day_of_week,
      CASE WHEN day_name = 'Sun' THEN date_day
        ELSE DATEADD('day', -1, DATE_TRUNC('week', date_day)) END                             AS first_day_of_week,

      CASE WHEN day_name = 'Sun' THEN WEEK(date_day) + 1
        ELSE WEEK(date_day) END                                                               AS week_of_year_temp, --remove this column

      CASE WHEN day_name = 'Sun' AND LEAD(week_of_year_temp) OVER (ORDER BY date_day) = '1'
        THEN '1'
        ELSE week_of_year_temp END                                                            AS week_of_year,

      DATE_PART('day', date_day)                                                              AS day_of_month,

      ROW_NUMBER() OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)          AS day_of_quarter,
      ROW_NUMBER() OVER (PARTITION BY year_actual ORDER BY date_day)                          AS day_of_year,

      CASE WHEN month_actual < 2
        THEN year_actual
        ELSE (year_actual+1) END                                                              AS fiscal_year,
      CASE WHEN month_actual < 2 THEN '4'
        WHEN month_actual < 5 THEN '1'
        WHEN month_actual < 8 THEN '2'
        WHEN month_actual < 11 THEN '3'
        ELSE '4' END                                                                          AS fiscal_quarter,

      ROW_NUMBER() OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day)          AS day_of_fiscal_quarter,
      ROW_NUMBER() OVER (PARTITION BY fiscal_year ORDER BY date_day)                          AS day_of_fiscal_year,

      TO_CHAR(date_day, 'MMMM')                                                               AS month_name,

      TRUNC(date_day, 'Month')                                                                AS first_day_of_month,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual, month_actual ORDER BY date_day)    AS last_day_of_month,

      FIRST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                 AS first_day_of_year,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual ORDER BY date_day)                  AS last_day_of_year,

      FIRST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day) AS first_day_of_quarter,
      LAST_VALUE(date_day) OVER (PARTITION BY year_actual, quarter_actual ORDER BY date_day)  AS last_day_of_quarter,

      FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day) AS first_day_of_fiscal_quarter,
      LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year, fiscal_quarter ORDER BY date_day)  AS last_day_of_fiscal_quarter,

      FIRST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day)                 AS first_day_of_fiscal_year,
      LAST_VALUE(date_day) OVER (PARTITION BY fiscal_year ORDER BY date_day)                  AS last_day_of_fiscal_year,

      DATEDIFF('week', first_day_of_fiscal_year, date_actual) +1                              AS week_of_fiscal_year,

      CASE WHEN EXTRACT('month', date_day) = 1 THEN 12
        ELSE EXTRACT('month', date_day) - 1 END                                               AS month_of_fiscal_year,

      LAST_VALUE(date_day) OVER (PARTITION BY first_day_of_week ORDER BY date_day)            AS last_day_of_week,

      (year_actual || '-Q' || EXTRACT(QUARTER FROM date_day))                                 AS quarter_name,

      (fiscal_year || '-' || DECODE(fiscal_quarter,
        1, 'Q1',
        2, 'Q2',
        3, 'Q3',
        4, 'Q4'))                                                                             AS fiscal_quarter_name,
      ('FY' || SUBSTR(fiscal_quarter_name, 3, 7))                                             AS fiscal_quarter_name_fy,
      DENSE_RANK() OVER (ORDER BY fiscal_quarter_name)                                        AS fiscal_quarter_number_absolute,
      fiscal_year || '-' || MONTHNAME(date_day)                                               AS fiscal_month_name,
      ('FY' || SUBSTR(fiscal_month_name, 3, 8))                                               AS fiscal_month_name_fy,

      (CASE WHEN MONTH(date_day) = 1 AND DAYOFMONTH(date_day) = 1 THEN 'New Year''s Day'
        WHEN MONTH(date_day) = 12 AND DAYOFMONTH(date_day) = 25 THEN 'Christmas Day'
        WHEN MONTH(date_day) = 12 AND DAYOFMONTH(date_day) = 26 THEN 'Boxing Day'
        ELSE NULL END)::VARCHAR                                                               AS holiday_desc,
      (CASE WHEN HOLIDAY_DESC IS NULL THEN 0
        ELSE 1 END)::BOOLEAN                                                                  AS is_holiday,
      DATE_TRUNC('month', last_day_of_fiscal_quarter)                                         AS last_month_of_fiscal_quarter,
      IFF(DATE_TRUNC('month', last_day_of_fiscal_quarter) = date_actual, TRUE, FALSE)         AS is_first_day_of_last_month_of_fiscal_quarter,
      DATE_TRUNC('month', last_day_of_fiscal_year)                                            AS last_month_of_fiscal_year,
      IFF(DATE_TRUNC('month', last_day_of_fiscal_year) = date_actual, TRUE, FALSE)            AS is_first_day_of_last_month_of_fiscal_year,
      DATEADD('day',7,DATEADD('month',1,first_day_of_month))                                  AS snapshot_date_fpa,
      DATEADD('day',44,DATEADD('month',1,first_day_of_month))                                 AS snapshot_date_billings,
      COUNT(date_actual) OVER (PARTITION BY first_day_of_month)                               AS days_in_month_count,
      90 - DATEDIFF(day, date_actual, last_day_of_fiscal_quarter)                             AS day_of_fiscal_quarter_normalised,
      12-floor((DATEDIFF(day, date_actual, last_day_of_fiscal_quarter)/7))                    AS week_of_fiscal_quarter_normalised,
      CASE 
        WHEN  week_of_fiscal_quarter_normalised < 5
          THEN week_of_fiscal_quarter_normalised 
        WHEN  week_of_fiscal_quarter_normalised < 9 
          THEN week_of_fiscal_quarter_normalised - 4
        ELSE week_of_fiscal_quarter_normalised - 8
      END                                                                                     AS week_of_month_normalised,
      365 - datediff(day,date_actual,last_day_of_fiscal_year)                                 AS day_of_fiscal_year_normalised,
      CASE 
        WHEN ((DATEDIFF(day, date_actual, last_day_of_fiscal_quarter)-6) % 7 = 0 
                OR date_actual = first_day_of_fiscal_quarter) 
          THEN 1 
        ELSE 0 
      END                                                                                     AS is_first_day_of_fiscal_quarter_week,

      DATEDIFF('day', date_day, last_day_of_month)                                            AS days_until_last_day_of_month 

    FROM date_spine

), current_date_information AS (
  
    SELECT 
      fiscal_year AS current_fiscal_year,
      first_day_of_fiscal_year AS current_first_day_of_fiscal_year,
      fiscal_quarter_name_fy AS current_fiscal_quarter_name_fy,
      first_day_of_month AS current_first_day_of_month
    FROM calculated
    WHERE CURRENT_DATE = date_actual

)

SELECT
  calculated.date_day,
  calculated.date_actual,
  calculated.day_name,
  calculated.month_actual,
  calculated.year_actual,
  calculated.quarter_actual,
  calculated.day_of_week,
  calculated.first_day_of_week,
  calculated.week_of_year,
  calculated.day_of_month,
  calculated.day_of_quarter,
  calculated.day_of_year,
  calculated.fiscal_year,
  calculated.fiscal_quarter,
  calculated.day_of_fiscal_quarter,
  calculated.day_of_fiscal_year,
  calculated.month_name,
  calculated.first_day_of_month,
  calculated.last_day_of_month,
  calculated.first_day_of_year,
  calculated.last_day_of_year,
  calculated.first_day_of_quarter,
  calculated.last_day_of_quarter,
  calculated.first_day_of_fiscal_quarter,
  calculated.last_day_of_fiscal_quarter,
  calculated.first_day_of_fiscal_year,
  calculated.last_day_of_fiscal_year,
  calculated.week_of_fiscal_year,
  calculated.month_of_fiscal_year,
  calculated.last_day_of_week,
  calculated.quarter_name,
  calculated.fiscal_quarter_name,
  calculated.fiscal_quarter_name_fy,
  calculated.fiscal_quarter_number_absolute,
  calculated.fiscal_month_name,
  calculated.fiscal_month_name_fy,
  calculated.holiday_desc,
  calculated.is_holiday,
  calculated.last_month_of_fiscal_quarter,
  calculated.is_first_day_of_last_month_of_fiscal_quarter,
  calculated.last_month_of_fiscal_year,
  calculated.is_first_day_of_last_month_of_fiscal_year,
  calculated.snapshot_date_fpa,
  calculated.snapshot_date_billings,
  calculated.days_in_month_count,
  calculated.week_of_month_normalised,
  calculated.day_of_fiscal_quarter_normalised,
  calculated.week_of_fiscal_quarter_normalised,
  calculated.day_of_fiscal_year_normalised,
  calculated.is_first_day_of_fiscal_quarter_week,
  calculated.days_until_last_day_of_month,
  current_date_information.current_fiscal_year,
  current_date_information.current_first_day_of_fiscal_year,
  current_date_information.current_fiscal_quarter_name_fy,
  current_date_information.current_first_day_of_month
FROM calculated
CROSS JOIN current_date_information

