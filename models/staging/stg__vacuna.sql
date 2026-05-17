{{ config(
    materialized='view'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
vacunas_split as (
    select distinct
        {{ clean_string('v.value') }} as nombre_vacuna,
        especie
    from source,
    lateral flatten(input => split(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
vacunas_case as (
    select
        case
            when {{ clean_string('especie') }} = 'PAJARO' then 'NO PROCEDE'
            else nombre_vacuna
        end as nombre_vacuna,
        especie
    from vacunas_split
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['nombre_vacuna', 'especie']) }} as id_vacuna,
        nombre_vacuna,
        {{ generate_surrogate_key(['especie']) }}                  as id_especie
    from vacunas_case
)

select * from renamed