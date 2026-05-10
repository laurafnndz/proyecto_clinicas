{% snapshot snp_dueno %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_dueno',
        strategy='timestamp',
        updated_at='updated_at'
    )
}}

select * from {{ ref('stg__dueno') }}

{% endsnapshot %}