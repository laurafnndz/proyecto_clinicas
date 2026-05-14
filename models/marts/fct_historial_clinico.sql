{{ config(materialized='table') }}

SELECT
    -- FKs naturales
    c.id_consulta,
    f.id_factura,

    -- FKs a dimensiones
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    CAST(c.fecha_consulta AS DATE)                         AS id_fecha,

    -- Flags
    CASE WHEN h.id_hospitalizacion IS NOT NULL
         THEN TRUE ELSE FALSE END                          AS fue_hospitalizado

FROM {{ ref('slv__consulta') }} c
LEFT JOIN {{ ref('slv__factura') }} f
    ON c.id_consulta = f.id_consulta
LEFT JOIN {{ ref('slv__hospitalizacion') }} h
    ON c.id_consulta = h.id_consulta