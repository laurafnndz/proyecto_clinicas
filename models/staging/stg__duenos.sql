with 
source as (
    select * from {{ source('raw_clinicas', 'duenos') }}
),
cleaned as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['dni_dueno', 'nombre_dueno']) }}  AS id_dueno,
        {{ clean_string('SPLIT_PART(nombre_dueno, \' \', 1)') }}               AS nombre,
        {{ clean_string('SPLIT_PART(nombre_dueno, \' \', 2)') }}               AS primer_apellido,
        {{ clean_string('SPLIT_PART(nombre_dueno, \' \', 3)') }}               AS segundo_apellido,
        {{ clean_string('dni_dueno') }}                                         AS dni,
        TRY_CAST(fecha_nacimiento AS DATE)                                      AS fecha_nacimiento,
        {{ clean_string('telefono_dueno') }}                                    AS telefono,
        {{ clean_string('email_dueno') }}                                       AS email,
        {{ clean_string('codigo_postal') }}                                     AS codigo_postal,
        {{ clean_string('provincia') }}                                         AS provincia,
        {{ clean_string('comunidad_autonoma') }}                                AS comunidad_autonoma,
        {{ clean_string('pais') }}                                              AS pais,
        {{ dbt_utils.generate_surrogate_key(['ciudad', 'pais']) }}              AS id_ciudad
    from source
)
select * from cleaned

