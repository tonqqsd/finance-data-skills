---
name: fred-expert
description: Get macroeconomic data from FRED (Federal Reserve Economic Data). Use when the user asks for US economic indicators like GDP, inflation (CPI), unemployment rate, or interest rates.
---

# FRED Expert

Provide access to Federal Reserve Economic Data (FRED).

## Prerequisites
- **FRED_API_KEY**: Must be set in environment variables.

## Workflows

### 1. Search for Data Series
When you don't know the exact `series_id`, search using keywords.
```bash
python scripts/fred_client.py series/search '{"search_text": "unemployment rate"}'
```

### 2. Get Series Info
Retrieve metadata (units, frequency) for a specific ID.
```bash
python scripts/fred_client.py series '{"series_id": "UNRATE"}'
```

### 3. Get Observations
Fetch actual data points for a series.
```bash
# Fetch recent observations (last 1000 by default)
python scripts/fred_client.py series/observations '{"series_id": "UNRATE"}'

# Fetch with date range and descending order
python scripts/fred_client.py series/observations '{"series_id": "GDP", "observation_start": "2020-01-01", "sort_order": "desc"}'
```

## References
For a complete list of parameters and common series IDs, see [references/api_docs.md](references/api_docs.md).
