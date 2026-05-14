--Castea enteros

{% macro cast_int(column) %}
    CAST({{ column }} AS INT)
{% endmacro %}

--la llamamos:

--  {{ cast_int('value') }}