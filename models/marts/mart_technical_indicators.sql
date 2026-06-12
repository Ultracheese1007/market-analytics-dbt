-- Technical indicators per ticker per day, all via SQL window functions:
-- 20/50-day moving averages, 20-day return volatility, and a 14-day RSI.
with base as (
    select
        *,
        greatest(daily_return, 0)  as gain,
        greatest(-daily_return, 0) as loss
    from {{ ref('int_daily_returns') }}
),

avg_gl as (
    select
        *,
        avg(gain) over (
            partition by ticker order by trade_date
            rows between 13 preceding and current row
        ) as avg_gain_14,
        avg(loss) over (
            partition by ticker order by trade_date
            rows between 13 preceding and current row
        ) as avg_loss_14
    from base
)

select
    price_id,
    ticker,
    trade_date,
    close_price,
    daily_return,
    avg(close_price) over (
        partition by ticker order by trade_date
        rows between 19 preceding and current row
    ) as ma_20,
    avg(close_price) over (
        partition by ticker order by trade_date
        rows between 49 preceding and current row
    ) as ma_50,
    stddev(daily_return) over (
        partition by ticker order by trade_date
        rows between 19 preceding and current row
    ) as volatility_20d,
    case
        when avg_loss_14 = 0 then 100
        else 100 - (100 / (1 + safe_divide(avg_gain_14, avg_loss_14)))
    end as rsi_14
from avg_gl
