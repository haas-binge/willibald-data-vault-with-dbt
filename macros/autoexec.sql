{% macro autoexec() %}

{{ print_current() }}

{{ create_extra_schemas() }} 

{{ prepare_external_stage() }} 

{{ create_table_meta_hwm() }}

{#{ clean_all_schemas() }#}

{% endmacro %}

