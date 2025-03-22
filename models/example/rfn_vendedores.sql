{{ config(materialized='table') }}

with final as (
    select
        vendedor_id,
        nome,
        departamento,
        email,
        cast(telefone as bigint)  telefone
    from raw_vendedores
)
select *
from final