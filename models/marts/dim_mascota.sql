
{{ config(materialized='table') }}

select
    dbt_scd_id              as id_version,
    id_mascota,
    id_dueno,
    nombre_mascota,
    numero_chip,
    peso_mascota,
    fecha_nacimiento,
    esterilizado,
    id_raza,
    dbt_valid_from,
    dbt_valid_to,
    case when dbt_valid_to is null
         then true else false end    as es_actual
from {{ ref('snp_mascota') }}