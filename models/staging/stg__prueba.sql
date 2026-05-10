with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['pruebas']) }}       AS id_prueba,
        {{ clean_string('pruebas') }}                  AS nombre_prueba
    from source
)
select * from renamed