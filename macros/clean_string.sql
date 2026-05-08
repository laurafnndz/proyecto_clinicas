{% macro clean_string(column) %}
    COALESCE(UPPER(TRIM({{ column }})), 'SIN DATO')
{% endmacro %}

--Macro para quitar espacios y pasar todo a mayúsculas. En caso de que haya nulos devuelve SIN DATO

--la llamamos de esta manera: {{ clean_string('value') }}