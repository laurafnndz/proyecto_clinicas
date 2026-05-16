{{ config(
    materialized='table'
) }}

with
source as (
    select * from {{ source('bronze_clinicas', 'consultas') }}
),
renamed as (
    select distinct
        {{ generate_surrogate_key(['motivo_consulta']) }}  as id_motivo,
        {{ handle_null(clean_string('motivo_consulta')) }} as motivo_consulta
    from source
)

select * from renamed