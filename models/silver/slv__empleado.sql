{{ config(
    materialized='incremental',
    unique_key='id_empleado'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_empleado,
    nombre,
    primer_apellido,
    segundo_apellido,
    dni,
    fecha_alta,
    salario,
    id_puesto,
    numero_colegiado,
    id_centro,
    updated_at
from {{ ref('stg__empleado') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}