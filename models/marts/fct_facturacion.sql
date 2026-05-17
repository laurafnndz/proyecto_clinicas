{{ config(materialized='table') }}

select
    -- FKs naturales
    f.id_factura,
    f.id_consulta,
    -- FKs a dimensiones
    f.id_metodo_pago,
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    cast(f.fecha_emision as date)                            as id_fecha,
    -- Métricas propias
    f.total,
    -- Flags y métricas de contexto
    case when h.id_hospitalizacion is not null
         then true else false end                            as fue_hospitalizado,
    coalesce(med.num_medicamentos, 0)                       as num_medicamentos,
    coalesce(pru.num_pruebas, 0)                            as num_pruebas
from {{ ref('stg__factura') }} f
left join {{ ref('stg__consulta') }} c
    on f.id_consulta = c.id_consulta
left join {{ ref('stg__hospitalizacion') }} h
    on f.id_consulta = h.id_consulta
left join (
    select id_consulta, count(*) as num_medicamentos
    from {{ ref('stg__consulta_medicamento') }}
    group by id_consulta
) med on f.id_consulta = med.id_consulta
left join (
    select id_consulta, count(*) as num_pruebas
    from {{ ref('stg__consulta_prueba') }}
    group by id_consulta
) pru on f.id_consulta = pru.id_consulta