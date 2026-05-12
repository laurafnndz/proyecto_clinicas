{{ config(
    materialized='incremental',
    unique_key='id_motivo'
) }}

select
    id_motivo,
    motivo_consulta
from {{ ref('stg__motivo_consulta') }}

{% if is_incremental() %}
    where id_motivo not in (select id_motivo from {{ this }})
{% endif %}