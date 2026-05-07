#Macro para separar en diferentes columnas el nombre, apellido, apellido que vienen de origen en una única columna

{% macro split_name(column) %}
    SPLIT_PART({{ column }}, ' ', 1) AS nombre,
    SPLIT_PART({{ column }}, ' ', 2) AS primer_apellido,
    SPLIT_PART({{ column }}, ' ', 3) AS segundo_apellido
{% endmacro %}