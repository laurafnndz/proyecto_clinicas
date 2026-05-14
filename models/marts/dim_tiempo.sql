{{ config(materialized='table') }}

with fechas as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2023-01-01' as date)",
        end_date="cast('2036-12-31' as date)"
    ) }}
)

select
    date_day                                            as id_fecha,
    extract(year from date_day)                         as anio,
    extract(month from date_day)                        as mes,
    extract(day from date_day)                          as dia,
    extract(quarter from date_day)                      as trimestre,
    dayname(date_day)                                   as nombre_dia,
    monthname(date_day)                                 as nombre_mes,
    case when dayofweek(date_day) in (1, 7)
         then true else false end                       as es_fin_de_semana
from fechas