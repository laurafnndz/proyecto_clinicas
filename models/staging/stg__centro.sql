{{ config(
    materialized='incremental',
    unique_key='id_centro'
) }}

with 
    source as (
        select * from {{ source('bronze_clinicas', 'consultas') }}
    ),
    ciudades as (
        select * from {{ ref('stg__ciudad') }}
    ),
    renamed as (
        select distinct
            {{ generate_surrogate_key(['cv.nombre_centro']) }} as id_centro,
            cv.nombre_centro,
            c.id_ciudad,
            cv.direccion_centro,
            cv.cp_centro,
            cv.telefono_centro
        from source cv
        left join ciudades c
            on upper(cv.ciudad_centro) = c.ciudad
    )

select * from renamed

{% if is_incremental() %}
    where id_centro not in (select id_centro from {{ this }})
{% endif %}