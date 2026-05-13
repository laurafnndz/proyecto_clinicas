
{{ config(materialized='table') }}

select
    c.id_consulta,
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    cast(c.fecha_consulta as date)                          as id_fecha,

    -- medidas
    f.total                                                 as total_facturacion,
    datediff('day', h.fecha_ingreso, h.fecha_alta)          as dias_hospitalizado,
    case when h.id_hospitalizacion is not null
         then true else false end                           as fue_hospitalizado

from {{ ref('slv__consulta') }} c
left join {{ ref('slv__factura') }} f
    on c.id_consulta = f.id_consulta
left join {{ ref('slv__hospitalizacion') }} h
    on c.id_consulta = h.id_consulta