# Finnhub API Reference

This skill integrates with the Finnhub Stock API (https://finnhub.io).

## Core Endpoints

### Stock Data
- **Quote**: `/quote?symbol={symbol}` - Get real-time price, change, etc.
- **News**: `/company-news?symbol={symbol}&from={YYYY-MM-DD}&to={YYYY-MM-DD}` - News for a specific ticker.
- **Financials**: `/stock/metric?symbol={symbol}&metric=all` - Basic financial metrics.

### Markets
- **Market News**: `/news?category=general` - General market news.
- **Earnings Calendar**: `/calendar/earnings?from={YYYY-MM-DD}&to={YYYY-MM-DD}` - Upcoming earnings.

## Rate Limits
- Free Tier: 60 API calls per minute.
- Standard Tier: Varies by plan.

## Authentication
API calls must include the `X-Finnhub-Token` header or `token` query parameter.
The `finnhub_client.py` script expects `FINNHUB_API_KEY` environment variable.
