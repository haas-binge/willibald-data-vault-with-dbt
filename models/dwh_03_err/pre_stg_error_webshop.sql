select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from  {{ ref("load_webshop_bestellung") }}
where not is_check_ok
union all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_kunde") }}
where not is_check_ok
union all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_lieferadresse") }}
where not is_check_ok
union all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_lieferdienst") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_lieferung") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_position") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_produkt") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_produktkategorie") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_ref_produkt_typ") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_vereinspartner") }}
where not is_check_ok
UNION all
select ROW_NUMBER, ldts_source AS ldts, rsrc_source as rsrc, raw_data, CHK_ALL_MSG
from {{ ref("load_webshop_wohnort") }}
where not is_check_ok
