{{ config(materialized='view') }}
SELECT  *
FROM {{ ref("product_type_sns") }} s