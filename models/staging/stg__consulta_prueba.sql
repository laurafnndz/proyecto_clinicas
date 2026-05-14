with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
consulta_prueba_split as (
    select
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }}    AS id_consulta,
        {{ clean_string('p.value') }}                                                    AS nombre_prueba,
        {{ cast_date('fecha_consulta') }}                                                AS fecha_prueba
    from source,
    LATERAL FLATTEN(input => SPLIT(pruebas, '|')) p
),
renamed as (
    select
        cp.id_consulta,
        p.id_prueba,
        cp.fecha_prueba
    from consulta_prueba_split cp
    left join {{ ref('stg__prueba') }} p
        on cp.nombre_prueba = p.nombre_prueba
)
select * from renamed