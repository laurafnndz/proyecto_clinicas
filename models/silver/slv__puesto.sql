{{ config(
    materialized='incremental',
    unique_key='id_puesto'
) }}

select
    id_puesto,
    puesto
from {{ ref('stg__puesto') }}

{% if is_incremental() %}
    where id_puesto not in (select id_puesto from {{ this }})
{% endif %}