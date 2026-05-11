with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
vacunas_split as (
    select distinct
        {{ clean_string('v.value') }}   AS nombre_vacuna,
        especie
    from source,
    LATERAL FLATTEN(input => SPLIT(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
vacunas_case as (
    select
        CASE
            WHEN {{ clean_string('especie') }} = 'PAJARO' THEN 'NO PROCEDE'
            ELSE nombre_vacuna
        END AS nombre_vacuna,
        especie
    from vacunas_split
),
renamed as (
    select distinct
       {{ generate_surrogate_key(['nombre_vacuna', 'especie']) }}  AS id_vacuna,
        nombre_vacuna,
        {{ generate_surrogate_key(['especie']) }}            AS id_especie
    from vacunas_case
)
select * from renamed