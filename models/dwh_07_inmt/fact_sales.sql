{{ config(materialized='table') }}
SELECT  *
FROM {{ ref("sales_bb") }} s