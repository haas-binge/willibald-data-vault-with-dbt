{% macro create_table_meta_hwm() %}
{% do log("Create Meta_HWM if not exists", True) %}
create table if not exists {{ source('LOAD_EXT_META', 'META_HWM') }}
(
    OBJECT_NAME       VARCHAR,
    HWM_LDTS TIMESTAMPNTZ,
    LOAD_DATE     TIMESTAMPNTZ
);
{% endmacro %}
