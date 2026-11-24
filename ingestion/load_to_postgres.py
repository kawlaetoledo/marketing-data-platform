import os
import pandas as pd
from sqlalchemy import create_engine, text

DB_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg://admin:admin@localhost:5432/marketing",
)
CSV_PATH = "data/raw/ads_performance.csv"

engine = create_engine(DB_URL)
df = pd.read_csv(CSV_PATH, parse_dates=["date"])

with engine.begin() as conn:
    conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

df.to_sql("ads_performance", engine, schema="raw",
          if_exists="replace", index=False)

with engine.connect() as conn:
    total = conn.execute(
        text("SELECT COUNT(*) FROM raw.ads_performance")).scalar()
print(f"Loaded {total} rows into raw.ads_performance")
