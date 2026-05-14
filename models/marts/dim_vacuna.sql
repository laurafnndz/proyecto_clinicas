
{{ config(materialized='table') }}

select
    id_vacuna,
    nombre_vacuna
from {{ ref('stg__vacuna') }}