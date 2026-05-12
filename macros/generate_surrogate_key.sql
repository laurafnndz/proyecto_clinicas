{% macro generate_surrogate_key(columns) %}
    {% set normalized_columns = [] %}
    {% for column in columns %}
        {% do normalized_columns.append("TRANSLATE(UPPER(TRIM(" ~ column ~ ")), 'ÁÉÍÓÚÄËÏÖÜÑ', 'AEIOUAEIOUN')") %}
    {% endfor %}
    {{ dbt_utils.generate_surrogate_key(normalized_columns) }}
{% endmacro %}


--Limpia espacios, pasa a mayúsculas y quita tildes para que en caso de que el campo venga sin tildes no genere una sk diferente.
--llamar a la macro con {{ generate_surrogate_key(['ciudad', 'pais']) }}

