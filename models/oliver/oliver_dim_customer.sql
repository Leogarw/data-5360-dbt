{{config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

select
customer_id as customer_key,
customer_id,
first_name,
last_name,
state,
phone_number,
email
FROM {{ source('Oliver_landing', 'customer') }}
