-- Data-quality check: a single-day return beyond ±50% almost always means
-- a bad source row (e.g. an unadjusted split). The test FAILS if any rows return.
select
    price_id,
    ticker,
    trade_date,
    daily_return
from {{ ref('int_daily_returns') }}
where abs(daily_return) > 0.5
