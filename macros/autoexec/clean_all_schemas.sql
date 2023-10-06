{% macro clean_all_schemas() %}

  {% set get_schemas_query %}
      SELECT schema_name 
      FROM INFORMATION_SCHEMA.SCHEMATA 
      WHERE NOT schema_name in ('INFORMATION_SCHEMA', 'PUBLIC', '{{var("meta_schema")}}' )
      order by schema_name desc;
  {% endset %}

  {% set result = run_query(get_schemas_query) %}
  {% if is_nothing(result) %}
    {% do log("Keine Schemas gefunden", True) %}
  {% else %}
    {% set schemas = result.columns[0].values() %}
  
    {% for schema in schemas %}
      {% do log("Cleaning up " + schema + " schema", True) %}
      {{ drop_old_relations(schema=schema) }}
    {% endfor %}
{% endif %}

{% endmacro %}