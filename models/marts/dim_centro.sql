{{ config(materialized='table') }}

select
    c.id_centro,
    c.nombre_centro,
    c.direccion_centro,
    c.cp_centro,
    c.telefono_centro,
    c.id_ciudad,
    u.ciudad,
    u.provincia
from {{ ref('stg__centro') }} c
left join {{ ref('stg__ciudad') }} u
    on c.id_ciudad = u.id_ciudad