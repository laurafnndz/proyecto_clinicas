{{ config(
    materialized='table'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['metodo_pago']) }} as id_metodo_pago,
        {{ clean_string('metodo_pago') }}             as metodo_pago
    from source
)

select * from renamed