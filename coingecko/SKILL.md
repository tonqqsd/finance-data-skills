---
name: coingecko
description: "Fetch cryptocurrency market data via CoinGecko API: prices, market caps, trading volumes, trends, historical charts, exchange info, NFT data, derivatives, public treasury (company/government crypto holdings), DeFi stats, onchain DEX pools, and global crypto stats. Use when: (1) checking crypto prices (BTC, ETH, etc.), (2) getting market rankings or trending coins, (3) querying historical price data or OHLCV charts, (4) looking up exchange, NFT, or derivatives info, (5) getting global crypto/DeFi market overview, (6) checking public company/government crypto treasury holdings. NOT for: real-time trading/order execution, on-chain transaction queries, or wallet balance lookups. Requires: curl and a CoinGecko API key (free Demo plan available)."
homepage: https://docs.coingecko.com/
metadata: { "openclaw": { "emoji": "🪙", "requires": { "bins": ["curl"] } } }
---

# CoinGecko Crypto Data Skill

Query cryptocurrency market data from CoinGecko's public API (Demo plan).

## Setup

1. Get a free Demo API key at https://www.coingecko.com/en/api/pricing
2. Store the key in an environment variable:

```bash
export COINGECKO_API_KEY="YOUR_API_KEY"
```

All commands below use `$COINGECKO_API_KEY`. The Demo API base URL is:

```
https://api.coingecko.com/api/v3/
```

Authentication is via the `x-cg-demo-api-key` header.

## API Reference

For full endpoint details, parameter lists, and response schemas, see [references/api_endpoints.md](references/api_endpoints.md).

## Quick Commands

### Get Current Price

```bash
# Single coin price in USD
curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .

# Multiple coins, multiple currencies, with market cap & 24h change
curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana&vs_currencies=usd,cny&include_market_cap=true&include_24hr_change=true" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .
```

### Get Price by Contract Address

```bash
# Token price by contract on Ethereum
curl -s "https://api.coingecko.com/api/v3/simple/token_price/ethereum?contract_addresses=0xdac17f958d2ee523a2206206994597c13d831ec7&vs_currencies=usd" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .
```

### Market Rankings (Top Coins)

```bash
# Top 10 coins by market cap
curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[] | {name, current_price, market_cap, price_change_percentage_24h}'
```

### Trending Coins

```bash
# Top trending searches in last 24h
curl -s "https://api.coingecko.com/api/v3/search/trending" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.coins[] | {name: .item.name, symbol: .item.symbol, market_cap_rank: .item.market_cap_rank}'
```

### Coin Details

```bash
# Full details for a coin (metadata, links, market data)
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&community_data=false&developer_data=false" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{name, symbol, market_cap_rank, market_data: {current_price: .market_data.current_price.usd, market_cap: .market_data.market_cap.usd, total_volume: .market_data.total_volume.usd, ath: .market_data.ath.usd, price_change_24h: .market_data.price_change_percentage_24h}}'
```

### Historical Price Chart

```bash
# Price chart for last 30 days (daily granularity)
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=30" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{prices: [.prices[-5:][] | {timestamp: (.[0]/1000 | todate), price: .[1]}]}'
```

### OHLCV (Candlestick) Data

```bash
# OHLCV data for last 14 days
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/ohlc?vs_currency=usd&days=14" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[-5:][] | {timestamp: (.[0]/1000 | todate), open: .[1], high: .[2], low: .[3], close: .[4]}'
```

### Search Coins

```bash
# Search for a coin by keyword
curl -s "https://api.coingecko.com/api/v3/search?query=solana" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.coins[:5][] | {id, name, symbol, market_cap_rank}'
```

### Global Market Data

```bash
# Global crypto market overview
curl -s "https://api.coingecko.com/api/v3/global" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.data | {total_market_cap_usd: .total_market_cap.usd, total_volume_usd: .total_volume.usd, btc_dominance: .market_cap_percentage.btc, active_cryptocurrencies, markets}'
```

### Exchange Rates (BTC-based)

```bash
# All exchange rates relative to BTC
curl -s "https://api.coingecko.com/api/v3/exchange_rates" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.rates | {usd, cny, eur, jpy}'
```

### Public Treasury (Company/Government Holdings)

```bash
# List entities (companies & governments) holding crypto
curl -s "https://api.coingecko.com/api/v3/entities/list" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[:10][] | {id, name, symbol, country}'

# Companies holding Bitcoin
curl -s "https://api.coingecko.com/api/v3/companies/public_treasury/bitcoin" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{total_holdings, total_value_usd, market_cap_dominance, top_holders: [.companies[:5][] | {name, total_holdings, total_current_value_usd}]}'

# Governments holding Bitcoin
curl -s "https://api.coingecko.com/api/v3/governments/public_treasury/bitcoin" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{total_holdings, total_value_usd, top_holders: [.companies[:5][] | {name, country, total_holdings}]}'

# Specific entity holdings
curl -s "https://api.coingecko.com/api/v3/public_treasury/mara-holdings" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .

# Entity transaction history
curl -s "https://api.coingecko.com/api/v3/public_treasury/mara-holdings/transaction_history" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[:5]'
```

### Coin Tickers (Trading Pairs)

```bash
# Trading pairs for Bitcoin across exchanges
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/tickers" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.tickers[:5][] | {exchange: .market.name, base, target, last_price: .last, volume: .volume, spread: .bid_ask_spread_percentage}'

# Filter by specific exchange
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/tickers?exchange_ids=binance" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.tickers[] | {base, target, last_price: .last, volume: .volume}'
```

### Historical Data by Date

```bash
# Coin data on a specific date (dd-mm-yyyy)
curl -s "https://api.coingecko.com/api/v3/coins/bitcoin/history?date=01-01-2024&localization=false" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{name, symbol, price_usd: .market_data.current_price.usd, market_cap_usd: .market_data.market_cap.usd}'
```

### Global DeFi Data

```bash
# Global DeFi market stats
curl -s "https://api.coingecko.com/api/v3/global/decentralized_finance_defi" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.data | {defi_market_cap, eth_market_cap, defi_to_eth_ratio, defi_dominance, top_coin_name, top_coin_defi_dominance}'
```

### Derivatives

```bash
# Derivative tickers
curl -s "https://api.coingecko.com/api/v3/derivatives" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[:5][] | {market, symbol, price, index, basis, spread, open_interest}'

# Derivative exchanges
curl -s "https://api.coingecko.com/api/v3/derivatives/exchanges" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[:5][] | {name, open_interest_btc, trade_volume_24h_btc, number_of_perpetual_pairs, number_of_futures_pairs}'
```

### NFT Collections

```bash
# Get NFT collection details
curl -s "https://api.coingecko.com/api/v3/nfts/pudgy-penguins" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{name, symbol, floor_price, market_cap, volume_24h, number_of_unique_addresses, total_supply}'
```

### Asset Platforms & Token Lists

```bash
# List all blockchain platforms
curl -s "https://api.coingecko.com/api/v3/asset_platforms" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[:10][] | {id, name, chain_identifier, native_coin_id}'

# Token list for a platform
curl -s "https://api.coingecko.com/api/v3/token_lists/ethereum/all.json" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '{name, tokens: [.tokens[:5][] | {name, symbol, address}]}'
```

### Onchain DEX (GeckoTerminal)

```bash
# Trending pools across all networks
curl -s "https://api.coingecko.com/api/v3/onchain/networks/trending_pools" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.data[:5][] | {name: .attributes.name, network: .relationships.network.data.id, volume_24h: .attributes.volume_usd.h24}'

# Search pools
curl -s "https://api.coingecko.com/api/v3/onchain/search/pools?query=PEPE" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.data[:5][] | {name: .attributes.name, price_usd: .attributes.base_token_price_usd}'

# Token price on a network
curl -s "https://api.coingecko.com/api/v3/onchain/simple/networks/eth/token_price/0xdac17f958d2ee523a2206206994597c13d831ec7" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq .
```

## Finding Coin IDs

CoinGecko uses unique API IDs (e.g. `bitcoin`, `ethereum`, `solana`). To find the correct ID:

```bash
# List all coins with IDs
curl -s "https://api.coingecko.com/api/v3/coins/list" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.[] | select(.symbol == "btc" or .symbol == "eth")'

# Or search by keyword
curl -s "https://api.coingecko.com/api/v3/search?query=chainlink" \
  -H "x-cg-demo-api-key: $COINGECKO_API_KEY" | jq '.coins[:3]'
```

## Using the Helper Script

For formatted output and common queries, use the bundled script:

```bash
# Get price
scripts/coingecko.sh price bitcoin ethereum solana

# Get market rankings (top N)
scripts/coingecko.sh top 20

# Get trending coins
scripts/coingecko.sh trending

# Get coin details
scripts/coingecko.sh info bitcoin

# Get global market stats
scripts/coingecko.sh global

# Get global DeFi stats
scripts/coingecko.sh defi

# Search for a coin
scripts/coingecko.sh search "solana"

# Get price history (chart data)
scripts/coingecko.sh chart bitcoin 30

# Get categories
scripts/coingecko.sh categories

# Get coin trading pairs/tickers
scripts/coingecko.sh tickers bitcoin

# Get coin data on a specific date
scripts/coingecko.sh history bitcoin 01-01-2024

# Public treasury — companies holding BTC
scripts/coingecko.sh treasury bitcoin

# Treasury entities list
scripts/coingecko.sh entities

# Derivative tickers
scripts/coingecko.sh derivatives

# NFT collection info
scripts/coingecko.sh nft pudgy-penguins

# Blockchain platforms
scripts/coingecko.sh platforms

# Onchain DEX trending pools
scripts/coingecko.sh dex-trending
```

## Rate Limits

- Demo API: ~30 calls/min, 10,000 calls/month
- Cache refresh: every 60 seconds
- Avoid rapid-fire requests; add delays between batch queries
- Use `include_*` flags on `/simple/price` to reduce calls

## Notes

- Coin IDs are lowercase slugs (e.g. `bitcoin`, `ethereum`, `binancecoin`)
- Use `/simple/price` with `ids` param for most price queries (most efficient)
- `vs_currencies` supports: usd, eur, cny, jpy, gbp, krw, btc, eth, etc.
- For token prices on specific chains, use `/simple/token_price/{platform_id}`
- Historical chart granularity depends on `days` param: 1 day = 5-min, 2-90 days = hourly, >90 days = daily
- Response data may be cached; use `include_last_updated_at=true` to check freshness
