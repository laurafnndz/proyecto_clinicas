
{{ config(materialized='table') }}

select
    id_ciudad,
    ciudad,
    codigo_postal,
    provincia,
    comunidad_autonoma,
    pais
from {{ ref('stg__ciudad') }}