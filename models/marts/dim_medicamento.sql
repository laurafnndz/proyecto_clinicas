{{ config(materialized='table') }}

select
    id_medicamento,
    nombre_medicamento
from {{ ref('stg__medicamento') }}