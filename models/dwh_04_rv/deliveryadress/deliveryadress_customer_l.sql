{# template link Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
  stg_webshop_lieferadresse:
    fk_columns: 
      - 'hk_deliveryadress_h'
      - 'hk_customer_h'
    rsrc_static: '*/webshop/lieferadresse/*'
link_hashkey: hk_deliveryadress_customer_l 
foreign_hashkeys: 
  - 'hk_deliveryadress_h'
  - 'hk_customer_h'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.link(source_models=metadata_dict['source_models'],
        link_hashkey=metadata_dict['link_hashkey'],
        foreign_hashkeys=metadata_dict['foreign_hashkeys']
        )}}