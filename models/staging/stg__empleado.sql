with 
source as (
    select * from {{ source('raw_clinicas', 'empleados') }}
),
puestos as (
    select * from {{ ref('stg__puesto') }}
),
renamed as (
    select
        {{ clean_string('id_empleado') }}                                     AS id_empleado,
        {{ split_name('cv.nombre_completo') }},
        {{ clean_string('cv.dni') }}                                          AS dni,
        {{ cast_date('cv.fecha_alta') }}                                      AS fecha_alta,
        CAST(cv.salario AS NUMERIC(10,2))                                     AS salario,

        p.id_puesto,


        CASE 
            WHEN p.puesto = 'VETERINARIO' THEN {{ clean_string('cv.numero_colegiado') }}
            ELSE 'NO PROCEDE'
        END                                                                   AS numero_colegiado,
        {{ generate_surrogate_key(['cv.nombre_centro']) }}                    AS id_centro
    from source cv
    left join puestos p
        on UPPER(cv.puesto) = p.puesto
)
select * from renamed