{# template link Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
  stg_roadshow_bestellung:
    fk_columns: 
      - 'hk_product_h'
      - 'hk_position_h'
    rsrc_static: '*/roadshow/bestellung/*'
  stg_webshop_position:
    fk_columns: 
      - 'hk_product_h'
      - 'hk_position_h'
    rsrc_static: '*/webshop/position/*'
link_hashkey: hk_position_product_l 
foreign_hashkeys: 
  - 'hk_product_h'
  - 'hk_position_h'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.link(source_models=metadata_dict['source_models'],
        link_hashkey=metadata_dict['link_hashkey'],
        foreign_hashkeys=metadata_dict['foreign_hashkeys']
        )}}