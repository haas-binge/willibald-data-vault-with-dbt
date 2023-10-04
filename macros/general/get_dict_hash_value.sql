{% macro get_dict_hash_value(value_key) -%}

{%- set hash = var('datavault4dbt.hash', 'MD5') -%}
{%- set hash_dtype = var('datavault4dbt.hash_datatype', 'STRING') -%}
{%- set hash_default_values = fromjson(datavault4dbt.hash_default_values(hash_function=hash,hash_datatype=hash_dtype)) -%}
{# {{ return(datavault4dbt.as_constant(column_str=hash_default_values[value_key])) }} #}
{{ return(hash_default_values[value_key] | replace("!", "")) }}
{%- endmacro %}