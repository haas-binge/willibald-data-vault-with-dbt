{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferadresse'
hashed_columns:
  hk_customer_h:
    - kundeid
  hk_deliveryadress_h:
    - lieferadrid
  hk_deliveryadress_customer_l:
    - deliveryadress_bk
    - customer_bk
  hd_deliveryadress_ws_s:
    is_hashdiff: true
    columns:
      - adresszusatz
      - hausnummer
      - land
      - ort
      - plz
      - strasse




derived_columns:
    customer_bk:
      value: kundeid
      datatype: 'VARCHAR'
    deliveryadress_bk:
      value: lieferadrid
      datatype: 'VARCHAR'

    cdts:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    edts:      
      value: edts_in
      datatype: 'DATE'

rsrc: 'rsrc_source' 
ldts: 'ldts_source'
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