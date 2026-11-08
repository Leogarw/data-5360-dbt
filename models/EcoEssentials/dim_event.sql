{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
row_number() over (order by event_type) as event_type_key,
event_type
FROM (
    SELECT DISTINCT eventtype as event_type
    FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}
)