{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_misc_kategorie_termintreue'
hashed_columns:
  hd_category_deliveryadherence_misc_rs:
    is_hashdiff: true
    columns:
      - anzahl_tage_von
      - anzahl_tage_bis
      - bezeichnung




derived_columns:
    category_deliveryadherence_nk:
      value: bewertung
      datatype: 'VARCHAR'
    count_days_from:
      value: anzahl_tage_von
      datatype: 'VARCHAR'
    count_days_to:
      value: anzahl_tage_bis
      datatype: 'VARCHAR'
    name:
      value: bezeichnung
      datatype: 'VARCHAR'

    cdts:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    edts:      
      value: edts_in
      datatype: 'DATE'

rsrc: 'rsrc' 
ldts: 'ldts'
include_source_columns: true

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.stage(include_source_columns=metadata_dict['include_source_columns'],
                  source_model=metadata_dict['source_model'],
                  hashed_columns=metadata_dict['hashed_columns'],
                  derived_columns=metadata_dict['derived_columns'],                  
                  rsrc=metadata_dict['rsrc'],
                  ldts=metadata_dict['ldts'],
                  prejoined_columns=metadata_dict['prejoined_columns'],
                  multi_active_config=metadata_dict['multi_active_config']) }}
where is_check_ok or rsrc ='SYSTEM'                  