{{ config(
    materialized='incremental',
    unique_key='id_mascota'
) }}

{% if is_incremental() %}
with max_updated as (
    select max(updated_at) as max_ts from {{ this }}
)
{% endif %}

select
    id_mascota,
    id_dueno,
    id_raza,
    nombre_mascota,
    numero_chip,
    peso_mascota,
    fecha_nacimiento,
    esterilizado,
    updated_at
from {{ ref('stg__mascota') }}

{% if is_incremental() %}
    where updated_at > (select max_ts from max_updated)
{% endif %}