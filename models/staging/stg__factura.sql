{{ config(
    materialized='incremental',
    unique_key='id_factura'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
renamed as (
    select
        {{ generate_surrogate_key(['id_factura', 'id_consulta']) }}                  as id_factura,
        {{ generate_surrogate_key(['id_consulta', 'nombre_mascota', 'dni_dueno']) }} as id_consulta,
        {{ cast_date('fecha_emision') }}                                             as fecha_emision,
        cast(total as numeric(10,2))                                                 as total,
        {{ generate_surrogate_key(['metodo_pago']) }}                                as id_metodo_pago
    from source
)

select * from renamed

{% if is_incremental() %}
where fecha_emision >= (select max(fecha_emision) from {{ this }})
{% endif %}