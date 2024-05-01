{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferadresse'
hashed_columns:
  HK_CUSTOMER_H:
    - KUNDEID
  HK_DELIVERYADRESS_H:
    - LIEFERADRID
  HK_DELIVERYADRESS_CUSTOMER_L:
    - DELIVERYADRESS_BK
    - CUSTOMER_BK
  HD_DELIVERYADRESS_WS_S:
    is_hashdiff: true
    columns:
      - ADRESSZUSATZ
      - HAUSNUMMER
      - LAND
      - ORT
      - PLZ
      - STRASSE




derived_columns:
    CUSTOMER_BK:
      value: KUNDEID
      datatype: 'VARCHAR'
    DELIVERYADRESS_BK:
      value: LIEFERADRID
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