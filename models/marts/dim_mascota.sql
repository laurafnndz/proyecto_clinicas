{{ config(materialized='table') }}

select
    dbt_scd_id                                          as id_version, --permite identificar cada versión histórica
    m.id_mascota,
    m.id_dueno,
    m.nombre_mascota,
    m.numero_chip,
    m.peso_mascota,
    m.fecha_nacimiento,
    m.esterilizado,
    m.id_raza,
    r.raza,
    e.nombre_especie                                    as especie,
    m.dbt_valid_from,
    m.dbt_valid_to,
    case when m.dbt_valid_to is null
         then true else false end                       as es_actual
from {{ ref('snp_mascota') }} m
left join {{ ref('stg__raza') }} r
    on m.id_raza = r.id_raza
left join {{ ref('stg__especie') }} e
    on r.id_especie = e.id_especie