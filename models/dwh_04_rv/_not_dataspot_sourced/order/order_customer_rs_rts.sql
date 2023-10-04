{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
tracked_hashkey: hk_order_customer_l
source_models: stg_roadshow_bestellung
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.rec_track_sat(tracked_hashkey=metadata_dict['tracked_hashkey'],
                                source_models=metadata_dict['source_models']) }}
                                {{ config(materialized='incremental') }}
