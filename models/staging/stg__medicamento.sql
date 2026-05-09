with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
medicamentos_split as (
    select distinct
        {{ clean_string('v.value') }}   AS nombre_medicamento
    from source,
    LATERAL FLATTEN(input => SPLIT(medicamentos, '|')) v
    where medicamentos != 'null'
      and medicamentos is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['nombre_medicamento']) }}    AS id_medicamento,
        nombre_medicamento
    from medicamentos_split
)
select * from renamed