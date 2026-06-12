-- Ticker dimension. Inlined for speed; in a real pipeline this would be a
-- dbt seed (CSV) or a reference table. Edit / extend with your own tickers.
select * from unnest([
    struct('AAPL'  as ticker, 'Apple Inc.'      as company_name, 'Technology'             as sector),
    struct('MSFT'  as ticker, 'Microsoft Corp.' as company_name, 'Technology'             as sector),
    struct('GOOGL' as ticker, 'Alphabet Inc.'   as company_name, 'Communication Services' as sector),
    struct('AMZN'  as ticker, 'Amazon.com Inc.' as company_name, 'Consumer Discretionary' as sector),
    struct('NVDA'  as ticker, 'NVIDIA Corp.'    as company_name, 'Technology'             as sector),
    struct('META'  as ticker, 'Meta Platforms'  as company_name, 'Communication Services' as sector),
    struct('TSLA'  as ticker, 'Tesla Inc.'      as company_name, 'Consumer Discretionary' as sector)
])
