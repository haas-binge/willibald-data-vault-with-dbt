{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: hk_error_h
business_keys: 
   - error_row_no_bk
   - error_file_bk
source_models: 
   stg_error_roadshow:
      hk_column: 'hk_error_h'
   stg_error_webshop:
      hk_column: 'hk_error_h'
   stg_error_misc:
      hk_column: 'hk_error_h'
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.hub(hashkey=metadata_dict['hashkey'],
                     business_keys=metadata_dict['business_keys'],
                     source_models=metadata_dict['source_models']) }}