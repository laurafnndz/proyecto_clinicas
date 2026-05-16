{% snapshot snp_empleado %}
{{
    config(
        target_schema='snapshots',
        unique_key='id_empleado',
        strategy='timestamp',
        updated_at='updated_at',
        hard_deletes='new_record'
    )
}}

select
    * exclude (updated_at),
    CAST(updated_at AS TIMESTAMP_NTZ) AS updated_at
from {{ ref('stg__empleado') }}

{% endsnapshot %}