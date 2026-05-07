with 

source as (

    select * from {{ source('raw_clinicas', 'duenos') }}

),

cleaned as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['dni_dueno','nombre_dueno']) }}  AS id_ciudad,  --la realizamos con ciudad y pais por si algun dueño es de otro pais
        {{ clean_string('nombre_dueno') }}              AS nombre_dueno,
        {{ ('dni_dueno') }}                 AS dni,
        {{ ('fecha_nacimiento') }}          AS fecha_nacimiento,
        {{ ('telefono') }}                  AS telefono,
        email                               AS email,
        ciudad_id                           AS ciudad_id
    from source
)

select * from cleaned

