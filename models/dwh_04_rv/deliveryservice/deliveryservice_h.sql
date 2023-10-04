{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_webshop_lieferdienst
      hk_column: hk_deliveryservice_h
      bk_columns: 'deliveryservice_bk'
      rsrc_static: '*/webshop/lieferdienst/*'
    - name: stg_webshop_lieferung
      hk_column: hk_deliveryservice_h
      bk_columns: 'deliveryservice_bk'
      rsrc_static: '*/webshop/lieferung/*'
hashkey: hk_deliveryservice_h
business_keys: 
  - 'deliveryservice_bk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.hub(source_models=metadata_dict["source_models"],
                hashkey=metadata_dict["hashkey"],
                business_keys=metadata_dict["business_keys"]) }} 
