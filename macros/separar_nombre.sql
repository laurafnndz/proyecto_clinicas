--Macro para separar en diferentes columnas el nombre, apellido, apellido que vienen de origen en una única columna
--Devuelve el resultado en mayúsculas y limpia los espacios
{% macro separar_nombre(column) %}
    TRIM(UPPER(SPLIT_PART({{ column }}, ' ', 1))) AS nombre,
    TRIM(UPPER(SPLIT_PART({{ column }}, ' ', 2))) AS primer_apellido,
    TRIM(UPPER(SPLIT_PART({{ column }}, ' ', 3))) AS segundo_apellido
{% endmacro %}
-- la llamamos con esto {{ separar_nombre('nombre_dueno') }}