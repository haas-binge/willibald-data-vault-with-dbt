
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_lieferadresse'
load_type: full
source_model_target:
  customer_h:
    business_object:
      - customer: kundeid
    satellites:
  deliveryadress_h:
    business_object:
      - deliveryadress: lieferadrid
    satellites:
      deliveryadress_ws_s:
        columns:
          - adresszusatz
          - hausnummer
          - land
          - ort
          - plz
          - strasse
  deliveryadress_customer_l:
    business_object:
      - deliveryadress: hk_deliveryadress_h
      - customer: hk_customer_h
    satellites:
      deliveryadress_customer_ws_sts:

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}