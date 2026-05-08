with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

renamed as (

    select distinct
       {{ generate_surrogate_key(['motivo_consulta']) }}       AS id_motivo,
       {{ handle_null(clean_string('motivo_consulta')) }}      AS motivo_consulta
       
       
     

    from source

)

select * from renamed