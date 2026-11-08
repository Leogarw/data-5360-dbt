{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
product_id as product_key,
product_id,
product_type,
product_name,
price
FROM {{ source('ecoessentials_landing', 'PRODUCT') }}