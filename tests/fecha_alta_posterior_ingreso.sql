-- Test: verifica que la fecha de alta de hospitalización sea siempre posterior a la fecha de ingreso
-- Modelo: stg__hospitalizacion
-- Columnas implicadas: fecha_alta, fecha_ingreso
-- Si devuelve filas, significa que hay hospitalizaciones donde el alta es anterior o igual al ingreso

select id_hospitalizacion
from {{ ref('stg__hospitalizacion') }}
where fecha_alta <= fecha_ingreso