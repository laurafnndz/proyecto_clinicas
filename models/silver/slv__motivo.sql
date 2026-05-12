{{ config(
    materialized='table'
   
) }}

select
    id_motivo,
    motivo_consulta
from {{ ref('stg__motivo_consulta') }}

