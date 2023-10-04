{{ config(materialized='table') }}
select 
hk_associationpartner_d
, associationpartner_bk
from {{ ref('associationpartner_sns')}}