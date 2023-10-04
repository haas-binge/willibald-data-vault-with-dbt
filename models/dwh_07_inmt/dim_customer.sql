{{ config(materialized='table') }}
SELECT  *
FROM {{ ref("customer_bs") }} s