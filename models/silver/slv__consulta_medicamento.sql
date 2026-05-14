{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_medicamento']
) }}

select
    id_consulta,
    id_medicamento
from {{ ref('stg__consulta_medicamento') }}

{% if is_incremental() %}
    where id_consulta not in (select id_consulta from {{ this }})
{% endif %}