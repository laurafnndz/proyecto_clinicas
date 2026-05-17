{% snapshot snp_dueno %}
{{
    config(
        target_schema='snapshots',
        unique_key='id_dueno',
        strategy='check',
        check_cols=['telefono', 'email', 'direccion', 'codigo_postal', 'id_ciudad'],
        hard_deletes='new_record'
    )
}}
select * from {{ ref('stg__dueno') }}
{% endsnapshot %}