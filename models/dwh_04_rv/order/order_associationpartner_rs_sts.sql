{# template st_sat_v0 Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
tracked_hashkey: "hk_order_associationpartner_l"
stage_source_model: "stg_roadshow_bestellung"
load_type: partial

  

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set tracked_hashkey = metadata_dict['tracked_hashkey'] -%}
{%- set stage_source_model = metadata_dict['stage_source_model'] -%}
{%- set src_edts = metadata_dict['src_edts'] -%}
{%- set load_type = metadata_dict['load_type'] -%}
{%- set edts_hashkey = metadata_dict['edts_hashkey'] -%}

{{ datavault_extension.sts_v0(
                            tracked_hashkey=tracked_hashkey
                            , stage_source_model=stage_source_model
                            , load_type=load_type
                            , src_edts=src_edts 
                            , edts_hashkey=edts_hashkey
                            ) }}