select ROW_NUMBER, LDTS as LDTS_SRC, RSRC, raw_data, CHK_ALL_MSG, true as IS_CHECK_OK
from  {{ ref("load_misc_kategorie_termintreue") }}
where not is_check_ok

