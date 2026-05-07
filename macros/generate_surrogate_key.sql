{% macro generate_surrogate_key(columns) %}

    {{ dbt_utils.generate_surrogate_key(columns) }}

{% endmacro %}

--llamar a la macro con {{ generate_surrogate_key(['ciudad', 'pais']) }}