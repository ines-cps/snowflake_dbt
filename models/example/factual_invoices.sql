{{ config(materialized='table') }}

with final as (
SELECT 
    current_timestamp as refresh_dt,
    p.produto_id, 
    p.nome AS produto_nome, 
    p.categoria AS produto_categoria, 
    CAST(p.preco AS DECIMAL(10,2)) AS preco_unitario, 
    v.vendedor_id, 
    v.nome AS vendedor_nome, 
    v.departamento AS vendedor_departamento, 
    c.cliente_id, 
    c.nome AS cliente_nome, 
    c.cidade AS cliente_cidade, 
    c.estado AS cliente_estado, 

    -- Medida 1: Define a quantidade baseada na categoria do produto 
    CASE 
      WHEN p.categoria = 'Móveis' THEN 1 
      WHEN p.categoria = 'Eletrônicos' AND  p.nome = 'Smartphone Y' THEN 2 
      ELSE 1 
    END AS qtde, 

    -- Medida 2: Preço total = qtde * preço unitário 
    (
    		CASE 
    			WHEN p.categoria = 'Móveis' THEN 1 
    			WHEN p.categoria = 'Eletrônicos' AND  p.nome = 'Smartphone Y'
    			THEN 2 
    			ELSE 1 
    		END) * p.preco AS preco_total, 
    
    FROM {{ref('rfn_produtos')}} p 
    CROSS  JOIN {{ref('rfn_vendedores')}} v 
    CROSS JOIN {{ref('rfn_clientes')}} c
)

select *
from final

