{{ config(
    materialized='incremental',
    unique_key='id_centro'
) }}

select
    id_centro,
    nombre_centro,
    id_ciudad,
    direccion_centro,
    cp_centro,
    telefono_centro
from {{ ref('stg__centro') }}

{% if is_incremental() %}
    where id_centro not in (select id_centro from {{ this }})
{% endif %}