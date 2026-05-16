{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_prueba']
) }}

select
    -- SK propia
    {{ generate_surrogate_key(['cp.id_consulta', 'cp.id_prueba']) }} as id_fct_prueba,
    -- FKs naturales
    cp.id_consulta,
    cp.id_prueba,
    -- FKs a dimensiones (heredadas de la consulta)
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    cast(c.fecha_consulta as date)    as id_fecha_consulta,
    cast(cp.fecha_prueba as date)     as id_fecha_prueba
from {{ ref('stg__consulta_prueba') }} cp
left join {{ ref('stg__consulta') }} c
    on cp.id_consulta = c.id_consulta

{% if is_incremental() %}
where cp.id_consulta not in (select id_consulta from {{ this }})
{% endif %}