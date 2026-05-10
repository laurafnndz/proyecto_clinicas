with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
vacunas_split as (
    select
        id_consulta,
        {{ clean_string('v.value') }}   AS nombre_vacuna
    from source,
    LATERAL FLATTEN(input => SPLIT(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
renamed as (
    select
        {{ cast_int('id_consulta') }}                           AS id_consulta,
        {{ generate_surrogate_key(['nombre_vacuna']) }}         AS id_vacuna
    from vacunas_split
)
select * from renamed