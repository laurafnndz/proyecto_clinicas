with 

source as (

    select * from {{ source('raw_clinicas', 'hospitalizaciones') }}

),

renamed as (

    select
        id_hospitalizacion,
        id_consulta,
        nombre_mascota,
        dni_dueno,
        telefono_dueno,
        fecha_ingreso,
        fecha_alta

    from source

)

select * from renamed