
-- Macro para castear fechas

{% macro cast_date(column) %}
    TRY_CAST({{ column }} AS DATE)
{% endmacro %}

--la llamamos así: 
--  {{ cast_date('value') }} 