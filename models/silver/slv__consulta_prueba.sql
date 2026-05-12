{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_prueba']
) }}

select
    id_consulta,
    id_prueba,
    resultado,
    fecha_prueba
from {{ ref('stg__consulta_prueba') }}

{% if is_incremental() %}
    where id_consulta not in (select id_consulta from {{ this }})
{% endif %}