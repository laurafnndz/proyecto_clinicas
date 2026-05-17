{{ config(
    materialized='view'
) }}

with
    source as (
        select * from {{ source('bronze_clinicas', 'duenos') }}
    ),
    cleaned as (
        select distinct
            {{ generate_surrogate_key(['ciudad', 'pais']) }}  as id_ciudad,
            {{ clean_string('ciudad') }}             as ciudad,
            {{ clean_string('provincia') }}          as provincia,
            {{ clean_string('comunidad_autonoma') }} as comunidad_autonoma,
            {{ clean_string('pais') }}               as pais
        from source
    )

select * from cleaned