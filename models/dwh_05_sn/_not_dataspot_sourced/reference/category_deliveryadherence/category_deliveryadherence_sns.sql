select 
	  category_deliveryadherence_snp.sdts
	, category_deliveryadherence_r.category_deliveryadherence_nk
	, category_deliveryadherence_r.ldts 
	, category_deliveryadherence_r.rsrc
	, category_deliveryadherence_snp.hk_category_deliveryadherence_d
    , {{ dbt_utils.star(ref("category_deliveryadherence_misc_rs"), except=['nk_category_deliveryadherence_misc_r', 'ldts', 'rsrc'], relation_alias= "category_deliveryadherence_misc_rs", prefix="cdm_")|replace('"','') }}
from {{ ref("category_deliveryadherence_snp") }} category_deliveryadherence_snp
inner join {{ ref("category_deliveryadherence_r") }} category_deliveryadherence_r 
	on  category_deliveryadherence_snp.hk_category_deliveryadherence_misc_rs=category_deliveryadherence_r.category_deliveryadherence_nk
inner join {{ ref("category_deliveryadherence_misc_rs") }} category_deliveryadherence_misc_rs
	on  category_deliveryadherence_snp.hk_category_deliveryadherence_misc_rs  =category_deliveryadherence_misc_rs.category_deliveryadherence_nk
	and category_deliveryadherence_snp.ldts_category_deliveryadherence_misc_rs=category_deliveryadherence_misc_rs.ldts
INNER JOIN {{ ref("category_deliveryadherence_misc_sts") }}
	ON category_deliveryadherence_snp.hk_category_deliveryadherence_misc_sts=category_deliveryadherence_misc_sts.category_deliveryadherence_nk
	AND category_deliveryadherence_snp.ldts_category_deliveryadherence_misc_sts = category_deliveryadherence_misc_sts.ldts
WHERE  category_deliveryadherence_misc_sts.cdc <>'D'	