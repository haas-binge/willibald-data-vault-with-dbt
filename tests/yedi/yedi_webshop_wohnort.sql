
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_wohnort'
load_type: full
source_model_target:
  customer_h:
    business_object:
      - customer: kundeid
    satellites:
      customer_ws_la_ms:
        columns:
          - adresszusatz
          - bis
          - hausnummer
          - land
          - ort
          - plz
          - strasse
          - von

src_ldts: ldts_source

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source']
                    , source_model_target=metadata_dict['source_model_target']
                    , load_type=metadata_dict['load_type']
                    , src_ldts=metadata_dict['src_ldts']
)
}}