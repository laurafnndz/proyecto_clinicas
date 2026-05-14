{{ config(
    materialized='incremental',
    unique_key='id_factura'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_factura,
    id_consulta,
    fecha_emision,
    total,
    id_metodo_pago,
    updated_at
from {{ ref('stg__factura') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}