{{ config(
    materialized='table',
    
) }}

select
    id_puesto,
    puesto
from {{ ref('stg__puesto') }}

