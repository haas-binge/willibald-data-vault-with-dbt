
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_vereinspartner'
load_type: full
source_model_target:
  associationpartner_h:
    business_object:
      - associationpartner: vereinspartnerid
    satellites:
      associationpartner_ws_s:
        columns:
          - kundeidverein
          - rabatt1
          - rabatt2
          - rabatt3
      associationpartner_ws_sts:
  customer_h:
    business_object:
      - customer: kundeidverein
    satellites:
  associationpartner_customer_l:
    business_object:
      - customer: hk_customer_h
      - associationpartner: hk_associationpartner_h
    satellites:
      associationpartner_customer_ws_sts:

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}