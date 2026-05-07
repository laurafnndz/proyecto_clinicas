--Macro para castear booleanos. SI es TRUE. NO es FALSE

{% macro cast_boolean(column, true_value='SI', false_value='NO') %}
    CASE 
        WHEN UPPER(TRIM({{ column }})) = '{{ true_value }}' THEN TRUE
        WHEN UPPER(TRIM({{ column }})) = '{{ false_value }}' THEN FALSE
        ELSE NULL
    END
{% endmacro %}

--la llamamos con:
-- {{ cast_boolean ('value') }}