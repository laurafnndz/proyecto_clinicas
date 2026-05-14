with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
medicamentos_split as ( --cte para limpiar el campo medicamento
    select
        id_consulta,
        dni_dueno,
        nombre_mascota,
        {{ clean_string('v.value') }}   AS nombre_medicamento
    from source,
    LATERAL FLATTEN(input => SPLIT(medicamentos, '|')) v
    where medicamentos != 'null'
      and medicamentos is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }}   AS id_consulta,
        {{ generate_surrogate_key(['nombre_medicamento']) }}                             AS id_medicamento
    from medicamentos_split
)

select * from renamed