with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
renamed as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }}   AS id_consulta,
        {{ generate_surrogate_key(['pruebas']) }}                                        AS id_prueba,
        {{ clean_string('resultado_prueba') }}                                           AS resultado,
        {{ cast_date('fecha_consulta') }}                                                AS fecha_prueba
    from source
    
)
select * from renamed