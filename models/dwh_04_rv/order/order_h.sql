{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_roadshow_bestellung
      hk_column: hk_order_h
      bk_columns: 'order_bk'
      rsrc_static: '*/roadshow/bestellung/*'
    - name: stg_webshop_bestellung
      hk_column: hk_order_h
      bk_columns: 'order_bk'
      rsrc_static: '*/webshop/bestellung/*'
    - name: stg_webshop_lieferung
      hk_column: hk_order_h
      bk_columns: 'order_bk'
      rsrc_static: '*/webshop/lieferung/*'
    - name: stg_webshop_position
      hk_column: hk_order_h
      bk_columns: 'order_bk'
      rsrc_static: '*/webshop/position/*'
hashkey: hk_order_h
business_keys: 
  - 'order_bk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.hub(source_models=metadata_dict["source_models"],
                hashkey=metadata_dict["hashkey"],
                business_keys=metadata_dict["business_keys"]) }} 
