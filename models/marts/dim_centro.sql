
{{ config(materialized='table') }}

select
    id_centro,
    nombre_centro,
    direccion_centro,
    cp_centro,
    telefono_centro,
    id_ciudad
from {{ ref('stg__centro') }}