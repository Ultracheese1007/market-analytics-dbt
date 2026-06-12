-- Adds previous close (LAG window fn) and daily return per ticker.
with prices as (
    select * from {{ ref('stg_prices') }}
),

with_prev as (
    select
        price_id,
        ticker,
        trade_date,
        close_price,
        volume,
        lag(close_price) over (
            partition by ticker order by trade_date
        ) as prev_close_price
    from prices
)

select
    price_id,
    ticker,
    trade_date,
    close_price,
    volume,
    prev_close_price,
    {{ pct_change('close_price', 'prev_close_price') }} as daily_return
from with_prev
