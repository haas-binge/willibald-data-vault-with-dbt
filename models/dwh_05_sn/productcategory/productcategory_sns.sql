{# template sns Version: 0.1.0 #}
{# automatically generated based on dataspot#}
{{ config(materialized='view') }}

{%- set yaml_metadata -%}
pit: 'productcategory_snp'
base_entity: 'productcategory_h'
pit_hk: 'hk_productcategory_h'
pit_satellites: 
  - 'productcategory_ws_s'
primary_sourcesystem: 'ws'

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault_extension.sns(pit=metadata_dict['pit'],
                    pit_hk=metadata_dict['pit_hk'],
                    pit_satellites=metadata_dict['pit_satellites'],
                    base_entity=metadata_dict['base_entity'],
                    primary_sourcesystem=metadata_dict['primary_sourcesystem']) }}


