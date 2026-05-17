{{ config(materialized='table') }}

SELECT
    id_prueba,
    nombre_prueba
FROM {{ ref('stg__prueba') }}