-- Test: verifica que cada consulta tiene como máximo una factura asociada
-- Modelo: stg__factura
-- Columnas implicadas: id_consulta, id_factura
-- Si devuelve filas, significa que hay consultas con más de una factura asignada

select id_consulta
from {{ ref('stg__factura') }}
group by id_consulta
having count(id_factura) > 1