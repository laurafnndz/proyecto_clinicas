{{ config(
    materialized='table'
) }}

select
    id_raza,
    raza,
    id_especie
from {{ ref('stg__raza') }}

