with 
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),


cleaned as (
    select distinct
        {{ generate_surrogate_key(['raza', 'especie']) }} AS id_raza,
        {{ clean_string('raza') }}                        AS raza,
        {{ generate_surrogate_key(['especie']) }}         AS id_especie,
        
    from source
)
select * from cleaned

--Modelo de catálogo de razas