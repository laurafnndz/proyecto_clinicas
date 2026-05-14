{{ config(materialized='table') }}

SELECT
    -- FKs naturales
    f.id_factura,
    f.id_consulta,

    -- FKs a dimensiones
    f.id_metodo_pago,
    c.id_mascota,
    c.id_empleado,
    c.id_centro,
    CAST(f.fecha_emision AS DATE)                              AS id_fecha,

    -- Métricas propias
    f.total,

    -- Flags y métricas de contexto
    CASE WHEN h.id_hospitalizacion IS NOT NULL
         THEN TRUE ELSE FALSE END                             AS fue_hospitalizado,
    COALESCE(med.num_medicamentos, 0)                        AS num_medicamentos,
    COALESCE(pru.num_pruebas, 0)                             AS num_pruebas

FROM {{ ref('slv__factura') }} f
LEFT JOIN {{ ref('slv__consulta') }} c
    ON f.id_consulta = c.id_consulta
LEFT JOIN {{ ref('slv__hospitalizacion') }} h
    ON f.id_consulta = h.id_consulta
LEFT JOIN (
    SELECT id_consulta, COUNT(*) AS num_medicamentos
    FROM {{ ref('slv__consulta_medicamento') }}
    GROUP BY id_consulta
) med ON f.id_consulta = med.id_consulta
LEFT JOIN (
    SELECT id_consulta, COUNT(*) AS num_pruebas
    FROM {{ ref('slv__consulta_prueba') }}
    GROUP BY id_consulta
) pru ON f.id_consulta = pru.id_consulta