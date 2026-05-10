with

source as (
    select * from {{ source('raw_clinicas', 'duenos') }}
),

cleaned as (
    select distinct
        {{ generate_surrogate_key(['dni_dueno', 'fecha_nacimiento'])}}                      AS id_dueno,
        {{ separar_nombre('nombre_dueno') }},
        {{ handle_null(clean_string('dni_dueno')) }}                                        AS dni,
        {{ cast_date('fecha_nacimiento') }}                                                 AS fecha_nacimiento, --no aplico handle null porque es dato tipo fecha
        DATEDIFF('year', {{ cast_date('fecha_nacimiento') }}, CURRENT_DATE())               AS edad, --calculo la edad con fecha nacimiento y fecha actual. no handle null
        {{ handle_null(clean_string('telefono_dueno')) }}                                   AS telefono,
        {{ handle_null(clean_string('email_dueno')) }}                                      AS email,
        {{ handle_null(clean_string('codigo_postal')) }}                                    AS codigo_postal,
        {{ handle_null(clean_string('provincia')) }}                                        AS provincia,
        {{ handle_null(clean_string('comunidad_autonoma')) }}                               AS comunidad_autonoma,
        {{ handle_null(clean_string('pais')) }}                                             AS pais,
        {{ generate_surrogate_key(['ciudad', 'pais'])}}                                     AS id_ciudad,
        _fivetran_synced                                                                    AS updated_at
    from source
)
select * from cleaned

--Limpieza de todos los campos y creación de sk para id ciudad (ya hecho en stg__ciudad) y para id_dueno
--Campo con snapshot tipo timestamp

