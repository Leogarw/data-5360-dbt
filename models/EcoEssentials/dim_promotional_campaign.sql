{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
campaign_id as promotional_campaign_key,
campaign_id,
campaign_name,
campaign_discount
FROM {{ source('ecoessentials_landing', 'PROMOTIONAL_CAMPAIGN') }}