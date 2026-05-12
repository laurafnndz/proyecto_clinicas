{{ config(
    materialized='incremental',
    unique_key='id_dueno'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_dueno,
    nombre,
    primer_apellido,
    segundo_apellido,
    dni,
    fecha_nacimiento,
    edad,
    telefono,
    email,
    direccion,
    id_ciudad,
    updated_at
from {{ ref('stg__dueno') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}