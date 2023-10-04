{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_roadshow_bestellung'
hashed_columns:
  hk_associationpartner_h:
    - vereinspartnerid
  hk_customer_h:
    - kundeid
  hk_order_h:
    - bestellungid
  hk_position_h:
    - bestellungid
    - produktid
  hk_product_h:
    - produktid
  hk_order_associationpartner_l:
    - order_bk
    - associationpartner_bk
  hk_order_customer_l:
    - order_bk
    - customer_bk
  hk_order_position_l:
    - position_bk
    - order_bk
  hk_position_product_l:
    - product_bk
    - position_bk
  hd_position_rs_s:
    is_hashdiff: true
    columns:
      - bestellungid
      - gueltigbis
      - kaufdatum
      - kkfirma
      - kreditkarte
      - menge
      - preis
      - produktid
      - rabatt




derived_columns:
    associationpartner_bk:
      value: vereinspartnerid
      datatype: 'VARCHAR'
    customer_bk:
      value: kundeid
      datatype: 'VARCHAR'
    order_bk:
      value: bestellungid
      datatype: 'VARCHAR'
    position_bk:
      value: cast(BESTELLUNGID ||'_'|| produktid ||'_'|| cast(row_number() over (partition by ldts, bestellungid, produktid  order by menge, preis) as varchar) as varchar)
      datatype: 'VARCHAR'
    product_bk:
      value: produktid
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