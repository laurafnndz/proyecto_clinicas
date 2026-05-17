{% snapshot snp_empleado %}
{{
    config(
        target_schema='snapshots',
        unique_key='id_empleado',
        strategy='check',
        check_cols=['salario', 'id_centro', 'nombre_puesto'],
        hard_deletes='new_record'
    )
}}

with empleados as (
    select * from {{ ref('stg__empleado') }}
),

puestos as (
    select * from {{ ref('stg__puesto') }}
)

select
    emp.id_empleado,
    emp.nombre,           
    emp.primer_apellido,   
    emp.segundo_apellido,  
    emp.dni,
    emp.fecha_alta,
    emp.salario,
    emp.id_centro,
    emp.numero_colegiado,
    emp.id_puesto,             
    pue.puesto as nombre_puesto 

from empleados emp
left join puestos pue
    on emp.id_puesto = pue.id_puesto

{% endsnapshot %}