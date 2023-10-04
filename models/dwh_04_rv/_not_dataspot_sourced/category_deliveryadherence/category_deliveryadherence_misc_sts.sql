{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
tracked_hashkey: 'category_deliveryadherence_nk'
stage_source_model: stg_misc_kategorie_termintreue

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set tracked_hashkey = metadata_dict['tracked_hashkey'] -%}
{%- set stage_source_model = metadata_dict['stage_source_model'] -%}
{%- set src_edts = metadata_dict['src_edts'] -%}

{{ datavault_extension.sts_v0(
                            tracked_hashkey=tracked_hashkey
                            , stage_source_model=stage_source_model
                            , src_edts=src_edts 
                            ) }}

