with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

renamed as (


    select
        {{ generate_surrogate_key(['nombre_centro', 'cp_centro'])}}                   AS id_centro,
        nombre_centro,
        id_ciudad,
        direccion_centro,
        cp_centro,
        telefono_centro,
        

    from source

)

select * from renamed