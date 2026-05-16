{{ config(materialized='table') }}

select
    -- FKs naturales
    c.id_consulta,
    f.id_factura,
    -- FKs a dimensiones
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    cast(c.fecha_consulta as date)                        as id_fecha,
    -- Flags
    case when h.id_hospitalizacion is not null
         then true else false end                         as fue_hospitalizado
from {{ ref('stg__consulta') }} c
left join {{ ref('stg__factura') }} f
    on c.id_consulta = f.id_consulta
left join {{ ref('stg__hospitalizacion') }} h
    on c.id_consulta = h.id_consulta