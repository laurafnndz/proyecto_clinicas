-- marts/dim_empleado.sql
{{ config(materialized='table') }}

select
    e.dbt_scd_id              as id_version,
    e.id_empleado,
    e.nombre,
    e.primer_apellido,
    e.segundo_apellido,
    e.dni,
    e.numero_colegiado,
    e.salario,
    p.puesto,
    e.id_centro,
    e.dbt_valid_from,
    e.dbt_valid_to,
    case when e.dbt_valid_to is null 
         then true else false end    as es_actual   -- cuando valid_to is null: es_actual = true  (registro vigente, sin fecha de cierre)
                                                    -- cuando valid_to is not null: es_actual = false (registro histórico, ya cerrado)
from {{ ref('snp_empleado') }} e
left join {{ ref('stg__puesto') }} p
    on e.id_puesto = p.id_puesto