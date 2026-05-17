{{ config(
    materialized='view'
) }}
with
source as (
    select * from {{ source('bronze_clinicas', 'empleados') }}
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['puesto']) }}   as id_puesto,
        {{ handle_null(clean_string('puesto')) }}  as puesto
    from source
)

select * from renamed