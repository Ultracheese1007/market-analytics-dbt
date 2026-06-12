-- Cleaned, typed, renamed 1:1 view over the raw price table.
with source as (
    select * from {{ source('market_raw', 'prices') }}
)

select
    concat(ticker, '-', cast(date as string)) as price_id,   -- surrogate key
    ticker,
    cast(date as date)         as trade_date,
    cast(open as float64)      as open_price,
    cast(high as float64)      as high_price,
    cast(low as float64)       as low_price,
    cast(close as float64)     as close_price,
    cast(adj_close as float64) as adj_close_price,
    cast(volume as int64)      as volume
from source
