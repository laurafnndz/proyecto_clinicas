with 

source as (

    select * from {{ source('raw_clinicas', 'empleados') }}

),

renamed as (

    select
        id_empleado,
        nombre_completo,
        dni,
        fecha_nacimiento,
        fecha_alta,
        salario,
        puesto,
        numero_colegiado,
        nombre_centro

    from source

)

select * from renamed