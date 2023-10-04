select ROW_NUMBER, LDTS as LDTS_SRC, RSRC, raw_data, CHK_ALL_MSG
from  {{ ref("load_roadshow_bestellung") }}
where not is_check_ok
