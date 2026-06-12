"""Ingest daily OHLCV data from Yahoo Finance into the BigQuery raw layer.

Prereqs:
  pip install -r requirements.txt
  gcloud auth application-default login   # same creds dbt uses
  # create the dataset once (BigQuery console or CLI):
  #   bq --location=US mk --dataset YOUR_GCP_PROJECT_ID:market_raw
"""
import pandas as pd
import pandas_gbq
import yfinance as yf

PROJECT_ID = "market-analytics-dbt"   # <-- edit
RAW_TABLE = "market_raw.prices"      # dataset.table
TICKERS = ["AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA"]
START = "2023-01-01"


def fetch() -> pd.DataFrame:
    frames = []
    for t in TICKERS:
        df = yf.download(t, start=START, auto_adjust=False, progress=False)
        if df.empty:
            print(f"  ! no data for {t}, skipping")
            continue
        df = df.reset_index()
        # yfinance can return MultiIndex columns; flatten to the first level
        df.columns = [c[0] if isinstance(c, tuple) else c for c in df.columns]
        df = df.rename(columns={
            "Date": "date", "Open": "open", "High": "high", "Low": "low",
            "Close": "close", "Adj Close": "adj_close", "Volume": "volume",
        })
        df["ticker"] = t
        frames.append(df[["date", "ticker", "open", "high", "low",
                          "close", "adj_close", "volume"]])
    return pd.concat(frames, ignore_index=True)


def main() -> None:
    data = fetch()
    data["date"] = pd.to_datetime(data["date"]).dt.date
    print(f"Fetched {len(data)} rows across {data['ticker'].nunique()} tickers")
    pandas_gbq.to_gbq(
        data, RAW_TABLE, project_id=PROJECT_ID, if_exists="replace",
    )
    print(f"Loaded -> {PROJECT_ID}.{RAW_TABLE}")


if __name__ == "__main__":
    main()
