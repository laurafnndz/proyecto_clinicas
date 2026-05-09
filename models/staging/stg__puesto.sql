with 

source as (

    select * from {{ source('raw_clinicas', 'empleados') }}

),

renamed as (

    select distinct
        {{ generate_surrogate_key(['puesto'])}}             AS id_puesto,
        {{ handle_null(clean_string('puesto')) }}           AS puesto
    

    from source

)

select * from renamed