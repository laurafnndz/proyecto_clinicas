with 
source as (
    select * from {{ source('raw_clinicas', 'empleados') }}
),
puestos as (
    select * from {{ ref('stg__puesto') }}
),
renamed as (
    select
        {{ cast_int('id_empleado') }}                                         AS id_empleado,
        {{ separar_nombre('nombre_completo') }}
        {{ clean_string('dni') }}                                          AS dni,
        {{ cast_date('fecha_alta') }}                                      AS fecha_alta,
        CAST(salario AS NUMERIC(10,2))                                     AS salario,

        p.id_puesto,


        CASE 
            WHEN p.puesto = 'VETERINARIO' THEN {{ clean_string('numero_colegiado') }}
            ELSE 'NO PROCEDE'
        END                                                                   AS numero_colegiado,
        {{ generate_surrogate_key(['nombre_centro']) }}                    AS id_centro,
        _fivetran_synced                                                      AS updated_at
    from source cv
    left join puestos p
        on UPPER(cv.puesto) = p.puesto
)
select * from renamed

