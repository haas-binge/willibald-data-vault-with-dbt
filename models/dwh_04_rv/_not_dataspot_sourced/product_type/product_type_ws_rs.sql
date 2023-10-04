
{{ config(enabled=true,materialized='table') }}

{%- set yaml_metadata -%}
parent_reference_key: 'product_type_nk'
src_hashdiff: 'hd_product_type_ws_rs'
src_payload:
    - 'bezeichnung'
source_model: 'stg_webshop_ref_produkt_typ'
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.ref_sat_v0(parent_ref_keys=metadata_dict['parent_reference_key'],
                        src_hashdiff=metadata_dict['src_hashdiff'],
                        source_model=metadata_dict['source_model'],
                        src_payload=metadata_dict['src_payload']) }}


