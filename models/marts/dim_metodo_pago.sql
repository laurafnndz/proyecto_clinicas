{{ config(materialized='table') }}

select
    id_metodo_pago,
    metodo_pago
from {{ ref('stg__metodo_pago') }}