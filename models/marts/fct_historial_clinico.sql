{{ config(materialized='table') }}

select
    -- FKs naturales
    c.id_consulta,
    f.id_factura,
    -- FKs a dimensiones
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    c.id_motivo,
    cast(c.fecha_consulta as date)                        as id_fecha,
    -- Flags
    case when h.id_hospitalizacion is not null
         then true else false end                         as fue_hospitalizado,
    -- campos de peso y alerta clínica
    m.peso_mascota,
    s.peso_min_g,
    s.peso_max_g,
    case
        when datediff('month', m.fecha_nacimiento, current_date()) < 6  then 'Cachorro'
        when datediff('month', m.fecha_nacimiento, current_date()) < 12 then 'Juvenil'
        when datediff('year',  m.fecha_nacimiento, current_date()) < 8  then 'Adulto'
        else 'Senior'
    end                                                   as etapa_vital,
    case
        when m.peso_mascota < s.peso_min_g then 'BAJO PESO'
        when m.peso_mascota > s.peso_max_g then 'SOBREPESO'
        else 'PESO NORMAL'
    end                                                   as estado_peso
from {{ ref('stg__consulta') }} c
left join {{ ref('stg__factura') }} f
    on c.id_consulta = f.id_consulta
left join {{ ref('stg__hospitalizacion') }} h
    on c.id_consulta = h.id_consulta
left join {{ ref('dim_mascota') }} m
    on c.id_mascota = m.id_mascota
    and m.es_actual = true
left join {{ ref('rango_peso_raza') }} s
    on upper(m.especie) = upper(s.nombre_especie)
    and upper(m.raza) = upper(s.raza)
    and case
        when datediff('month', m.fecha_nacimiento, current_date()) < 6  then 'Cachorro'
        when datediff('month', m.fecha_nacimiento, current_date()) < 12 then 'Juvenil'
        when datediff('year',  m.fecha_nacimiento, current_date()) < 8  then 'Adulto'
        else 'Senior'
    end = s.etapa_vital