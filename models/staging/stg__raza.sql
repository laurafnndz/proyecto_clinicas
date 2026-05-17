{{ config(
    materialized='view'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
cleaned as (
    select distinct
        {{ generate_surrogate_key(['raza', 'especie']) }} as id_raza,
        {{ clean_string('raza') }}                        as raza,
        {{ generate_surrogate_key(['especie']) }}         as id_especie
    from source
)

select * from cleaned
-- Modelo de catálogo de razas