{{ config(
    materialized='incremental',
    unique_key='id_raza'
) }}

select
    id_raza,
    raza,
    id_especie
from {{ ref('stg__raza') }}

{% if is_incremental() %}
    where id_raza not in (select id_raza from {{ this }})
{% endif %}