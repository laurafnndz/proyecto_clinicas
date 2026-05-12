with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
renamed as (
    select
        {{ generate_surrogate_key(['id_factura', 'id_consulta']) }}                          AS id_factura,
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }}         AS id_consulta,
        {{ cast_date('fecha_emision') }}                            AS fecha_emision,
        CAST(total AS NUMERIC(10,2))                                AS total,
        {{ generate_surrogate_key(['metodo_pago']) }}               AS id_metodo_pago
    from source
)
select * from renamed