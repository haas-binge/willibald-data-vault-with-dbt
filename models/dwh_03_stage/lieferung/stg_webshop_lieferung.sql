{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_lieferung'
hashed_columns:
  hk_deliveryadress_h:
    - lieferadrid
  hk_deliveryservice_h:
    - lieferdienstid
  hk_order_h:
    - bestellungid
  hk_position_h:
    - bestellungid
    - posid
  hk_order_position_l:
    - position_bk
    - order_bk
  hk_delivery_l:
    - lieferadrid
    - lieferdienstid
    - bestellungid
    - bestellungid
    - posid
  hd_position_ws_s:
    is_hashdiff: true
    columns:
      - bestellungid
      - posid




derived_columns:
    deliveryadress_bk:
      value: lieferadrid
      datatype: 'VARCHAR'
    deliveryservice_bk:
      value: lieferdienstid
      datatype: 'VARCHAR'
    order_bk:
      value: bestellungid
      datatype: 'VARCHAR'
    position_bk:
      value: bestellungid||'_'||posid
      datatype: 'VARCHAR'

    cdts:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    edts:      
      value: edts_in
      datatype: 'DATE'

rsrc: 'rsrc' 
ldts: 'ldts'
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