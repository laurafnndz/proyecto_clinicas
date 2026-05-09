{% snapshot snp_empleado %}

{{
    config(
        target_schema='snapshots',
        unique_key='id_empleado',
        strategy='check',
        check_cols=['id_puesto', 'salario', 'id_centro']
    )
}}

select * from {{ ref('stg__empleado') }}

{% endsnapshot %}