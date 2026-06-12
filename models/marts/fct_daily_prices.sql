{{ config(materialized='table') }}

with returns as (
    select * from {{ ref('int_daily_returns') }}
)

select
    price_id,
    ticker,
    trade_date,
    close_price,
    prev_close_price,
    daily_return,
    volume
from returns