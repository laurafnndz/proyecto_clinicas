
--Transforma los nulos de la columnna que se defina a 'SIN DATO'

{% macro handle_null(column, default_value='SIN DATO') %}
    COALESCE({{ column }}, '{{ default_value }}')
{% endmacro %}

--obviamente no usar dentro de la SK

-- la llamamos con:
--{{ handle_null('value') }}