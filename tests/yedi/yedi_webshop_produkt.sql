
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_produkt'
load_type: full
source_model_target:
  product_h:
    business_object:
      - product: produktid
    satellites:
      product_ws_s:
        columns:
          - bezeichnung
          - pflanzabstand
          - pflanzort
          - preis
          - typ
          - umfang
      product_ws_sts:
  productcategory_h:
    business_object:
      - productcategory: katid
    satellites:
  product_productcategory_l:
    business_object:
      - productcategory: hk_productcategory_h
      - product: hk_product_h
    satellites:
      product_productcategory_ws_sts:

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}