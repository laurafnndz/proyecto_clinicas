{{ config(
    materialized='incremental',
    unique_key='id_consulta'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_consulta,
    id_mascota,
    id_motivo,
    id_empleado,
    id_centro,
    fecha_consulta,
    updated_at
from {{ ref('stg__consulta') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}