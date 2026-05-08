with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

renamed as (

    select
        {{ generate_surrogate_key(['numero_chip', 'dni_dueno'])}}       AS id_mascota,
        {{ generate_surrogate_key(['dni_dueno', 'fecha_nacimiento'])}}  AS id_dueno,
        {{ handle_null(clean_string('nombre_mascota')) }}               AS nombre_mascota,
        CASE 
            WHEN UPPER(TRIM(especie)) = 'PAJARO' AND numero_chip IS NULL THEN 'NO PROCEDE'
            WHEN numero_chip IS NULL THEN 'NO'
            ELSE UPPER(TRIM(numero_chip))
        END AS numero_chip,
        {{ generate_surrogate_key(['raza'])}}                           AS id_raza,
        peso_gr::NUMBER(10,2)                                          AS peso_gr, --pasamos a números con decimales por los pájaros
        {{ cast_date('fecha_nacimiento') }}                             AS fecha_nacimiento,
        DATEDIFF('year',{{ cast_date('fecha_nacimiento') }}, CURRENT_DATE())     AS edad,
        {{ cast_boolean ('esterilizado') }}                             AS esterilizado --casteamos booleano para esterilizado
        
    from source

)

select * from renamed