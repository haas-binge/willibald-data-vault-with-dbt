{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_webshop_kunde'
hashed_columns:
  hk_associationpartner_h:
    - vereinspartnerid
  hk_customer_h:
    - kundeid
  hk_customer_associationpartner_l:
    - customer_bk
    - associationpartner_bk
  hd_customer_ws_s:
    is_hashdiff: true
    columns:
      - email
      - geburtsdatum
      - geschlecht
      - gueltigbis
      - kkfirma
      - kreditkarte
      - mobil
      - name
      - telefon
      - vorname




derived_columns:
    associationpartner_bk:
      value: vereinspartnerid
      datatype: 'VARCHAR'
    customer_bk:
      value: kundeid
      datatype: 'VARCHAR'

    cdts:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    edts:      
      value: edts_in
      datatype: 'DATE'

rsrc: 'rsrc_source' 
ldts: 'ldts_source'
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