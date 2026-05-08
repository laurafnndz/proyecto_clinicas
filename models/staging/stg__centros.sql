    with 
    source as (
        select * from {{ source('raw_clinicas', 'consultas') }}
    ),
    ciudades as (
        select * from {{ ref('stg__ciudad') }}
    ),


    renamed as (
        select distinct
            {{ dbt_utils.generate_surrogate_key(['cv.nombre_centro', 'cv.cp_centro']) }} as id_centro,
            cv.nombre_centro,
            c.id_ciudad,
            cv.direccion_centro,
            cv.cp_centro,
            cv.telefono_centro
        from source cv
        left join ciudades c
            on UPPER(cv.ciudad_centro) = c.ciudad --hacemos join con stg__ciudad ya que no tengo los campos necesarios en la tabla origen para hacer la id_ciudad
    )                                              --UPPER para que ambos resultados sean en mayusculas y no nos de el problema de nulls
    select * from renamed 