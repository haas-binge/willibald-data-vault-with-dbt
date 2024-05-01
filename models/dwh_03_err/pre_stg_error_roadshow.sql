select ROW_NUMBER, ldts_source as LDTS, rsrc_source as RSRC, raw_data, CHK_ALL_MSG
from  {{ ref("load_roadshow_bestellung") }}
where not is_check_ok
