{% snapshot snp_empleado %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_empleado',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select * from {{ ref('stg__empleado') }}

{% endsnapshot %}