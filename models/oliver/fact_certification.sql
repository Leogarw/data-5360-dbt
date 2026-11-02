{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
)}}

select
    d.date_key,
    e.employee_key,
    c.certification_name,
    c.certification_cost
from {{ ref('oliver_stg_customer_service_interactions') }} c
left join {{ ref('oliver_dim_employee') }} e
    on c.employee_id = e.employee_id
left join {{ ref('oliver_dim_date') }} d
    on c.certification_awarded_date = d.date_id