{# template sat_ma_v0 Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental',
           unique_key=['hk_customer_h', 'von', 'ldts']) }}

{%- set yaml_metadata -%}
source_model: "stg_webshop_wohnort" 
parent_hashkey: "hk_customer_h"
src_hashdiff: 'hd_customer_ws_la_ms'
src_ma_key: 
  - von

src_payload: 
  - adresszusatz
  - bis
  - hausnummer
  - land
  - ort
  - plz
  - strasse


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}
{%- set src_edts = metadata_dict['src_edts'] -%}

{{ datavault4dbt.ma_sat_v0(source_model=metadata_dict['source_model'],
                        parent_hashkey=metadata_dict['parent_hashkey'],
                        src_hashdiff=metadata_dict['src_hashdiff'],
                        src_ma_key=metadata_dict['src_ma_key'],
                        src_payload=metadata_dict['src_payload']
                        ) }}