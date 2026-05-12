{{ config(
    materialized='incremental',
    unique_key='id_medicamento'
) }}

select
    id_medicamento,
    nombre_medicamento
from {{ ref('stg__medicamento') }}

{% if is_incremental() %}
    where id_medicamento not in (select id_medicamento from {{ this }})
{% endif %}