{{ config(
    materialized='table'
    
) }}

select
    id_vacuna,
    nombre_vacuna,
    id_especie
from {{ ref('stg__vacuna') }}

