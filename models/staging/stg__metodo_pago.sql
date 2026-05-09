with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

renamed as (

    select distinct
        
        {{ generate_surrogate_key(['metodo_pago']) }}                   AS id_metodo_pago ,
        {{ clean_string('metodo_pago') }}                               AS metodo_pago

    from source

)

select * from renamed