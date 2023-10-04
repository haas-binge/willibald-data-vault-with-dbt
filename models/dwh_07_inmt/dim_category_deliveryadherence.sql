{{ config(materialized='table') }}
SELECT  *
FROM {{ ref("category_deliveryadherence_bs") }} s