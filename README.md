
# 🏥 Proyecto Clínicas Veterinarias: Data Engineering Pipeline

![Estado](https://img.shields.io/badge/Estado-Terminado-success)
![Fivetran](https://img.shields.io/badge/Ingesta-Fivetran-blue?logo=fivetran&logoColor=white)
![Snowflake](https://img.shields.io/badge/Data_Warehouse-Snowflake-29B5E8?logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/Transformación-dbt-FF694B?logo=dbt&logoColor=white)
![SQL](https://img.shields.io/badge/Lenguaje-SQL-00758F?logo=postgresql&logoColor=white)
![PowerBI](https://img.shields.io/badge/Visualización-Power_BI-F2C811?logo=powerbi&logoColor=black)
![Architecture](https://img.shields.io/badge/Arquitectura-Medallion-orange)

Este repositorio contiene un pipeline de datos *End-to-End* diseñado para centralizar y analizar la información operativa de una red de clínicas veterinarias. El objetivo principal es consolidar datos provenientes de bases de datos transaccionales, transformarlos mediante el Modern Data Stack y exponerlos en un esquema analítico robusto  listo para el consumo en herramientas de Business Intelligence.

## 🎯 Contexto y Valor de Negocio

La gestión de múltiples centros veterinarios genera información valiosa pero fragmentada sobre pacientes (mascotas), clientes (dueños), facturación y carga clínica. Este proyecto centraliza y estandariza estos datos para resolver preguntas estratégicas como:

* **Rendimiento Financiero:** ¿Cuál es el volumen de facturación y el ticket medio por centro, empleado o método de pago?
* **Salud y Carga Clínica:** ¿Qué porcentaje de mascotas sufre de sobrepeso u otras anomalías según su especie, raza y etapa vital? ¿Cuál es la tasa de reingreso en hospitalizaciones?
* **Operaciones:** ¿Cómo se distribuyen los motivos de consulta, y qué impacto tienen en el uso de medicamentos y pruebas diagnósticas?

---

## 🚀 Stack Tecnológico
* 👌🏼** Ingesta de datos: Fivetran
* ❄️ **Almacenamiento (Data Warehouse):** Snowflake.
* 🔄 **Transformación y Modelado:** dbt (Data Build Tool).
* 📊 **Visualización y BI:** Power BI (mediante modelos tabulares y DAX).
* 🛡️ **Control de Calidad:** Tests genéricos y Unit Tests nativos de dbt.

---

## 📐 Arquitectura del Pipeline (Medallion)

El proyecto sigue una arquitectura Medallion estrictamente gobernada, separando la transformación en capas lógicas:

1. 🥉 **Capa Bronze (RAW):** Ingesta automática de las fuentes transaccionales (tablas consultas,  duenos,empleados, hospitalizaciones en el esquema bronze_clinicas a traves del uso de Fivetran.
2. 🥈 **Capa Silver (Staging):** Limpieza intensiva de los datos. Normalización de cadenas, aplanamiento de arrays, manejo centralizado de nulos (`SIN DATO`), cruce con semillas estáticas (*Seeds*) y generación de *Surrogate Keys* deterministas mediante Macros personalizadas.
3. 🥇 **Capa Gold (Marts / Core):** Modelado dimensional orientado a analítica. Dimensiones con control de historial (SCD Tipo 2 y Tipo 3) y Tablas de Hechos incrementales que optimizan el coste de computación en Snowflake.

---

## 📂 Estructura del Repositorio

proyecto_clinicas/
├── macros/                 # Lógica SQL reutilizable (DRY)
│   ├── cast_boolean.sql    # Estandarización de flags lógicos
│   ├── clean_string.sql    # Limpieza de nulos y espacios
│   └── generate_surrogate_key.sql # SK deterministas eliminando tildes
├── models/                 
│   ├── staging/            # 🥈 Capa SILVER (Vistas y tablas incrementales)
│   │   ├── __models_stg.yml # Definición, Unit Tests y tags PII
│   │   └── stg__*.sql
│   └── marts/              # 🥇 Capa GOLD (Esquema en Estrella)
│       ├── dim_*.sql       # Dimensiones (SCD2, SCD3, catálogos)
│       └── fct_*.sql       # Tablas de Hechos (Facturación, Hospitalizaciones...)
├── seeds/                  # Fuentes de la verdad estáticas
│   └── rango_peso_raza.csv # Rangos biométricos de referencia
├── snapshots/              # Captura de historial (Slowly Changing Dimensions)
│   └── snp_*.sql           # Estrategias 'check' y 'timestamp'
└── tests/                  # Pruebas singulares de negocio
    └── fecha_alta_posterior_ingreso.sql

---

## ⚙️ Transformación y Modelado de Datos

### 🥇 Modelado en la capa Gold

El Data Warehouse final está modelado para optimizar el cruce de eventos y el análisis temporal:

* **Tablas de Hechos (`fct_`):** * `fct_facturacion`: Métricas económicas agregadas por consulta, materializada de forma **incremental**.
    * `fct_historial_clinico`: Eventos clínicos cruzados con las tablas biométricas para determinar estados de salud (ej: "SOBREPESO", "Cachorro").
    * `fct_hospitalizacion`: Registro de ingresos, con métricas complejas calculadas mediante *Window Functions* para detectar reingresos y días de estancia.
* **Dimensiones (`dim_`):**
    * Dimensiones conformadas (Tiempo, Centros, Motivos).
    * Uso de `date_spine` del paquete `dbt_utils` para generar una dimensión de tiempo exhaustiva (`dim_tiempo`).

---

## 🧠 Retos Técnicos y Soluciones Avanzadas

Durante el desarrollo de este pipeline, se resolvieron problemas analíticos de alta complejidad:

* **Aplanamiento de Datos Semi-estructurados:** Los campos de pruebas y medicamentos provenían anidados o separados por tuberías (`|`) en un único string. **Solución:** Uso de la función `LATERAL FLATTEN` y `SPLIT()` de Snowflake en la capa Staging para crear tablas puente funcionales (`stg__consulta_medicamento`).
* **Control Histórico Híbrido (SCD2 y SCD3):** * Para `dim_mascota` y `dim_empleado`, se implementó **SCD Tipo 2** mediante snapshots, permitiendo ver quién era el veterinario responsable en la fecha exacta de una consulta pasada.
    * Para `dim_dueno`, se optó por un **SCD Tipo 3** en la capa Gold, aplanando los datos para mostrar `_actual` y `_anterior` (ej: `telefono_actual`, `telefono_anterior`), facilitando el contacto comercial inmediato.
* **Generación de Surrogate Keys Resilientes:** Los sistemas de origen presentaban inconsistencias tipográficas (con o sin tilde). **Solución:** Una macro personalizada (`generate_surrogate_key.sql`) que normaliza el texto aplicando `TRANSLATE` (Á→A, É→E...) antes de aplicar el hash criptográfico, evitando la duplicación accidental de entidades.
* **Validación Biométrica Asimétrica:** Se necesitaba alertar sobre el peso de los animales en consulta. **Solución:** Uso de dbt Seeds (`rango_peso_raza.csv`) cruzado dinámicamente con la edad exacta de la mascota (`etapa_vital`) en la tabla de hechos clínica para categorizar el peso con precisión forense.

---

## 🛡️ Calidad y Gobierno del Dato (Enterprise-Grade)

* **Data Testing y Unit Tests:** Además de los tests genéricos (`not_null`, `unique`), el proyecto incluye **Unit Tests nativos de dbt**. Por ejemplo, se inyectan datos simulados (Mocking) en `__models_stg.yml` para garantizar que la lógica de negocio devuelve "NO PROCEDE" al buscar el chip de un pájaro o el número de colegiado de un puesto administrativo.
* **Enmascaramiento y PII (RGPD):** Todos los campos sensibles (DNI, Salarios, Direcciones, Teléfonos) están etiquetados explícitamente en el YAML con `tags: ['pii']` y `meta: {pii: true}`, lo que permite integraciones directas con políticas de enmascaramiento dinámico de roles en Snowflake.
* **Testing Funcional (Singular Tests):** Consultas SQL estrictas en la carpeta `tests/` que bloquean el pipeline si ocurre un imposible físico (ej: `fecha_alta_posterior_ingreso.sql` o un empleado con más de un rol simultáneo en `un_puesto_por_empleado.sql`).

---

## 🏃‍♂️ Configuración y Despliegue

### Prerrequisitos
El proyecto utiliza librerías externas que deben estar declaradas en tu entorno. Instala los paquetes dependientes (`dbt_utils`, `codegen`, `dbt_expectations`, `dbt_date`) mediante:

dbt deps

### Orquestación
La ejecución en un entorno productivo seguiría este orden secuencial lógico:

# 1. Cargar las semillas (Catálogos estáticos como los rangos de peso)
dbt seed

# 2. Capturar los cambios históricos (SCD2/SCD3)
dbt snapshot

# 3. Ejecutar transformaciones (Construir tablas e incrementalmente los hechos)
dbt run

# 4. Pasar la batería completa de calidad de datos
dbt test

---

## 📩 Contacto

https://www.linkedin.com/in/laurafnndzrdrgz/   🥸
