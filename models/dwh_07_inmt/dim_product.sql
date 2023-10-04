{{ config(materialized='table') }}
select 
hk_product_d 
, product_bk 
, bezeichnung 
, umfang 
, typ 
, preis
, pflanzort
, pflanzabstand 
from {{ ref('product_sns')}}