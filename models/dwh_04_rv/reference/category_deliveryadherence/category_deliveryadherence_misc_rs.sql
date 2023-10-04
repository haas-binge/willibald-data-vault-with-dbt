{# template ref_sat_v0 Version: 0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }} 

{%- set yaml_metadata -%}
source_model: stg_misc_kategorie_termintreue
parent_ref_keys: category_deliveryadherence_nk
src_hashdiff: 'hd_category_deliveryadherence_misc_rs'
src_payload: 
  - count_days_from
  - count_days_to
  - name

{%- endset -%}      

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.ref_sat_v0(source_model=metadata_dict['source_model'],
                     parent_ref_keys=metadata_dict['parent_ref_keys'],
                     src_hashdiff=metadata_dict['src_hashdiff'],
                     src_payload=metadata_dict['src_payload']) }}                        