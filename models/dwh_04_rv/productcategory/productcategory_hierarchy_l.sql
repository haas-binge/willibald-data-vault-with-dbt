{# template link Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
  stg_webshop_produktkategorie:
    fk_columns: 
      - 'hk_productcategory_parent_h'
      - 'hk_productcategory_h'
    rsrc_static: '*/webshop/produktkategorie/*'
link_hashkey: hk_productcategory_hierarchy_l 
foreign_hashkeys: 
  - 'hk_productcategory_parent_h'
  - 'hk_productcategory_h'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.link(source_models=metadata_dict['source_models'],
        link_hashkey=metadata_dict['link_hashkey'],
        foreign_hashkeys=metadata_dict['foreign_hashkeys']
        )}}