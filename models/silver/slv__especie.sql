{{ config(
    materialized='incremental',
    unique_key='id_especie'
) }}

select
    id_especie,
    nombre_especie
from {{ ref('stg__especie') }}

{% if is_incremental() %}
    where id_especie not in (select id_especie from {{ this }})
{% endif %}