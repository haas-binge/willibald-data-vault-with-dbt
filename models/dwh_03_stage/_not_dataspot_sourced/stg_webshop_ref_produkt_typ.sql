{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: load_webshop_ref_produkt_typ
ldts: 'LDTS_SOURCE'
rsrc: 'RSRC_SOURCE'
derived_columns:
    cdts:
        value: {{var("local_timestamp")}}
        datatype: 'TIMESTAMP'        
    product_type_nk:
        value: typ::string
        datatype: 'VARCHAR' 
    edts:      
        value: edts_in
        datatype: 'DATE'   

hashed_columns:
    hd_product_type_ws_rs:
        is_hashdiff: true
        columns:
            - 'bezeichnung'            
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set derived_columns = metadata_dict['derived_columns'] -%}
{%- set prejoined_columns = metadata_dict['prejoined_columns'] -%}
{%- set missing_columns = metadata_dict['missing_columns'] -%}
{%- set multi_active_config = metadata_dict['multi_active_config'] -%}


{{ datavault4dbt.stage(source_model=source_model,
                    ldts=ldts,
                    rsrc=rsrc,
                    hashed_columns=hashed_columns,
                    derived_columns=derived_columns,
                    multi_active_config=multi_active_config) }}
where is_check_ok or (typ in ('{{ unknown_key }}'::string, '{{ error_key }}'::string) )                     


