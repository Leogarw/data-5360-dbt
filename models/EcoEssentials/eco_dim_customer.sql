{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

with transactional as (
    select
        lower(trim(customer_first_name)) as first_key,
        lower(trim(customer_last_name)) as last_key,
        max(customer_id) as customer_id,
        max(customer_first_name) as customer_first_name,
        max(customer_last_name) as customer_last_name,
        max(customer_phone) as customer_phone,
        max(customer_address) as customer_address,
        max(customer_city) as customer_city,
        max(customer_state) as customer_state,
        max(customer_zip) as customer_zip,
        max(customer_country) as customer_country
    from {{ source('ecoessentials_landing', 'CUSTOMER') }}
    group by 1, 2
),

marketing as (
    select
        lower(trim(subscriberfirstname)) as first_key,
        lower(trim(subscriberlastname)) as last_key,
        max(subscriberfirstname) as customer_first_name,
        max(subscriberlastname) as customer_last_name,
        max(subscriberemail) as customer_email
    from {{ source('ecoessentials_marketing', 'marketing_emails') }}
    where subscriberfirstname is not null
      and subscriberlastname is not null
    group by 1, 2
)

select
    md5(coalesce(t.first_key, m.first_key) || '|' || coalesce(t.last_key, m.last_key)) as customer_key,
    t.customer_id,
    coalesce(t.customer_first_name, m.customer_first_name) as customer_first_name,
    coalesce(t.customer_last_name, m.customer_last_name) as customer_last_name,
    t.customer_phone,
    t.customer_address,
    t.customer_city,
    t.customer_state,
    m.customer_email,
    t.customer_zip,
    t.customer_country
from transactional t
full outer join marketing m
    on t.first_key = m.first_key
   and t.last_key = m.last_key