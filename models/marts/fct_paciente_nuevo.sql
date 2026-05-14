
{{ config(materialized='table') }}

with consultas as (
    select
        id_mascota,
        id_centro,
        fecha_consulta,
        count(*) over (
            partition by id_mascota, id_centro
        ) as total_visitas,
        row_number() over (
            partition by id_mascota, id_centro
            order by fecha_consulta asc
        ) as num_visita
    from {{ ref('slv__consulta') }}
)

select
    {{ generate_surrogate_key(['c.id_mascota', 'c.id_centro']) }}   as id_fct_paciente_nuevo,
    c.id_mascota,
    c.id_centro,
    cast(c.fecha_consulta as date)                                   as id_fecha,
    m.id_raza,
    true                                                             as es_nuevo,
    case when c.total_visitas > 1
         then true else false end                                    as volvio
from consultas c
left join {{ ref('slv__mascota') }} m
    on c.id_mascota = m.id_mascota
where c.num_visita = 1