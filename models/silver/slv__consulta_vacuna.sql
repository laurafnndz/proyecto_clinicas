{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_vacuna']
) }}

select
    id_consulta,
    id_vacuna
from {{ ref('stg__consulta_vacuna') }}

{% if is_incremental() %}
    where id_consulta not in (select id_consulta from {{ this }})
{% endif %}