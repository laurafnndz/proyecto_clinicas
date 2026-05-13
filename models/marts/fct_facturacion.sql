
{{ config(materialized='table') }}

select
    f.id_factura,
    f.id_consulta,
    f.id_metodo_pago,
    cast(f.fecha_emision as date)   as id_fecha,
    f.total
from {{ ref('slv__factura') }} f