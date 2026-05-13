
{{ config(materialized='table') }}

select
    h.id_hospitalizacion,
    h.id_consulta,
    h.id_mascota,
    cast(h.fecha_ingreso as date)                               as id_fecha,
    h.fecha_ingreso,
    h.fecha_alta,
    datediff('day', h.fecha_ingreso, h.fecha_alta)              as dias_hospitalizado
from {{ ref('slv__hospitalizacion') }} h