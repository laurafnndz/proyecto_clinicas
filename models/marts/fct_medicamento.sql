{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_medicamento']
) }}

SELECT
    -- SK propia
    {{ generate_surrogate_key(['cm.id_consulta', 'cm.id_medicamento']) }} AS id_fct_medicamento,

    -- FKs naturales
    cm.id_consulta,
    cm.id_medicamento,

    -- FKs a dimensiones (heredadas de la consulta)
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    CAST(c.fecha_consulta AS DATE)    AS id_fecha

FROM {{ ref('slv__consulta_medicamento') }} cm
LEFT JOIN {{ ref('slv__consulta') }} c
    ON cm.id_consulta = c.id_consulta

{% if is_incremental() %}
WHERE cm.id_consulta NOT IN (SELECT id_consulta FROM {{ this }})
{% endif %}