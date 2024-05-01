{# template stage Version:0.1.1 #}
{# automatically generated based on dataspot#}

{{ config(materialized='view') }}
{%- set unknown_key = get_dict_hash_value("unknown_key") -%}
{%- set error_key = get_dict_hash_value("error_key") -%}

{%- set yaml_metadata -%}
source_model: 
  'load_roadshow_bestellung'
hashed_columns:
  HK_ASSOCIATIONPARTNER_H:
    - VEREINSPARTNERID
  HK_CUSTOMER_H:
    - KUNDEID
  HK_ORDER_H:
    - BESTELLUNGID
  HK_POSITION_H:
    - BESTELLUNGID
    - PRODUKTID
  HK_PRODUCT_H:
    - PRODUKTID
  HK_ORDER_ASSOCIATIONPARTNER_L:
    - ORDER_BK
    - ASSOCIATIONPARTNER_BK
  HK_ORDER_CUSTOMER_L:
    - ORDER_BK
    - CUSTOMER_BK
  HK_ORDER_POSITION_L:
    - POSITION_BK
    - ORDER_BK
  HK_POSITION_PRODUCT_L:
    - PRODUCT_BK
    - POSITION_BK
  HD_POSITION_RS_S:
    is_hashdiff: true
    columns:
      - BESTELLUNGID
      - GUELTIGBIS
      - KAUFDATUM
      - KKFIRMA
      - KREDITKARTE
      - MENGE
      - PREIS
      - PRODUKTID
      - RABATT




derived_columns:
    ASSOCIATIONPARTNER_BK:
      value: VEREINSPARTNERID
      datatype: 'VARCHAR'
    CUSTOMER_BK:
      value: KUNDEID
      datatype: 'VARCHAR'
    ORDER_BK:
      value: BESTELLUNGID
      datatype: 'VARCHAR'
    POSITION_BK:
      value: CAST(BESTELLUNGID ||'_'|| PRODUKTID ||'_'|| CAST(ROW_NUMBER() OVER (PARTITION BY LDTS, BESTELLUNGID, PRODUKTID  ORDER BY MENGE, PREIS) AS VARCHAR) AS VARCHAR)
      datatype: 'VARCHAR'
    PRODUCT_BK:
      value: PRODUKTID
      datatype: 'VARCHAR'

    CDTS:
      value: {{var("local_timestamp")}}
      datatype: 'TIMESTAMP'
    EDTS:      
      value: EDTS_IN
      datatype: 'DATE'

rsrc: 'RSRC_SOURCE' 
ldts: 'LDTS_SOURCE'
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