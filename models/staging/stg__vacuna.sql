with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),


vacunas_split as (
    select distinct                                         --primero cte para separar los campos y en caso de falso nulo nos devuelve un null real
        {{ clean_string('v.value') }}   AS nombre_vacuna,
        especie
    from source,
    LATERAL FLATTEN(input => SPLIT(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
renamed as (
    select distinct                                                              --aquí creo el catálogo de vacunas realmente
        {{ generate_surrogate_key(['nombre_vacuna']) }}      AS id_vacuna,
        CASE
            WHEN {{ clean_string('especie') }} = 'PAJARO' THEN 'NO PROCEDE'
            ELSE nombre_vacuna
        END                                                  AS nombre_vacuna,
        {{ generate_surrogate_key(['especie']) }}            AS id_especie
    from vacunas_split
)
select * from renamed