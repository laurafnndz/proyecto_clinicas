{{ config(materialized='table') }}
select
    -- FKs naturales
    h.id_hospitalizacion,
    h.id_consulta,
    -- FKs a dimensiones
    h.id_mascota,
    cast(h.fecha_ingreso as date)                              as id_fecha_ingreso,
    case
        when h.fecha_alta is not null then cast(h.fecha_alta as date)
        else null
    end                                                        as id_fecha_alta,
    -- Métricas
    datediff('day', h.fecha_ingreso, coalesce(h.fecha_alta, current_date)) as dias_hospitalizado,
    -- Para detectar reingresos
    count(*) over (
        partition by h.id_mascota
        order by h.fecha_ingreso
        rows between unbounded preceding and current row
    ) - 1                                                      as num_hospitalizaciones_previas,
    case
        when count(*) over (
            partition by h.id_mascota
            order by h.fecha_ingreso
            rows between unbounded preceding and current row
        ) > 1 then true
        else false
    end                                                        as es_reingreso,
    -- Días desde última hospitalización
    datediff('day',
        lag(h.fecha_alta) over (
            partition by h.id_mascota
            order by h.fecha_ingreso
        ),
        h.fecha_ingreso
    )                                                          as dias_desde_ultimo_ingreso
from {{ ref('stg__hospitalizacion') }} h