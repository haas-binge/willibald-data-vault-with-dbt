{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_wohnort'
hashed_columns:
  HK_CUSTOMER_H:
    - KUNDEID
  HD_CUSTOMER_WS_LA_MS:
    is_hashdiff: true
    columns:
      - ADRESSZUSATZ
      - BIS
      - HAUSNUMMER
      - LAND
      - ORT
      - PLZ
      - STRASSE


multi_active_config:
    multi_active_key:
      - VON
    main_hashkey_column: HK_CUSTOMER_H


derived_columns:
    CUSTOMER_BK:
      value: KUNDEID
      datatype: 'VARCHAR'

    CDTS:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    EDTS:      
      value: EDTS_IN
      datatype: 'DATE'

rsrc: 'RSRC_SOURCE' 
ldts: 'LDTS_SOURCE'
include_source_columns: true

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.stage(include_source_columns=metadata_dict['include_source_columns'],
                  source_model=metadata_dict['source_model'],
                  hashed_columns=metadata_dict['hashed_columns'],
                  derived_columns=metadata_dict['derived_columns'],                  
                  rsrc=metadata_dict['rsrc'],
                  ldts=metadata_dict['ldts'],
                  prejoined_columns=metadata_dict['prejoined_columns'],
                  multi_active_config=metadata_dict['multi_active_config']) }}
where is_check_ok or rsrc ='SYSTEM'                  