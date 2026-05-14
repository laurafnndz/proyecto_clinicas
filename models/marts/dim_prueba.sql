{{ config(materialized='table') }}

SELECT
    id_prueba,
    nombre_prueba
FROM {{ ref('slv__prueba') }}