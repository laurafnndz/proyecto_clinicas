{{ config(
    materialized='incremental',
    unique_key='id_empleado'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'empleados') }}
),
puestos as (
    select * from {{ ref('stg__puesto') }}
),
renamed as (
    select
        {{ generate_surrogate_key(['id_empleado', 'dni']) }}            as id_empleado,
        {{ separar_nombre('nombre_completo') }}
        {{ clean_string('dni') }}                                       as dni,
        {{ cast_date('fecha_alta') }}                                   as fecha_alta,
        cast(salario as numeric(10,2))                                  as salario,
        p.id_puesto,
        case
            when p.puesto = 'VETERINARIO' then {{ clean_string('numero_colegiado') }}
            else 'NO PROCEDE'
        end                                                             as numero_colegiado,
        {{ generate_surrogate_key(['nombre_centro']) }}                 as id_centro,
        _fivetran_synced                                                as updated_at
    from source cv
    left join puestos p
        on upper(cv.puesto) = p.puesto
)

select * from renamed

{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}