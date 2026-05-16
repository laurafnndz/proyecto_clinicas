{{ config(materialized='table') }}

select
    dbt_scd_id                                          as id_version, --Permite identificar cada versión histórica
    m.id_mascota,
    m.id_dueno,
    m.nombre_mascota,
    m.numero_chip,
    m.peso_mascota,
    m.fecha_nacimiento,
    m.esterilizado,
    m.id_raza,
    r.nombre_raza                                       as raza,
    r.especie,
    m.dbt_valid_from,
    m.dbt_valid_to,
    case when m.dbt_valid_to is null
         then true else false end                       as es_actual
from {{ ref('snp_mascota') }} m
left join {{ ref('raza_slv') }} r
    on m.id_raza = r.id_raza