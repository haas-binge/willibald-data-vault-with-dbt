{{ config(materialized='view') }}
-- this table contains all link information between a order and a customer.
-- in case there is no information in the source-system, which customer made the order, 
-- the creditcard-information should be used to find the link between the order and the customer.
{% set unknown_key = get_dict_hash_value("unknown_key") %}

with cte_relevant_date as
(
	select sdts
	from {{ ref("relevant_date") }} 
)
, cte_order_position as
(
	select s.*
	from {{ ref('order_position_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_order_customer as
(
	select s.*
	from {{ ref('order_customer_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_position as
(
	select s.*
	from {{ ref('position_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_customer as
(
	select s.*
	from {{ ref('customer_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, order_customer_by_creditcard_detail as
(
	select 
		  order_position_sns.sdts
		, order_position_sns.hk_order_h
		, order_position_sns.hk_position_h 
		, customer_sns.hk_customer_h
		, customer_sns.hk_customer_d
		, position_sns.kreditkarte_rs kreditkarte 
		, position_sns.ldts_rs ldts
	from cte_order_position order_position_sns
	inner join cte_position position_sns 
		on order_position_sns.hk_position_h=position_sns.hk_position_h
		and order_position_sns.sdts=position_sns.sdts
	inner join cte_customer customer_sns
	on position_sns.kreditkarte_rs=customer_sns.kreditkarte
		and position_sns.gueltigbis_rs=customer_sns.gueltigbis
		and position_sns.kkfirma_rs=customer_sns.kkfirma
		and position_sns.sdts=customer_sns.sdts
		and customer_sns.kreditkarte <> '{{ var('datavault4dbt.unknown_value__STRING')}}'
)
, order_customer_by_creditcard as 
(
	select distinct 
		  sdts 
		, hk_customer_h
		, hk_customer_d
		, hk_order_h 
		, 'br 1' as rsrc
		, ldts
	from order_customer_by_creditcard_detail
    qualify row_number() over (partition by sdts, hk_order_h order by kreditkarte) = 1
)
, cte_order_customer_customer_join as 
(-- all order_customer-information available in raw vault
	select 
		  os.sdts
		, os.hk_customer_h
		, c.hk_customer_d
		, os.hk_order_h
		, os.ldts_order_customer_rs_es ldts
		, os.rsrc_order_customer_rs_es rsrc
	from cte_order_customer  os
	inner join cte_customer c
		on os.hk_customer_h = c.hk_customer_h
		and os.sdts = c.sdts
	where os.hk_customer_h<> '{{ unknown_key }}'
)
--select * from condensed_selection_order_customer;
select 
	  sdts
	, hk_customer_h
	, hk_customer_d
	, hk_order_h
	, ldts
	, rsrc
from cte_order_customer_customer_join
union all 
select 
	  order_customer_by_creditcard.sdts
	, order_customer_by_creditcard.hk_customer_h
	, order_customer_by_creditcard.hk_customer_d
	, order_customer_by_creditcard.hk_order_h
	, order_customer_by_creditcard.ldts
	, order_customer_by_creditcard.rsrc
from order_customer_by_creditcard
left join cte_order_customer_customer_join cte_order_customer_customer_join
	on order_customer_by_creditcard.hk_order_h=cte_order_customer_customer_join.hk_order_h
	and order_customer_by_creditcard.sdts=cte_order_customer_customer_join.sdts
where cte_order_customer_customer_join.hk_order_h is null