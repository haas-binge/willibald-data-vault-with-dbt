
{{ config(materialized="table", pre_hook=["{{ datavault_extension.refresh_external_table('DWS.EXT_WEBSHOP_REF_PRODUKT_TYP','snowflake_external_table_surrogate') }}"], post_hook=["{{datavault_extension.insert_hwm(this) }}"]) }}
with
{{ datavault_extension.pre_hwm(this, omit_with=true, add_comma_at_end=true) }}
raw_data AS 
(
	SELECT 
		   TRIM(replace(right(filenamedate, 19),'.csv','')::VARCHAR) AS ldts_raw
		 , TRIM(reverse(substring(reverse(replace(Filenamedate,'.csv','')), 17,8))::VARCHAR) AS business_date_raw
		 , TRIM(filenamedate::VARCHAR) AS rsrc_raw
		 , value AS json_data_raw
		 , TRIM(METADATA$FILE_ROW_NUMBER::VARCHAR) AS external_table_row_number_raw
		 , TRIM(value:c1::VARCHAR) AS typ_raw
		 , TRIM(value:c2::VARCHAR) AS bezeichnung_raw
 FROM {{ source("LOAD_EXT", "EXT_WEBSHOP_REF_PRODUKT_TYP") }}
)
SELECT 
		   TRY_TO_TIMESTAMP(ldts_raw ,'YYYYMMDD_HH24MISS') as ldts
		 , TRY_TO_DATE(business_date_raw ,'YYYYMMDD') as edts_in
		 , rsrc_raw as rsrc
		 , json_data_raw as raw_data
		 , external_table_row_number_raw as row_number
		 , typ_raw as typ
		 , bezeichnung_raw as bezeichnung
		, row_number() over (partition by ldts, typ_raw order by typ_raw desc) = 1 as is_dub_check_ok
		, coalesce(typ_raw, '') <>'' as is_key_check_ok
		,  is_dub_check_ok and  is_key_check_ok as is_check_ok
 		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT is_dub_check_ok, '{"dub_check": "ldts, typ"}','') || IFF(NOT is_key_check_ok, '{"key_check": "typ"}',''), '}{','},{')],[''])) chk_all_msg

 FROM raw_data
{{ datavault_extension.post_hwm(this) }}