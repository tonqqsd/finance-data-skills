# CoinGecko API Endpoints Reference (Demo Plan)

Base URL: `https://api.coingecko.com/api/v3/`

Authentication: Header `x-cg-demo-api-key: YOUR_API_KEY` or query param `x_cg_demo_api_key=YOUR_API_KEY`

Full docs: https://docs.coingecko.com/v3.0.1/reference/endpoint-overview

---

## Table of Contents

1. [Ping](#ping)
2. [Simple (Prices)](#simple-prices)
3. [Coins](#coins)
4. [Coin Categories](#coin-categories)
5. [NFTs](#nfts)
6. [Exchanges & Derivatives](#exchanges--derivatives)
7. [Public Treasury](#public-treasury)
8. [General (Global, Search, Rates)](#general)
9. [Onchain DEX (GeckoTerminal)](#onchain-dex-geckoterminal)
10. [Supported vs_currencies](#supported-vs_currencies)
11. [Common Query Parameters](#common-query-parameters)

---

## Ping

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/ping` | Check API server status |

```bash
curl -s "https://api.coingecko.com/api/v3/ping" -H "x-cg-demo-api-key: $COINGECKO_API_KEY"
```

---

## Simple (Prices)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/simple/price` | Get price of coins by IDs, names, or symbols |
| GET | `/simple/token_price/{id}` | Get token price by contract address on a platform |
| GET | `/simple/supported_vs_currencies` | List all supported target currencies |

### `/simple/price` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `vs_currencies` | ✅ | Target currencies (comma-separated): `usd,eur,cny,btc` |
| `ids` | One of ids/names/symbols | Coin API IDs (comma-separated): `bitcoin,ethereum` |
| `names` | One of ids/names/symbols | Coin names: `Bitcoin,Ethereum` |
| `symbols` | One of ids/names/symbols | Coin symbols: `btc,eth` |
| `include_market_cap` | ❌ | Include market cap (`true`/`false`) |
| `include_24hr_vol` | ❌ | Include 24h volume |
| `include_24hr_change` | ❌ | Include 24h price change % |
| `include_last_updated_at` | ❌ | Include last update UNIX timestamp |
| `precision` | ❌ | Decimal places (`full`, `0`-`18`) |

Lookup priority: `ids` > `names` > `symbols`

### `/simple/token_price/{id}` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Asset platform ID (e.g. `ethereum`, `polygon-pos`) |
| `contract_addresses` | ✅ | Token contract addresses (comma-separated) |
| `vs_currencies` | ✅ | Target currencies |

---

## Coins

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/coins/list` | List all supported coins (id, symbol, name) |
| GET | `/coins/markets` | List coins with market data (price, mcap, volume) |
| GET | `/coins/{id}` | Get coin details (metadata, links, market data) |
| GET | `/coins/{id}/tickers` | Get trading pairs/tickers for a coin |
| GET | `/coins/{id}/history` | Get historical data (price, mcap, vol) for a date |
| GET | `/coins/{id}/market_chart` | Get price/mcap/volume chart data (time series) |
| GET | `/coins/{id}/market_chart/range` | Get chart data for a UNIX timestamp range |
| GET | `/coins/{id}/ohlc` | Get OHLCV candlestick data |
| GET | `/coins/{id}/contract/{address}` | Get coin data by contract address |
| GET | `/coins/{id}/contract/{address}/market_chart` | Chart data by contract address |
| GET | `/coins/{id}/contract/{address}/market_chart/range` | Chart data by contract (date range) |

### `/coins/markets` Key Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `vs_currency` | ✅ | Target currency (single): `usd` |
| `ids` | ❌ | Filter by coin IDs |
| `names` | ❌ | Filter by coin names |
| `symbols` | ❌ | Filter by coin symbols |
| `category` | ❌ | Filter by category slug |
| `order` | ❌ | Sort: `market_cap_desc`, `volume_desc`, `id_asc`, etc. |
| `per_page` | ❌ | Results per page (1-250, default 100) |
| `page` | ❌ | Page number |
| `sparkline` | ❌ | Include 7d sparkline data |
| `price_change_percentage` | ❌ | Include price change %: `1h,24h,7d,14d,30d,200d,1y` |

### `/coins/{id}` Key Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Coin API ID (e.g. `bitcoin`) |
| `localization` | ❌ | Include translations (default `true`) |
| `tickers` | ❌ | Include tickers (default `true`) |
| `market_data` | ❌ | Include market data (default `true`) |
| `community_data` | ❌ | Include community data (default `true`) |
| `developer_data` | ❌ | Include developer data (default `true`) |
| `sparkline` | ❌ | Include 7d sparkline |

### `/coins/{id}/market_chart` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Coin API ID |
| `vs_currency` | ✅ | Target currency |
| `days` | ✅ | Data up to N days ago (`1`, `7`, `14`, `30`, `90`, `180`, `365`, `max`) |

**Granularity auto-select:**
- 1 day → 5-minute intervals
- 2-90 days → hourly
- >90 days → daily

### `/coins/{id}/market_chart/range` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Coin API ID |
| `vs_currency` | ✅ | Target currency |
| `from` | ✅ | Start UNIX timestamp |
| `to` | ✅ | End UNIX timestamp |

### `/coins/{id}/ohlc` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Coin API ID |
| `vs_currency` | ✅ | Target currency |
| `days` | ✅ | `1`, `7`, `14`, `30`, `90`, `180`, `365`, `max` |

**Candle granularity:**
- 1-2 days → 30-min candles
- 3-30 days → 4-hour candles
- 31+ days → 4-day candles

### `/coins/{id}/history` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{id}` (path) | ✅ | Coin API ID |
| `date` | ✅ | Date in `dd-mm-yyyy` format |
| `localization` | ❌ | Include translations |

---

## Coin Categories

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/coins/categories/list` | List all category IDs and names |
| GET | `/coins/categories` | List categories with market data |

---

## NFTs

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/nfts/list` | List all supported NFTs (id, name, platform) |
| GET | `/nfts/{id}` | Get NFT collection data by ID |
| GET | `/nfts/{asset_platform_id}/contract/{contract_address}` | Get NFT by contract |

---

## Exchanges & Derivatives

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/exchanges` | List exchanges with volume data |
| GET | `/exchanges/list` | List all exchange IDs and names |
| GET | `/exchanges/{id}` | Get exchange details |
| GET | `/exchanges/{id}/tickers` | Get exchange tickers |
| GET | `/exchanges/{id}/volume_chart` | Get exchange volume chart data |
| GET | `/derivatives` | List derivative tickers |
| GET | `/derivatives/exchanges` | List derivative exchanges |
| GET | `/derivatives/exchanges/{id}` | Get derivative exchange details |
| GET | `/derivatives/exchanges/list` | List derivative exchange IDs |

---

## Public Treasury

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/entities/list` | List all entities (companies & governments) with IDs |
| GET | `/{entity}/public_treasury/{coin_id}` | Get crypto treasury holdings by coin (companies or governments) |
| GET | `/public_treasury/{entity_id}` | Get crypto treasury holdings by entity ID |
| GET | `/public_treasury/{entity_id}/{coin_id}/holding_chart` | Historical holdings chart by entity & coin |
| GET | `/public_treasury/{entity_id}/transaction_history` | Treasury transaction history by entity |

### `/entities/list` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `entity_type` | ❌ | Filter: `company` or `government` |
| `per_page` | ❌ | Results per page (1-250, default 100) |
| `page` | ❌ | Page number |

### `/{entity}/public_treasury/{coin_id}` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{entity}` (path) | ✅ | `companies` or `governments` |
| `{coin_id}` (path) | ✅ | Coin ID: `bitcoin`, `ethereum`, etc. |
| `per_page` | ❌ | Results per page (1-250, default 250) |
| `page` | ❌ | Page number |
| `order` | ❌ | `total_holdings_usd_desc` or `total_holdings_usd_asc` |

**Response fields:** `total_holdings`, `total_value_usd`, `market_cap_dominance`, `companies[]` (name, symbol, country, total_holdings, total_entry_value_usd, total_current_value_usd, percentage_of_total_supply)

### `/public_treasury/{entity_id}` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{entity_id}` (path) | ✅ | Entity ID from `/entities/list` |

### `/public_treasury/{entity_id}/{coin_id}/holding_chart` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{entity_id}` (path) | ✅ | Entity ID |
| `{coin_id}` (path) | ✅ | Coin ID |
| `days` | ❌ | Data range in days |

### `/public_treasury/{entity_id}/transaction_history` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `{entity_id}` (path) | ✅ | Entity ID |
| `per_page` | ❌ | Results per page |
| `page` | ❌ | Page number |

---

## General

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/asset_platforms` | List all asset platforms/blockchains |
| GET | `/token_lists/{platform_id}/all.json` | Get token list for a platform |
| GET | `/exchange_rates` | Get BTC-to-other exchange rates |
| GET | `/search` | Search coins, exchanges, categories |
| GET | `/search/trending` | Get trending coins, NFTs, categories (24h) |
| GET | `/global` | Get global crypto market data |
| GET | `/global/decentralized_finance_defi` | Get global DeFi market data |

### `/search` Parameters

| Param | Required | Description |
|-------|----------|-------------|
| `query` | ✅ | Search keyword |

Returns: coins, exchanges, categories matching the query.

### `/global` Response Fields

- `total_market_cap` — Total market cap by currency
- `total_volume` — Total 24h volume by currency
- `market_cap_percentage` — Dominance % (BTC, ETH, etc.)
- `active_cryptocurrencies` — Number of active coins
- `markets` — Number of markets/exchanges

---

## Onchain DEX (GeckoTerminal)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/onchain/simple/networks/{network}/token_price/{addresses}` | Token price by contract on a network |
| GET | `/onchain/networks` | List supported networks |
| GET | `/onchain/networks/{network}/dexes` | List DEXes on a network |
| GET | `/onchain/networks/{network}/pools/{address}` | Get pool data by address |
| GET | `/onchain/networks/{network}/pools/multi/{addresses}` | Get multiple pools |
| GET | `/onchain/networks/trending_pools` | Trending pools across all networks |
| GET | `/onchain/networks/{network}/trending_pools` | Trending pools on a network |
| GET | `/onchain/networks/{network}/pools` | Top pools on a network |
| GET | `/onchain/networks/{network}/dexes/{dex}/pools` | Top pools on a DEX |
| GET | `/onchain/networks/new_pools` | Newly created pools |
| GET | `/onchain/networks/{network}/new_pools` | New pools on a network |
| GET | `/onchain/search/pools` | Search pools by keyword |
| GET | `/onchain/networks/{network}/tokens/{address}/pools` | Top pools for a token |
| GET | `/onchain/networks/{network}/tokens/{address}` | Token data by contract |
| GET | `/onchain/networks/{network}/tokens/multi/{addresses}` | Multiple token data |
| GET | `/onchain/networks/{network}/tokens/{address}/info` | Token info/metadata |
| GET | `/onchain/networks/{network}/pools/{address}/info` | Pool token info |
| GET | `/onchain/tokens/info_recently_updated` | Recently updated token info |
| GET | `/onchain/networks/{network}/pools/{address}/ohlcv/{timeframe}` | Pool OHLCV data |
| GET | `/onchain/networks/{network}/pools/{address}/trades` | Pool trade history |

---

## Supported vs_currencies

Common values for `vs_currencies` / `vs_currency`: `usd`, `eur`, `cny`, `jpy`, `gbp`, `krw`, `btc`, `eth`, `bnb`, `aud`, `cad`, `hkd`, `sgd`, `twd`, `inr`

Get the full list:

```bash
curl -s "https://api.coingecko.com/api/v3/simple/supported_vs_currencies" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .
```

---

## Common Query Parameters

| Param | Type | Used In | Description |
|-------|------|---------|-------------|
| `per_page` | integer | `/coins/markets`, listing endpoints | Results per page (1-250) |
| `page` | integer | Listing endpoints | Page number |
| `order` | string | `/coins/markets` | Sort order: `market_cap_desc`, `volume_desc`, `id_asc` |
| `sparkline` | boolean | `/coins/markets`, `/coins/{id}` | Include 7-day sparkline |
| `localization` | boolean | `/coins/{id}`, `/coins/{id}/history` | Include translations |
| `precision` | string | `/simple/price` | Decimal places for price |

---

## Rate Limits & Best Practices

- **Demo plan**: ~30 calls/min, 10,000 calls/month
- **Cache refresh**: every 60 seconds (Demo), every 20 seconds (Pro)
- Use `/simple/price` with `include_*` flags to reduce total API calls
- Add small delays between batch requests to avoid rate limiting
- Store coin IDs locally; avoid calling `/coins/list` repeatedly
- Use `include_last_updated_at=true` to verify data freshness
