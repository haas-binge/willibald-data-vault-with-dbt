
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_position'
load_type: full
source_model_target:
  order_h:
    business_object:
      - order: bestellungid
    satellites:
  position_h:
    business_object:
      - position: bestellungid
      - position: posid
    satellites:
      position_ws_s:
        columns:
          - bestellungid
          - menge
          - posid
          - preis
          - spezlieferadrid
      position_ws_sts:
  product_h:
    business_object:
      - product: produktid
    satellites:
  order_position_l:
    business_object:
      - position: hk_position_h
      - order: hk_order_h
    satellites:
      order_position_ws_sts:
  position_product_l:
    business_object:
      - product: hk_product_h
      - position: hk_position_h
    satellites:
      position_product_ws_sts:

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}