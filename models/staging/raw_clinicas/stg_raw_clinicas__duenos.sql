with 

source as (

    select * from {{ source('raw_clinicas', 'duenos') }}

),

renamed as (

    select
        nombre_dueno,
        dni_dueno,
        fecha_nacimiento,
        telefono_dueno,
        email_dueno,
        direccion,
        municipio,
        codigo_postal,
        provincia,
        comunidad_autonoma,
        pais

    from source

)

select * from renamed