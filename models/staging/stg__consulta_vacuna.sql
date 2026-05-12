with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
vacunas_split as (
    select
        id_consulta,
        dni_dueno,
        nombre_mascota,
        especie,
        {{ clean_string('v.value') }}   AS nombre_vacuna
    from source,
    LATERAL FLATTEN(input => SPLIT(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }}   AS id_consulta,
        {{ generate_surrogate_key(['nombre_vacuna', 'especie']) }}                      AS id_vacuna
    from vacunas_split
)

select * from renamed