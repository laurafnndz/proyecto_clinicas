with

source as (
    select * from {{ source('raw_clinicas', 'duenos') }}
),

cleaned as (
    select distinct
        {{ generate_surrogate_key(['ciudad','pais']) }}  AS id_ciudad,  --la realizamos con ciudad y pais por si algun dueño es de otro pais
        {{ clean_string('ciudad') }}              AS ciudad,
        {{ clean_string('provincia') }}           AS provincia,
        {{ clean_string('comunidad_autonoma') }}  AS comunidad_autonoma,
        {{ clean_string('pais') }}                AS pais,   
        TRIM(codigo_postal)              AS codigo_postal

    from source
)

select * from cleaned