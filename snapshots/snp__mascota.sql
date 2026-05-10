{% snapshot snp_mascota %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_mascota',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select * from {{ ref('stg__mascota') }}

{% endsnapshot %}