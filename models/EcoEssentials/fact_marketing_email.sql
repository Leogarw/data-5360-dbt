{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
) }}

SELECT
    m.emaileventid as email_event_key,
    d.date_key,
    pc.promotional_campaign_key,
    cu.customer_key,
    e.email_key,
    ev.event_type_key,
    1 as event_count
FROM {{ source('ecoessentials_marketing', 'marketing_emails') }} m
INNER JOIN {{ ref('eco_dim_customer') }} cu
    ON lower(trim(m.subscriberfirstname)) = lower(trim(cu.customer_first_name))
   AND lower(trim(m.subscriberlastname)) = lower(trim(cu.customer_last_name))
INNER JOIN {{ ref('dim_email') }} e ON m.emailid = e.email_id
INNER JOIN {{ ref('dim_event') }} ev ON m.eventtype = ev.event_type
LEFT JOIN {{ ref('dim_promotional_campaign') }} pc ON m.campaignid = pc.campaign_id
INNER JOIN {{ ref('eco_dim_date') }} d ON d.date_day = m.eventtimestamp::date