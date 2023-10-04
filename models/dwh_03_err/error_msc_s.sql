{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
parent_hashkey: 'hk_error_h'
src_hashdiff: 'hd_error_s'
src_payload:
    - raw_data
    - chk_all_msg 

source_model: 'stg_error_misc'
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set parent_hashkey = metadata_dict['parent_hashkey'] -%}
{%- set src_hashdiff = metadata_dict['src_hashdiff'] -%}
{%- set source_model = metadata_dict['source_model'] -%}
{%- set src_payload = metadata_dict['src_payload'] -%}


{{ datavault4dbt.sat_v0(parent_hashkey=parent_hashkey,
                        src_hashdiff=src_hashdiff,
                        source_model=source_model,
                        src_payload=src_payload) }}