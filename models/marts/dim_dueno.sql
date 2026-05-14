
{{ config(materialized='table') }}

with historial as (
    select *,
        row_number() over (
            partition by id_dueno 
            order by dbt_valid_from desc
        ) as rn
    from {{ ref('snp_dueno') }}
    where dbt_is_deleted = 'False'
),

actual as (
    select * from historial where rn = 1
),

anterior as (
    select * from historial where rn = 2
)

select
    a.id_dueno,
    a.nombre,
    a.primer_apellido,
    a.segundo_apellido,
    a.dni,
    a.fecha_nacimiento,
    a.id_ciudad,

    -- telefono
    a.telefono                  as telefono_actual,
    p.telefono                  as telefono_anterior,

    -- email
    a.email                     as email_actual,
    p.email                     as email_anterior,

    -- direccion
    a.direccion                 as direccion_actual,
    p.direccion                 as direccion_anterior,

    -- codigo_postal
    a.codigo_postal             as codigo_postal_actual,
    p.codigo_postal             as codigo_postal_anterior,

    -- provincia
    a.provincia                 as provincia_actual,
    p.provincia                 as provincia_anterior,

    -- comunidad_autonoma
    a.comunidad_autonoma        as comunidad_autonoma_actual,
    p.comunidad_autonoma        as comunidad_autonoma_anterior,

    -- pais
    a.pais                      as pais_actual,
    p.pais                      as pais_anterior,

    a.dbt_valid_from            as fecha_ultimo_cambio

from actual a
left join anterior p
    on a.id_dueno = p.id_dueno