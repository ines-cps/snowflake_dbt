{{ config(materialized='table') }}

with final as (
  select
    cliente_id,
    nome,
    email,
    cast(telefone as bigint) as telefone,
    cidade,
    estado,
    {{ convert_date('nascimento_dt') }} as nascimento_dt
  from raw_clientes
)

select *
from final