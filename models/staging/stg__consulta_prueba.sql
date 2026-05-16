{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_prueba']
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
consulta_prueba_split as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }} as id_consulta,
        {{ clean_string('p.value') }}                                                 as nombre_prueba,
        {{ cast_date('fecha_consulta') }}                                             as fecha_prueba
    from source,
    lateral flatten(input => split(pruebas, '|')) p
),
renamed as (
    select
        cp.id_consulta,
        p.id_prueba,
        cp.fecha_prueba
    from consulta_prueba_split cp
    left join {{ ref('stg__prueba') }} p
        on cp.nombre_prueba = p.nombre_prueba
)

select * from renamed

{% if is_incremental() %}
where fecha_prueba > (select max(fecha_prueba) from {{ this }})
{% endif %}