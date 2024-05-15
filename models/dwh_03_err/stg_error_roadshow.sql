{{ config(materialized='view') }}
{%- set yaml_metadata -%}
source_model: pre_stg_error_roadshow
ldts: LDTS
rsrc: RSRC
derived_columns: 
    ERROR_ROW_NO_BK:
        value: to_varchar(row_number)
        datatype: 'VARCHAR'
    ERROR_FILE_BK:
        value: to_varchar(rsrc)
        datatype: 'VARCHAR'
hashed_columns: 
    HK_ERROR_H:
        - ERROR_FILE_BK
        - ERROR_ROW_NO_BK
    HD_ERROR_S:
        - RAW_DATA
        - CHK_ALL_MSG 
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.stage(source_model=metadata_dict['source_model'],
                    ldts=metadata_dict['ldts'],
                    rsrc=metadata_dict['rsrc'],
                    hashed_columns=metadata_dict['hashed_columns'],
                    derived_columns=metadata_dict['derived_columns'])
                     }}