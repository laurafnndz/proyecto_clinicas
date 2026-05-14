with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
pruebas_split as (
    select distinct
        {{ clean_string('p.value') }}   AS nombre_prueba
    from source,
    LATERAL FLATTEN(input => SPLIT(pruebas, '|')) p
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['nombre_prueba']) }}  AS id_prueba,
        nombre_prueba
    from pruebas_split
)
select * from renamed