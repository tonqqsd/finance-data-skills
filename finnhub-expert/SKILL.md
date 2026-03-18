---
name: finnhub-expert
description: Financial data expert using Finnhub API for stock quotes, market news, and company fundamentals.
---

# Finnhub Expert

This skill allows Gemini CLI to fetch real-time and historical financial data from the Finnhub API.

## When to Use This Skill
Use this skill when the user asks for:
- Real-time stock prices or quotes.
- Company-specific or general market news.
- Financial metrics (P/E ratio, market cap, etc.).
- IPO or earnings calendars.

## Core Workflows

### 1. Fetching Real-time Quotes
To get a stock price, run:
`python scripts/finnhub_client.py quote '{"symbol": "AAPL"}'`

### 2. Fetching Company News
To get recent news, run:
`python scripts/finnhub_client.py company-news '{"symbol": "AAPL", "from": "2024-01-01", "to": "2024-03-01"}'`

### 3. Fetching Basic Financials
To get metrics, run:
`python scripts/finnhub_client.py stock/metric '{"symbol": "AAPL", "metric": "all"}'`

## Prerequisites
- Set the `FINNHUB_API_KEY` environment variable.
- Python `requests` library must be installed.

## API Endpoints Reference
See [references/api_docs.md](references/api_docs.md) for more details.
