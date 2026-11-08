{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT DISTINCT
emailid as email_key,
emailid as email_id,
emailname as email_name
FROM {{ source('ecoessentials_marketing', 'marketing_emails') }}