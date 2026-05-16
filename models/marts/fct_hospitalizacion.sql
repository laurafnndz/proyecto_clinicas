{{ config(materialized='table') }}

select
    -- FKs naturales
    h.id_hospitalizacion,
    h.id_consulta,
    -- FKs a dimensiones
    h.id_mascota,
    cast(h.fecha_ingreso as date)                             as id_fecha_ingreso,
    cast(h.fecha_alta as date)                                as id_fecha_alta,
    -- Métricas
    datediff('day', h.fecha_ingreso, h.fecha_alta)            as dias_hospitalizado
from {{ ref('stg__hospitalizacion') }} h