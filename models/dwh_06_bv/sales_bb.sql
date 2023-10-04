with cte_relevant_date as
(
	select sdts
	from {{ ref("relevant_date") }} 
),
cte_const as
(
	select '{{ datavault4dbt.beginning_of_all_times() }}' as beginning_of_all_times
		 , '{{ get_dict_hash_value('unknown_key') }}' as unknown_key
)
, cte_order as
(
select 
	  s.sdts
	, s.hk_order_h
	, s.order_bk
	, s.bestelldatum
	, s.wunschdatum
	, s.rabatt
	, s.rsrc 
	, s.ldts 
from {{ ref('order_sns') }} s
cross join cte_const
cross join cte_relevant_date
where 1=1
and s.hk_order_h<> cte_const.unknown_key -- ghost-record
and s.sdts = cte_relevant_date.sdts
--and order_sns.sdts='2022-02-01 07:30:00.000'
--and order_bk in ('320')--'rs0002003','1000', 'rs0002458', '2028')
)
, cte_position_product as
(
	select s.*
	from {{ ref('position_product_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_order_position as
(
	select s.*
	from {{ ref('order_position_sns') }} s
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
, cte_productcategory_hierarchy as
(
	select s.*
	from {{ ref('productcategory_hierarchy_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_productcategory as
(
	select s.*
	from {{ ref('productcategory_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_product as
(
	select s.*
	from {{ ref('product_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_product_productcategory as
(
	select s.*
	from {{ ref('product_productcategory_sns') }} s
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_order_associationpartner as
(
	select s.*, p.hk_associationpartner_d
	from {{ ref('order_associationpartner_sns') }} s
	inner join {{ ref('associationpartner_snp') }} p
		on s.hk_associationpartner_h = p.hk_associationpartner_h
		and s.sdts = p.sdts										
	cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
)
, cte_customer_associationpartner as
(
	select s.*, p.hk_associationpartner_d
	from {{ ref('customer_associationpartner_sns') }} s
	inner join {{ ref('associationpartner_snp') }} p
		on s.hk_associationpartner_h = p.hk_associationpartner_h
		and s.sdts = p.sdts										
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
, cte_position_join as 
(
select 
	  order_position_sns.hk_order_h
	, position_sns.hk_position_h
	, position_sns.position_bk
	, position_sns.has_rs_data
	, position_sns.has_ws_data
	, case when position_sns.has_rs_data
	       then position_sns.menge_rs
	       else menge end as amount
	, cast(case when position_sns.has_rs_data
	       then position_sns.preis_rs
	       else replace(replace(position_sns.preis, '€',''), ',', '.')
		   end as numeric(28,10) ) price
	, position_sns.rabatt_rs	   
	, position_sns.kaufdatum_rs
	, case when order_position_sns.rsrc_order_position_rs_sts <>''
	       then order_position_sns.rsrc_order_position_rs_sts
		   else order_position_sns.rsrc_order_position_ws_sts 
		   end as rsrc
	, case when order_position_sns.ldts_order_position_rs_sts <>'0001-01-01 00:00:01.000'
	       then order_position_sns.ldts_order_position_rs_sts
		   else order_position_sns.ldts_order_position_ws_sts 
		   end as ldts	   
	, order_position_sns.sdts
from cte_order_position order_position_sns
inner join cte_position position_sns
	on order_position_sns.hk_position_h=position_sns.hk_position_h
	and order_position_sns.sdts=position_sns.sdts
--where order_position_sns.hk_position_h='fe41d9803fcb75de1c9962934d7aa629'
)
, cte_product_join as 
(
select 
	  position_product_sns.hk_position_h
	, position_product_sns.hk_product_h
	, product_sns.hk_product_d
	, product_sns.typ
	, position_product_sns.rsrc_position_product_rs_es
	, position_product_sns.rsrc_position_product_ws_es	
	, product_sns.sdts
from cte_position_product position_product_sns
inner join cte_product product_sns
on position_product_sns.sdts=product_sns.sdts
and position_product_sns.hk_product_h=product_sns.hk_product_h 
)
, cte_productcategory_join as
(
select
	  product_productcategory_sns.hk_productcategory_h
	, product_productcategory_sns.hk_product_h
	, productcategory_sns.hk_productcategory_d
	, product_productcategory_sns.rsrc_product_productcategory_ws_es rsrc
	, productcategory_sns.sdts
from cte_product_productcategory product_productcategory_sns
inner join cte_productcategory productcategory_sns
on product_productcategory_sns.sdts=productcategory_sns.sdts
and product_productcategory_sns.hk_productcategory_h=productcategory_sns.hk_productcategory_h
)
, cte_product_type as 
(
select 
	  product_type_sns.product_type_nk
	, product_type_sns.rsrc 
from {{ ref('product_type_sns') }}
)
, cte_delivery as
(
select
	  delivery_sns.hk_position_h
	, delivery_sns.hk_deliveryadress_h
	, delivery_sns.lieferdatum
	, delivery_sns.rsrc 
	, delivery_sns.ldts
	, delivery_sns.sdts
from  {{ ref('delivery_sns') }}
)
, cte_customer as
(
select
	  order_customer_bb.sdts
	, order_customer_bb.hk_order_h
	, order_customer_bb.hk_customer_h
	, order_customer_bb.hk_customer_d
	, order_customer_bb.rsrc 
	, order_customer_bb.ldts
from {{ ref('order_customer_bb') }}
)
, cte_product as
(
select
	  position_product_sns.sdts
	, position_product_sns.hk_position_h
	, position_product_sns.hk_product_h
	, case when position_product_sns.rsrc_position_product_rs_es <>''
	       then position_product_sns.rsrc_position_product_rs_es
		   else position_product_sns.rsrc_position_product_ws_es 
		   end as rsrc
	, case when position_product_sns.ldts_position_product_rs_es <>'0001-01-01 00:00:01.000'
	       then position_product_sns.ldts_position_product_rs_es
		   else position_product_sns.ldts_position_product_ws_es 
		   end as ldts	
from cte_position_product position_product_sns
)
, cte_associationpartner as
(
-- roadshow
select
	  ao.sdts
	, ao.hk_order_h
	, ao.hk_associationpartner_h
	, ao.hk_associationpartner_d
	, ao.rsrc_order_associationpartner_rs_es rsrc
	, ao.ldts_order_associationpartner_rs_es ldts
from cte_order_associationpartner	ao							
union all
-- webshop
select
	  customer_associationpartner_sns.sdts
	, order_customer_sns.hk_order_h
	, customer_associationpartner_sns.hk_associationpartner_h
	, customer_associationpartner_sns.hk_associationpartner_d
	, case when order_customer_sns.rsrc_order_customer_rs_es <>''
	       then order_customer_sns.rsrc_order_customer_rs_es
		   else order_customer_sns.rsrc_order_customer_ws_es 
		   end as rsrc
	, case when order_customer_sns.ldts_order_customer_rs_es <>'0001-01-01 00:00:01.000'
	       then order_customer_sns.ldts_order_customer_rs_es
		   else order_customer_sns.ldts_order_customer_ws_es 
		   end as ldts		
from cte_customer_associationpartner customer_associationpartner_sns
inner join cte_order_customer order_customer_sns
	on customer_associationpartner_sns.sdts=order_customer_sns.sdts
	and customer_associationpartner_sns.hk_customer_h=order_customer_sns.hk_customer_h
where order_customer_sns.rsrc_order_customer_ws_es <>''
and customer_associationpartner_sns.rsrc_customer_associationpartner_ws_es <>'' 
)
, cte_category_deliveryadherence as
(
select
	  sdts
	, hk_category_deliveryadherence_d
	, number_of_days_from_num
	, number_of_days_till_num
	, number_of_days_from
	--, case when number_of_days_from = 'xxx' then 'rs' else 'ws' end as ordersource
from {{ ref('category_deliveryadherence_bs') }} 

),
cte_bv_level1 as
(
	select
	  cte_order.sdts 
	, cte_order.hk_order_h
	, cte_position_join.hk_position_h
	, coalesce (cte_product_join.hk_product_d, cte_const.unknown_key) hk_product_d
	, coalesce (cte_customer.hk_customer_d, cte_const.unknown_key) hk_customer_d
	, coalesce (cte_productcategory_join.hk_productcategory_d, cte_const.unknown_key) hk_productcategory_d	
	, coalesce (cte_customer.hk_customer_h, cte_const.unknown_key) hk_customer_h
	, coalesce (cte_delivery.hk_deliveryadress_h, cte_const.unknown_key) hk_deliveryadress_h
	, coalesce (cte_associationpartner.hk_associationpartner_d, cte_const.unknown_key) hk_associationpartner_d								   
	, coalesce (cte_product_type.product_type_nk, cte_const.unknown_key) product_type_nk								   
	, cte_order.order_bk
	, cte_position_join.position_bk
	, case when cte_position_join.has_rs_data
		then 'rs'
		when cte_position_join.has_ws_data
		then 'ws'
		else '--'
		end as ordersource
	, cte_position_join.amount
	, cte_position_join.price
	, rabatt_rs as rs_discount_row_based
	, case when cte_position_join.has_rs_data
	       THEN (amount*price*(1-rabatt_rs/100))*0.02+ (amount*price*(rabatt_rs/100))
	       when cte_position_join.has_ws_data
	       --THEN  (amount*price)/(sum(amount*price) OVER (PARTITION BY order_bk))*coalesce (cte_order.rabatt, 0) -- if discount is delivered as absolute number
		   then amount*price*(cte_order.rabatt/100)
	       ELSE 0 END discount
--	, (cte_position_join.discount /*for rs-orders the discount is on position-level*/+
--      /*breaking down the order discount for ws-orders based on the weighted revenue per position*/
--	  (amount*price)/(sum(amount*price) OVER (PARTITION BY order_bk))*coalesce (cte_order.rabatt, 0))*-1 discount 
	, case when cte_position_join.has_rs_data
		then cte_position_join.kaufdatum_rs
		else cte_order.bestelldatum
		end as sales_date
	, case when cte_position_join.has_rs_data
		then cte_position_join.kaufdatum_rs
		else cte_order.wunschdatum
		end as requested_date
	, case when cte_position_join.has_rs_data 
		then cte_position_join.kaufdatum_rs
		else cte_delivery.lieferdatum
		end as delivery_date
	, case when cte_position_join.has_rs_data
		then 0 -- order is delivered (there is no delivery for roadshow)
		when min(coalesce(delivery_date, cte_const.beginning_of_all_times)) over (partition by cte_order.sdts, cte_order.hk_order_h) <> cte_const.beginning_of_all_times
		then 0 -- order is delivered
		else 1 -- order is not delivered yet or only partly delivered
		end as openorder
	, min(coalesce(delivery_date, cte_const.beginning_of_all_times)) over (partition by cte_order.sdts, cte_order.hk_order_h) min_delivery_date
	, max(coalesce(delivery_date, cte_const.beginning_of_all_times)) over (partition by cte_order.sdts, cte_order.hk_order_h) max_delivery_date
	, max_delivery_date-requested_date deliveryadherence
	, cte_const.unknown_key
	from cte_order
	cross join cte_const
	inner join cte_position_join
		on cte_order.hk_order_h=cte_position_join.hk_order_h
		and cte_order.sdts=cte_position_join.sdts
	left join cte_product_join
		on cte_product_join.hk_position_h=cte_position_join.hk_position_h
		and cte_product_join.sdts=cte_position_join.sdts
	left join cte_product_type
		on cte_product_type.product_type_nk = cte_product_join.typ
	left join cte_productcategory_join
		on cte_product_join.hk_product_h=cte_productcategory_join.hk_product_h
		and cte_product_join.sdts=cte_productcategory_join.sdts		
	left join cte_delivery
		on cte_position_join.hk_position_h=cte_delivery.hk_position_h
		and cte_position_join.sdts=cte_delivery.sdts
	left join cte_customer
		on cte_order.hk_order_h=cte_customer.hk_order_h
		and cte_order.sdts=cte_customer.sdts
	left join cte_associationpartner
		on cte_associationpartner.sdts=cte_order.sdts
		and cte_associationpartner.hk_order_h=cte_order.hk_order_h
)
select 
      cte_bv_level1.sdts as reporting_date
	, hk_order_h
	, hk_position_h
	, hk_product_d	
	, hk_productcategory_d
	, hk_customer_h
	, hk_customer_d	
	, hk_deliveryadress_h
	, hk_associationpartner_d								   
	, CASE WHEN openorder=1
	       THEN unknown_key
	       ELSE coalesce (cte_category_deliveryadherence.hk_category_deliveryadherence_d,unknown_key) END as hk_category_deliveryadherence_d
	, product_type_nk
	, order_bk
	, position_bk
	, cte_bv_level1.ordersource
	, amount
	, price
	, discount
	, (price * amount) gross_profit
	, (price * amount) - discount revenue
	, sales_date
	, requested_date
	, delivery_date
	, cte_bv_level1.openorder
from cte_bv_level1
left join cte_category_deliveryadherence
	on cte_category_deliveryadherence.sdts = cte_bv_level1.sdts
	and ((cte_bv_level1.ordersource = 'ws' and deliveryadherence >= cte_category_deliveryadherence.number_of_days_from_num and deliveryadherence < cte_category_deliveryadherence.number_of_days_till_num)
		or (cte_bv_level1.ordersource != 'ws' and cte_category_deliveryadherence.number_of_days_from = 'zzz'))