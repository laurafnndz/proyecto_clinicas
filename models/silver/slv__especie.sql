{{ config(
    materialized='table'
) }}

select
    id_especie,
    nombre_especie
from {{ ref('stg__especie') }}

