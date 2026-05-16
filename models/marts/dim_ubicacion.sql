
{{ config(materialized='table') }}

select
    id_ciudad,
    ciudad,
    provincia,
    comunidad_autonoma,
    pais
from {{ ref('stg__ciudad') }}