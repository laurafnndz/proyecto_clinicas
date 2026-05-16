{{ config(materialized='table') }}

select
    {{ generate_surrogate_key(['cv.id_consulta', 'cv.id_vacuna']) }} as id_fct_vacuna,
    cv.id_consulta,
    cv.id_vacuna,
    c.id_mascota,
    f.id_factura
from {{ ref('stg__consulta_vacuna') }} cv
left join {{ ref('stg__consulta') }} c
    on cv.id_consulta = c.id_consulta
left join {{ ref('stg__factura') }} f
    on cv.id_consulta = f.id_consulta