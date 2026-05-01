with 

source as (

    select * from {{ source('raw_clinicas', 'consultas') }}

),

renamed as (

    select
        id_consulta,
        fecha_consulta,
        nombre_mascota,
        especie,
        numero_chip,
        raza,
        peso_gr,
        fecha_nacimiento,
        esterilizado,
        vacuna_pendiente,
        motivo_consulta,
        dni_dueno,
        veterinario,
        numero_colegiado,
        medicamentos,
        pruebas,
        resultado_prueba,
        id_factura,
        fecha_emision,
        total,
        metodo_pago,
        nombre_centro,
        direccion_centro,
        cp_centro,
        telefono_centro,
        ciudad_centro

    from source

)

select * from renamed