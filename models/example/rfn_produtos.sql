{{ config(materialized='table') }}

with final as (
    select
        produto_id,
        nome,
        categoria,
        descricao,
        cast(preco as double) preco
    from raw_produtos
)
select *
from final