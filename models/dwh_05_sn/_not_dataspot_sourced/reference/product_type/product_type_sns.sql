select 
	  --control_snap_v1.sdts
	  product_type_ws_rs.product_type_nk
	, product_type_ws_rs.ldts 
	, product_type_ws_rs.rsrc
    , product_type_ws_rs.bezeichnung
from {{ ref("product_type_ws_rs") }} product_type_ws_rs
