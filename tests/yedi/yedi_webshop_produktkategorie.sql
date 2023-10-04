
{{ config( enabled=True) }}
{%- set yaml_metadata -%}
source_model_source: 'load_webshop_produktkategorie'
load_type: full
source_model_target:
  productcategory_h:
    business_object:
      - productcategory: katid
    satellites:
      productcategory_ws_s:
        columns:
          - name
          - name
  productcategory_parent_h:
    business_object:
      - productcategory: oberkatid
    satellites:
      productcategory_ws_s:
        columns:
          - name
          - name
  productcategory_hierarchy_l:
    business_object:
      - productcategory_parent: hk_productcategory_parent_h
      - productcategory: hk_productcategory_h
    satellites:
      productcategory_hierarchy_ws_sts:

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.yedi_test(source_model_source=metadata_dict['source_model_source'],
                  source_model_target=metadata_dict['source_model_target'],
                  load_type=metadata_dict['load_type']
)
}}