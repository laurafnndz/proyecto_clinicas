
-- Macro para castear fechas

{% macro cast_date(column) %}
    TO_DATE({{ column }}, 'DD/MM/YYYY')
{% endmacro %}


--la llamamos así: 
--  {{ cast_date('value') }} 