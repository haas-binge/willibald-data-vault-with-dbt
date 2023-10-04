with cte_relevant_date as
(
	select sdts
	from {{ ref("relevant_date") }} 
)
select 
  hk_customer_d
, customer_bk
, vorname
, name 
, geschlecht
, geburtsdatum
, telefon
, mobil
, email
, kreditkarte 
, gueltigbis 
, kkfirma 
from {{ ref("customer_sns") }} s
cross join cte_relevant_date 
	where s.sdts = cte_relevant_date.sdts
