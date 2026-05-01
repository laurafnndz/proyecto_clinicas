{{ config(
    materialized='incremental',
    unique_key='DNI',
    on_schema_change='sync_all_columns',
    hard_deletes='delete'         
) }}

SELECT
    nombre,
    DNI,
    email,
    fecha_alta_sistema
FROM {{ source('google_sheet', 'users') }}