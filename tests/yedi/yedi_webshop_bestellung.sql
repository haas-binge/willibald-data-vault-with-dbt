
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_bestellung'
load_type: full
source_model_target:
  customer_h:
    business_object:
      - customer: kundeid
    satellites:
  order_h:
    business_object:
      - order: bestellungid
    satellites:
      order_ws_s:
        columns:
          - allglieferadrid
          - bestelldatum
          - rabatt
          - wunschdatum
      order_ws_sts:
  order_customer_l:
    business_object:
      - order: hk_order_h
      - customer: hk_customer_h
    satellites:
      order_customer_ws_sts:

src_ldts: ldts_source

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source']
                    , source_model_target=metadata_dict['source_model_target']
                    , load_type=metadata_dict['load_type']
                    , src_ldts=metadata_dict['src_ldts']
)
}}