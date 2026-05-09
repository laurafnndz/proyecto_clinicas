{% snapshot snp_dueno %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_dueno',
        strategy='check',
        check_cols=['telefono', 'email', 'codigo_postal', 'provincia', 'comunidad_autonoma', 'pais', 'id_ciudad']
    )
}}

select * from {{ ref('stg__dueno') }}

{% endsnapshot %}