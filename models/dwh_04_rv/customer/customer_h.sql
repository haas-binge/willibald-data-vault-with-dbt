{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_roadshow_bestellung
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/roadshow/bestellung/*'
    - name: stg_webshop_bestellung
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/webshop/bestellung/*'
    - name: stg_webshop_kunde
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/webshop/kunde/*'
    - name: stg_webshop_lieferadresse
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/webshop/lieferadresse/*'
    - name: stg_webshop_vereinspartner
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/webshop/vereinspartner/*'
    - name: stg_webshop_wohnort
      hk_column: hk_customer_h
      bk_columns: 'customer_bk'
      rsrc_static: '*/webshop/wohnort/*'
hashkey: hk_customer_h
business_keys: 
  - 'customer_bk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.hub(source_models=metadata_dict["source_models"],
                hashkey=metadata_dict["hashkey"],
                business_keys=metadata_dict["business_keys"]) }} 
