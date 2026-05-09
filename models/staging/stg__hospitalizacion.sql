with
source as (
    select * from {{ source('raw_clinicas', 'hospitalizaciones') }}
),
mascotas as (
    select * from {{ ref('stg__mascota') }}
),
renamed as (
    select
        {{ cast_int('h.id_hospitalizacion') }}      AS id_hospitalizacion,
        {{ cast_int('h.id_consulta') }}             AS id_consulta,
        m.id_mascota,
        {{ cast_date('h.fecha_ingreso') }}          AS fecha_ingreso,
        {{ cast_date('h.fecha_alta') }}             AS fecha_alta
    from source h
    left join mascotas m
        on {{ clean_string('h.nombre_mascota') }} = m.nombre_mascota
        and {{ clean_string('h.dni_dueno') }} = m.dni
)
select * from renamed