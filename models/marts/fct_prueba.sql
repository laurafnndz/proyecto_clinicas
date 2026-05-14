{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_prueba']
) }}

SELECT
    -- SK propia
    {{ generate_surrogate_key(['cp.id_consulta', 'cp.id_prueba']) }} AS id_fct_prueba,

    -- FKs naturales
    cp.id_consulta,
    cp.id_prueba,

    -- FKs a dimensiones (heredadas de la consulta)
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    CAST(c.fecha_consulta AS DATE)    AS id_fecha_consulta,
    CAST(cp.fecha_prueba AS DATE)     AS id_fecha_prueba

FROM {{ ref('slv__consulta_prueba') }} cp
LEFT JOIN {{ ref('slv__consulta') }} c
    ON cp.id_consulta = c.id_consulta

{% if is_incremental() %}
WHERE cp.id_consulta NOT IN (SELECT id_consulta FROM {{ this }})
{% endif %}