{{ config(materialized='view') }}
--LOAD_TIMESTAMP, RECORD_SOURCE, JSON_DATA, CHK_ALL_MSG
{%- set yaml_metadata -%}
source_model: pre_stg_error_webshop
ldts: ldts_src
rsrc: rsrc
derived_columns: 
    error_row_no_bk:
        value: to_varchar(row_number)
        datatype: 'VARCHAR'
    error_file_bk:
        value: to_varchar(rsrc)
        datatype: 'VARCHAR'
hashed_columns: 
    hk_error_h:
            - error_file_bk
            - error_row_no_bk
    hd_error_s:
        - raw_data
        - chk_all_msg 
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.stage(source_model=metadata_dict['source_model'],
                    ldts=metadata_dict['ldts'],
                    rsrc=metadata_dict['rsrc'],
                    hashed_columns=metadata_dict['hashed_columns'],
                    derived_columns=metadata_dict['derived_columns'])
                     }}