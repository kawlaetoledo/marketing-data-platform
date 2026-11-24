import csv
import random
from datetime import date, timedelta
from pathlib import Path

random.seed(42)
OUT = Path("data/raw/ads_performance.csv")
OUT.parent.mkdir(parents=True, exist_ok=True)

campaigns = {
    "meta_ads": ["prospecting_br", "retargeting_br", "black_friday"],
    "google_ads": ["search_brand", "search_generic", "pmax_shopping"],
}
start = date(2026, 9, 1)
rows = []
for d in range(90):
    day = start + timedelta(days=d)
    for platform, names in campaigns.items():
        for name in names:
            impressions = random.randint(5_000, 80_000)
            clicks = int(impressions * random.uniform(0.005, 0.04))
            spend = round(clicks * random.uniform(0.4, 2.5), 2)
            conversions = int(clicks * random.uniform(0.01, 0.08))
            revenue = round(conversions * random.uniform(80, 400), 2)
            rows.append([day.isoformat(), platform, name, impressions,
                         clicks, spend, conversions, revenue])

with OUT.open("w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["date", "platform", "campaign", "impressions",
                "clicks", "spend", "conversions", "revenue"])
    w.writerows(rows)
print(f"{len(rows)} rows written to {OUT}")
