{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_lieferung'
load_type: full
source_model_target:
  deliveryadress_h:
    business_object:
      - deliveryadress: lieferadrid
    satellites:
  deliveryservice_h:
    business_object:
      - deliveryservice: lieferdienstid
    satellites:
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
          - posid
  delivery_nhl:
    business_object:
      - deliveryadress: hk_deliveryadress_h
      - deliveryservice: hk_deliveryservice_h
      - order: hk_order_h
      - position: hk_position_h
      - position: hk_position_h
    satellites:

src_ldts: ldts_source

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source']
                    , source_model_target=metadata_dict['source_model_target']
                    , load_type=metadata_dict['load_type']
                    , src_ldts=metadata_dict['src_ldts']
)
}}