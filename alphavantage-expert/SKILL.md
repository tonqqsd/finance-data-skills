---
name: alphavantage-expert
description: Get financial market data from Alpha Vantage. Use when you need stock quotes, intraday/daily historical prices, technical indicators, fundamental data (income statements, balance sheets, cash flow), or economic indicators (GDP, inflation).
---

# Alpha Vantage Expert

Provide comprehensive access to global financial market data including equities, currencies, commodities, and economic indicators.

## Prerequisites
- **ALPHA_VANTAGE_API_KEY**: Must be set in environment variables.

## Workflows

### 1. Get Stock Quotes & Time Series
Fetch the latest price or historical daily data for a ticker.
```bash
# Get the latest quote (current price, volume, etc.)
python scripts/alphavantage_client.py '{"function": "GLOBAL_QUOTE", "symbol": "IBM"}'

# Get daily historical data (last 100 points)
python scripts/alphavantage_client.py '{"function": "TIME_SERIES_DAILY", "symbol": "IBM"}'
```

### 2. Get Fundamental Data
Access financial statements for a specific company.
```bash
# Get company profile and key metrics
python scripts/alphavantage_client.py '{"function": "COMPANY_OVERVIEW", "symbol": "IBM"}'

# Get annual and quarterly income statements
python scripts/alphavantage_client.py '{"function": "INCOME_STATEMENT", "symbol": "IBM"}'
```

### 3. Get Economic Indicators
Fetch macroeconomic data like GDP, Inflation (CPI), or Unemployment.
```bash
# Get Real GDP data
python scripts/alphavantage_client.py '{"function": "REAL_GDP", "interval": "annual"}'

# Get Unemployment rate data
python scripts/alphavantage_client.py '{"function": "UNEMPLOYMENT"}'
```

### 4. Search for Symbols
Find the best matching symbols for a company name or keyword.
```bash
python scripts/alphavantage_client.py '{"function": "SYMBOL_SEARCH", "keywords": "tesla"}'
```

## References
For a complete list of functions (including technical indicators and commodities), see [references/api_docs.md](references/api_docs.md).
