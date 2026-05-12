{{ config(
    materialized='incremental',
    unique_key='id_hospitalizacion'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_hospitalizacion,
    id_consulta,
    id_mascota,
    fecha_ingreso,
    fecha_alta,
    updated_at
from {{ ref('stg__hospitalizacion') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}