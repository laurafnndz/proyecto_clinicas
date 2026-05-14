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

select * from {{ ref('stg__empleado') }}

{% endsnapshot %}