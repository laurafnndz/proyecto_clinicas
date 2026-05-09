-- Test: verifica que ningún empleado tiene más de un puesto asignado
-- Modelo: stg__empleado
-- Columnas implicadas: id_empleado, id_puesto
-- Si devuelve filas, significa que hay empleados con más de un puesto

select id_empleado
from {{ ref('stg__empleado') }}
group by id_empleado
having count(id_puesto) > 1