{{ config(
    materialized='table'
) }}

with source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
duenos as (
    select id_dueno, dni
    from {{ ref('stg__dueno') }}
),
mascotas as (
    select
        s.nombre_mascota,
        s.especie,
        s.dni_dueno,
        s.raza,
        s.numero_chip,
        s.fecha_nacimiento,
        s.peso_gr,
        s.esterilizado,
        to_date(s.fecha_consulta, 'DD/MM/YYYY') as fecha_consulta
    from source s
    qualify row_number() over (
        partition by s.nombre_mascota, s.dni_dueno, s.raza
        order by to_date(s.fecha_consulta, 'DD/MM/YYYY') desc
    ) = 1
),
renamed as (
    select
        {{ generate_surrogate_key(['m.nombre_mascota', 'm.dni_dueno', 'm.raza']) }} as id_mascota,
        d.id_dueno,
        {{ generate_surrogate_key(['raza', 'especie']) }}                            as id_raza,
        {{ clean_string('m.nombre_mascota') }}                                      as nombre_mascota,
        case
            when {{ clean_string('m.especie') }} = 'PAJARO' and m.numero_chip is null
                then 'NO PROCEDE'
            when m.numero_chip is null
                then 'SIN DATO'
            else cast(m.numero_chip as varchar)
        end                                                                         as numero_chip,
        {{ cast_int('m.peso_gr') }}                                                 as peso_mascota,
        {{ cast_date('m.fecha_nacimiento') }}                                       as fecha_nacimiento,
        {{ cast_boolean('m.esterilizado') }}                                        as esterilizado,
        m.fecha_consulta                                                            as updated_at
    from mascotas m
    left join duenos d on m.dni_dueno = d.dni
)

select * from renamed