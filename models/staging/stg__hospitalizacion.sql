with
source as (
    select * from {{ source('raw_clinicas', 'hospitalizaciones') }}
),
duenos as (
    select id_dueno, dni
    from {{ ref('stg__dueno') }} -- en hospitalizaciones no tengo id_dueno, tengo dni, por eso eljoin con stg__dueno para poder tener id dueno y hacer el join con stg__mascota correctamente
                                --sin ese join solo podría hacer el join de mascota con hospitalizacion con el nombre de la mascota
),
mascotas as (
    select id_mascota, nombre_mascota, id_dueno
    from {{ ref('stg__mascota') }}
),
renamed as (
    select
        {{ cast_int('h.id_hospitalizacion') }}      AS id_hospitalizacion,
        {{ cast_int('h.id_consulta') }}             AS id_consulta,
        m.id_mascota,
        {{ cast_date('h.fecha_ingreso') }}          AS fecha_ingreso,
        {{ cast_date('h.fecha_alta') }}             AS fecha_alta
    from source h
    left join duenos d
        on {{ clean_string('h.dni_dueno') }} = d.dni
    left join mascotas m
        on {{ clean_string('h.nombre_mascota') }} = m.nombre_mascota
        and d.id_dueno = m.id_dueno
)
select * from renamed