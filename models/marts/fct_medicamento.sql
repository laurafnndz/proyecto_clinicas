
{{ config(materialized='table') }}

select
    {{ generate_surrogate_key(['id_consulta', 'id_medicamento']) }}  AS  id_fct_medicamento,
    id_consulta,
    id_medicamento
from {{ ref('slv__consulta_medicamento') }}

-- Se genera un id para fct_medicamento porque se trata de una tabla "intermedia" ( factless fact table (tabla de hechos sin medidas) )