{% macro clean_string(column) %}

    upper(trim({{ column }}))

{% endmacro %}

#Macro para quitar espacios y pasar todo a mayúsculas