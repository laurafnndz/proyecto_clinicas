with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

empleados as (
    select * from {{ ref('stg__empleado') }}
),

renamed as (

    select
        {{ cast_int('s.id_consulta') }}                                       AS id_consulta,
        {{ generate_surrogate_key(['s.numero_chip', 's.dni_dueno']) }}        AS id_mascota,
        {{ generate_surrogate_key(['s.motivo_consulta']) }}                   AS id_motivo,
        e.id_empleado                                                         AS id_empleado,
        {{ generate_surrogate_key(['s.nombre_centro']) }}                     AS id_centro,
        {{ cast_date('s.fecha_consulta') }}                                   AS fecha_consulta
    from source s
    left join empleados e
        on s.numero_colegiado = e.numero_colegiado
)
select * from renamed