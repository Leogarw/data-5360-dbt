{% macro customer_key(first_name, last_name) %}
    md5(lower(trim({{ first_name }})) || '|' || lower(trim({{ last_name }})))
{% endmacro %}