{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_vacuna']
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
vacunas_split as (
    select
        id_consulta,
        dni_dueno,
        nombre_mascota,
        especie,
        {{ clean_string('v.value') }} as nombre_vacuna
    from source,
    lateral flatten(input => split(vacuna_pendiente, '|')) v
    where vacuna_pendiente != 'null'
      and vacuna_pendiente is not null
),
renamed as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }} as id_consulta,
        {{ generate_surrogate_key(['nombre_vacuna', 'especie']) }}                    as id_vacuna
    from vacunas_split
)

select * from renamed

{% if is_incremental() %}
    where id_consulta not in (select id_consulta from {{ this }})
{% endif %}