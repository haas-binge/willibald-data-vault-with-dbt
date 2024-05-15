{{ config( enabled=False) }}
{%- set yaml_metadata -%}
source_model_source: 'load_roadshow_bestellung'
load_type: partial
source_model_target:
  associationpartner_h:
    business_object:
      - associationpartner: vereinspartnerid
    satellites:
  customer_h:
    business_object:
      - customer: kundeid
    satellites:
  order_h:
    business_object:
      - order: bestellungid
    satellites:
      order_rs_rts:
  position_h:
    business_object:
      - position: bestellungid
      - position: produktid
    satellites:
      position_rs_s:
        columns:
          - bestellungid
          - gueltigbis
          - kaufdatum
          - kkfirma
          - kreditkarte
          - menge
          - preis
          - produktid
          - rabatt
      position_rs_sts:
  product_h:
    business_object:
      - product: produktid
    satellites:
  order_associationpartner_l:
    business_object:
      - order: hk_order_h
      - associationpartner: hk_associationpartner_h
    satellites:
      order_associationpartner_rs_sts:
  order_customer_l:
    business_object:
      - order: hk_order_h
      - customer: hk_customer_h
    satellites:
      order_customer_rs_rts:
  order_position_l:
    business_object:
      - position: hk_position_h
      - order: hk_order_h
    satellites:
      order_position_rs_sts:
  position_product_l:
    business_object:
      - product: hk_product_h
      - position: hk_position_h
    satellites:
      position_product_rs_sts:
src_ldts: ldts_source
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}