{{ config(materialized='incremental',
        post_hook="{{ datavault4dbt.clean_up_pit('control_snap_v1') }}") }}

{%- set yaml_metadata -%}
pit_type: 'Regular PIT'
tracked_entity: 'category_deliveryadherence_r'
hashkey: 'category_deliveryadherence_nk'
sat_names:
    - category_deliveryadherence_misc_rs
    - category_deliveryadherence_misc_sts
snapshot_relation: 'control_snap_v1'
snapshot_trigger_column: 'is_active'
dimension_key: 'hk_category_deliveryadherence_d'
custom_rsrc: 'PIT table for category delivery adherence'

{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set pit_type = metadata_dict['pit_type'] -%}
{%- set tracked_entity = metadata_dict['tracked_entity'] -%}
{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set sat_names = metadata_dict['sat_names'] -%}
{%- set snapshot_relation = metadata_dict['snapshot_relation'] -%}
{%- set snapshot_trigger_column = metadata_dict['snapshot_trigger_column'] -%}
{%- set dimension_key = metadata_dict['dimension_key'] -%}
{%- set custom_rsrc = metadata_dict['custom_rsrc'] -%}

{{ datavault4dbt.pit(pit_type=pit_type
                        , tracked_entity=tracked_entity
                        , hashkey=hashkey
                        , sat_names=sat_names
                        , snapshot_relation=snapshot_relation
                        , snapshot_trigger_column=snapshot_trigger_column
                        , dimension_key=dimension_key
                        , custom_rsrc=custom_rsrc
                        ) }}