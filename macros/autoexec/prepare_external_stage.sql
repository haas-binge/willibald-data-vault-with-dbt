{% macro prepare_external_stage() %}
{% do log("Create File Format if not exists", True) %}
CREATE or REPLACE FILE FORMAT {{ var("external_tables_schema") }}.FF_SEMICOLON 
COMPRESSION = 'AUTO' FIELD_DELIMITER = ';' RECORD_DELIMITER = '\n' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = 'NONE' TRIM_SPACE = FALSE ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE ESCAPE = 'NONE' ESCAPE_UNENCLOSED_FIELD = '\134' DATE_FORMAT = 'AUTO' TIMESTAMP_FORMAT = 'AUTO' NULL_IF = ('\\N');
{% do log("Create External Stage if not exists", True) %}
CREATE or REPLACE STAGE {{ var("external_tables_schema") }}.DWH_01_EXT_STAGE 
URL = 's3://willibald-data/V1.0/'
FILE_FORMAT = {{ var("external_tables_schema") }}.FF_SEMICOLON;
{% endmacro %}
