{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_webshop_lieferadresse
      hk_column: hk_deliveryadress_h
      bk_columns: 'deliveryadress_bk'
      rsrc_static: '*/webshop/lieferadresse/*'
    - name: stg_webshop_lieferung
      hk_column: hk_deliveryadress_h
      bk_columns: 'deliveryadress_bk'
      rsrc_static: '*/webshop/lieferung/*'
hashkey: hk_deliveryadress_h
business_keys: 
  - 'deliveryadress_bk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.hub(source_models=metadata_dict["source_models"],
                hashkey=metadata_dict["hashkey"],
                business_keys=metadata_dict["business_keys"]) }} 
