{{ config(
    materialized='view'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
cleaned as (
    select distinct
        {{ generate_surrogate_key(['especie']) }} as id_especie,
        {{ clean_string('especie') }}             as nombre_especie
    from source
)

select * from cleaned