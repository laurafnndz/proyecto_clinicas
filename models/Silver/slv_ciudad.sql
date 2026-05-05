SELECT DISTINCT
    MD5(CAST(COALESCE(ciudad_centro, cp_centro) AS VARCHAR)) AS id_ciudad,
    LOWER(TRIM(COALESCE(ciudad_centro, cp_centro)))          AS nombre_ciudad,
    LOWER(TRIM(COALESCE(ciudad_centro, cp_centro)))          AS municipio,
    'granada'                                                AS provincia,
    'andalucia'                                              AS comunidad_autonoma,
    'espana'                                                 AS pais

FROM {{ ref('stg_raw_clinicas__consultas') }}