with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
renamed as (
    select
        {{ cast_int('id_consulta') }}                           AS id_consulta,
        {{ generate_surrogate_key(['pruebas']) }}               AS id_prueba,
        {{ clean_string('resultado_prueba') }}                  AS resultado,
        {{ cast_date('fecha_consulta') }}                       AS fecha_prueba
    from source
)
select * from renamed