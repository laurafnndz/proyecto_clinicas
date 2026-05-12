{{ config(
    materialized='table'
) }}

select
    id_prueba,
    nombre_prueba
from {{ ref('stg__prueba') }}