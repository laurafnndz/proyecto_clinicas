with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
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
        {{ generate_surrogate_key(['s.id_consulta', 's.nombre_mascota', 's.dni_dueno']) }}  AS id_consulta,                               
        m.id_mascota,
        {{ generate_surrogate_key(['s.motivo_consulta']) }}                   AS id_motivo,
        e.id_empleado                                                         AS id_empleado,
        {{ generate_surrogate_key(['s.nombre_centro']) }}                     AS id_centro,
        {{ cast_date('s.fecha_consulta') }}                                   AS fecha_consulta
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