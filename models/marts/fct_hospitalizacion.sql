{{ config(materialized='table') }}

SELECT
    -- FKs naturales
    h.id_hospitalizacion,
    h.id_consulta,

    -- FKs a dimensiones
    h.id_mascota,
    CAST(h.fecha_ingreso AS DATE)                              AS id_fecha_ingreso,
    CAST(h.fecha_alta AS DATE)                                 AS id_fecha_alta,

    -- Métricas
    DATEDIFF('day', h.fecha_ingreso, h.fecha_alta)             AS dias_hospitalizado

FROM {{ ref('slv__hospitalizacion') }} h