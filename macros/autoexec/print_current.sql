{% macro print_current() %}

  {% set get_current_query %}
      SELECT CURRENT_WAREHOUSE(), CURRENT_DATABASE(), CURRENT_SCHEMA();
  {% endset %}

  {% set result = run_query(get_current_query) %}
  {% if is_nothing(result) %}
    {% do log("Keine Infos gefunden", True) %}
  {% else %}
    {% set current_warehouse = (result.columns[0].values())[0] %}
    {% set current_database = (result.columns[1].values())[0] %}
    {% set current_schema = (result.columns[2].values())[0] %}
    {% do log("Current Warehouse_Database_Schema: " ~ current_warehouse ~ "__" ~ current_database ~ "__" ~ current_schema , True) %}
{% endif %}


{% endmacro %}