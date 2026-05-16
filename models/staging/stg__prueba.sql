{{ config(
    materialized='table'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
pruebas_split as (
    select distinct
        {{ clean_string('p.value') }} as nombre_prueba
    from source,
    lateral flatten(input => split(pruebas, '|')) p
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['nombre_prueba']) }} as id_prueba,
        nombre_prueba
    from pruebas_split
)

select * from renamed