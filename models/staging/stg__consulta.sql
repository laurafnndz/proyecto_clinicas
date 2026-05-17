{{ config(
    materialized='incremental',
    unique_key='id_consulta'
) }}
with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
empleados as (
    select * from {{ ref('stg__empleado') }}
),
mascotas as (
    select id_mascota, nombre_mascota, id_dueno
    from {{ ref('stg__mascota') }}
),
duenos as (
    select id_dueno, dni
    from {{ ref('stg__dueno') }}
),
renamed as (
    select
        {{ generate_surrogate_key(['s.id_consulta', 's.nombre_mascota', 's.dni_dueno']) }} as id_consulta,
        m.id_mascota,
        {{ generate_surrogate_key(['s.motivo_consulta']) }}                                as id_motivo,
        e.id_empleado                                                                      as id_empleado,
        {{ generate_surrogate_key(['s.nombre_centro']) }}                                  as id_centro,
        {{ cast_date('s.fecha_consulta') }}                                                as fecha_consulta
    from source s
    left join empleados e
        on s.numero_colegiado = e.numero_colegiado
    left join duenos d
        on {{ clean_string('s.dni_dueno') }} = d.dni
    left join mascotas m
        on {{ clean_string('s.nombre_mascota') }} = m.nombre_mascota
        and d.id_dueno = m.id_dueno
)
select * from renamed
{% if is_incremental() %}
where fecha_consulta > (select max(fecha_consulta) from {{ this }})
{% endif %}