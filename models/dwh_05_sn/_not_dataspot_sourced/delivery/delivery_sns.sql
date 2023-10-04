WITH cte_relevant_date as
(
	select sdts
	from {{ ref("relevant_date") }} 
)
select
	  cte_relevant_date.sdts
	, delivery_nhl.hk_position_h
	, delivery_nhl.hk_deliveryadress_h
	, delivery_nhl.lieferdatum
	, delivery_nhl.rsrc 
	, delivery_nhl.ldts
from  {{ ref("delivery_nhl") }}
inner join  cte_relevant_date
on cte_relevant_date.sdts >= delivery_nhl.ldts 