{# template hub Version:0.1.0 #}
{# automatically generated based on dataspot#}

{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: 
    - name: stg_misc_kategorie_termintreue
      bk_columns: 'category_deliveryadherence_nk'
      rsrc_static: '*/misc/kategorie_termintreue/*'
ref_keys: 
  - 'category_deliveryadherence_nk'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.ref_hub(source_models=metadata_dict['source_models'],
                     ref_keys=metadata_dict['ref_keys']) }}


