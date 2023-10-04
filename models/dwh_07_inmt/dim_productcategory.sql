{{ config(materialized='table') }}
SELECT  *
FROM {{ ref("productcategory_bs") }} s