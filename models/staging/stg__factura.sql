with
source as (
    select * from {{ source('raw_clinicas', 'consultas') }}
),
renamed as (
    select
        {{ cast_int('id_factura') }}                                AS id_factura,
        {{ cast_int('id_consulta') }}                               AS id_consulta,
        {{ cast_date('fecha_emision') }}                            AS fecha_emision,
        CAST(total AS NUMERIC(10,2))                                AS total,
        {{ generate_surrogate_key(['metodo_pago']) }}               AS id_metodo_pago
    from source
)
select * from renamed