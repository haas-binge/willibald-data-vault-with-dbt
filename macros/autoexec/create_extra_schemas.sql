{% macro create_extra_schemas() %}

{% do log('create schema if not exists ' ~ var("meta_schema"), True) %}
create schema if not exists {{ var("meta_schema") }};

{% do log('create schema if not exists ' ~ var("external_tables_schema"), True) %}
create schema if not exists {{ var("external_tables_schema") }};

{% endmacro %}