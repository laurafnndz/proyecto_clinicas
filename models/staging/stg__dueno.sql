{{ config(
    materialized='view'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'duenos') }}
),
cleaned as (
    select distinct
        {{ generate_surrogate_key(['dni_dueno', 'fecha_nacimiento']) }}        as id_dueno,
        {{ separar_nombre('nombre_dueno') }}
        {{ handle_null(clean_string('dni_dueno')) }}                           as dni,
        {{ cast_date('fecha_nacimiento') }}                                    as fecha_nacimiento,
        datediff('year', {{ cast_date('fecha_nacimiento') }}, current_date())  as edad,
        {{ handle_null(clean_string('telefono_dueno')) }}                      as telefono,
        {{ handle_null(clean_string('email_dueno')) }}                         as email,
        {{ handle_null(clean_string('direccion')) }}                           as direccion,
        {{ handle_null(clean_string('codigo_postal')) }}                       as codigo_postal,
        {{ handle_null(clean_string('provincia')) }}                           as provincia,
        {{ handle_null(clean_string('comunidad_autonoma')) }}                  as comunidad_autonoma,
        {{ handle_null(clean_string('pais')) }}                                as pais,
        {{ generate_surrogate_key(['ciudad', 'pais']) }}                       as id_ciudad
        
    from source
)

select * from cleaned

