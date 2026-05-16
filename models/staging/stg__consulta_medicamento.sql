{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_medicamento']
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
medicamentos_split as (
    select
        id_consulta,
        dni_dueno,
        nombre_mascota,
        {{ clean_string('v.value') }} as nombre_medicamento
    from source,
    lateral flatten(input => split(medicamentos, '|')) v
    where medicamentos != 'null'
      and medicamentos is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }} as id_consulta,
        {{ generate_surrogate_key(['nombre_medicamento']) }}                          as id_medicamento
    from medicamentos_split
)

select * from renamed

{% if is_incremental() %}
    where id_consulta not in (select id_consulta from {{ this }})
{% endif %}