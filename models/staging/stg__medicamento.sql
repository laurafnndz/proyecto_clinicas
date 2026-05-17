{{ config(
    materialized='view'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
medicamentos_split as (
    select distinct
        {{ clean_string('v.value') }} as nombre_medicamento
    from source,
    lateral flatten(input => split(medicamentos, '|')) v
    where medicamentos != 'null'
      and medicamentos is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['nombre_medicamento']) }} as id_medicamento,
        nombre_medicamento
    from medicamentos_split
)

select * from renamed