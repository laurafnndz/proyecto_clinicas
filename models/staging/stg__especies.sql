with 
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),


cleaned as (
    select distinct
        {{ generate_surrogate_key(['especie']) }}    AS id_especie,
        {{ clean_string('especie') }}               AS nombre_especie
    from source
)
select * from cleaned

--Modelo que genera un catálogo de especies