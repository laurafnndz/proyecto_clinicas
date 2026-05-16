{{ config(
    materialized='incremental',
    unique_key=['id_consulta', 'id_medicamento']
) }}

select
    -- SK propia
    {{ generate_surrogate_key(['cm.id_consulta', 'cm.id_medicamento']) }} as id_fct_medicamento,
    -- FKs naturales
    cm.id_consulta,
    cm.id_medicamento,
    -- FKs a dimensiones (heredadas de la consulta)
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    cast(c.fecha_consulta as date)    as id_fecha
from {{ ref('stg__consulta_medicamento') }} cm
left join {{ ref('stg__consulta') }} c
    on cm.id_consulta = c.id_consulta

{% if is_incremental() %}
where cm.id_consulta not in (select id_consulta from {{ this }})
{% endif %}