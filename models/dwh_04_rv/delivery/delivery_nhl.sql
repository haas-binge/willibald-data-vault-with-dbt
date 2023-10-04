{# template nh_link Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: stg_webshop_lieferung
link_hashkey: hk_delivery_l 
foreign_hashkeys: 
  - 'hk_deliveryadress_h'
  - 'hk_deliveryservice_h'
  - 'hk_order_h'
  - 'hk_position_h'

payload:
  - bestellungid
  - lieferdatum
  - posid



{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set link_hashkey = metadata_dict['link_hashkey'] -%}
{%- set foreign_hashkeys = metadata_dict['foreign_hashkeys'] -%}
{%- set payload = metadata_dict['payload'] -%}
{%- set source_models = metadata_dict['source_models'] -%}


{{ datavault4dbt.nh_link(link_hashkey=link_hashkey,
                        foreign_hashkeys=foreign_hashkeys,
                        payload=payload,
                        source_models=source_models) }}