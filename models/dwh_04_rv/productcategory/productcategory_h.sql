{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_webshop_produkt
      hk_column: hk_productcategory_h
      bk_columns: 'productcategory_bk'
      rsrc_static: '*/webshop/produkt/*'
    - name: stg_webshop_produktkategorie
      hk_column: hk_productcategory_h
      bk_columns: 'productcategory_bk'
      rsrc_static: '*/webshop/produktkategorie/*'
    - name: stg_webshop_produktkategorie
      hk_column: hk_productcategory_parent_h
      bk_columns: 'productcategory_parent_bk'
      rsrc_static: '*/webshop/produktkategorie/*'
hashkey: hk_productcategory_h
business_keys: 
  - 'productcategory_bk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.hub(source_models=metadata_dict["source_models"],
                hashkey=metadata_dict["hashkey"],
                business_keys=metadata_dict["business_keys"]) }} 
