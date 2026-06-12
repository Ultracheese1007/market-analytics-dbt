{% macro pct_change(current_col, previous_col) %}
    safe_divide({{ current_col }} - {{ previous_col }}, {{ previous_col }})
{% endmacro %}
