{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
) }}

SELECT
    ol.order_line_id as sales_key,
    d.date_key,
    pc.promotional_campaign_key,
    p.product_key,
    cu.customer_key,
    ol.order_id,
    ol.quantity,
    ol.discount,
    ol.price_after_discount,
    SUM(ol.quantity * ol.price_after_discount) OVER (PARTITION BY ol.order_id) as order_total
FROM {{ source('ecoessentials_landing', 'ORDER_LINE') }} ol
INNER JOIN {{ source('ecoessentials_landing', 'ORDER') }} o ON ol.order_id = o.order_id
INNER JOIN {{ source('ecoessentials_landing', 'CUSTOMER') }} c ON o.customer_id = c.customer_id
INNER JOIN {{ ref('eco_dim_customer') }} cu
    ON lower(trim(c.customer_first_name)) = lower(trim(cu.customer_first_name))
   AND lower(trim(c.customer_last_name)) = lower(trim(cu.customer_last_name))
INNER JOIN {{ ref('dim_product') }} p ON ol.product_id = p.product_id
LEFT JOIN {{ ref('dim_promotional_campaign') }} pc ON ol.campaign_id = pc.campaign_id
INNER JOIN {{ ref('eco_dim_date') }} d ON d.date_day = o.order_timestamp::date