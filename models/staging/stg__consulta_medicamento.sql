with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
medicamentos_split as (             --cte para limpiar el campo de nombre medicamento
    select
        id_consulta,
        {{ clean_string('v.value') }}   AS nombre_medicamento
    from source,
    LATERAL FLATTEN(input => SPLIT(medicamentos, '|')) v
    where medicamentos != 'null'
      and medicamentos is not null
),
renamed as (                            --con la limpieza ya realizada creamos el id_medicamento con sk con campo nombre_medicamento
    select
        {{ cast_int('id_consulta') }}                               AS id_consulta,
        {{ generate_surrogate_key(['nombre_medicamento']) }}        AS id_medicamento
    from medicamentos_split
)
select * from renamed