#!/usr/bin/env bash
# coingecko.sh — CoinGecko API helper for common crypto data queries
# Usage: coingecko.sh <command> [args...]
#
# Commands:
#   price <coin_id...>          Get current prices in USD
#   top [N]                     Top N coins by market cap (default 10)
#   trending                    Trending coins in last 24h
#   info <coin_id>              Detailed coin information
#   global                      Global crypto market overview
#   defi                        Global DeFi market stats
#   search <query>              Search for coins by keyword
#   chart <coin_id> [days]      Price history chart data (default 7 days)
#   categories                  List coin categories
#   tickers <coin_id>           Coin trading pairs across exchanges
#   history <coin_id> <date>    Historical data by date (dd-mm-yyyy)
#   exchanges [N]               Top N exchanges (default 10)
#   rates                       BTC exchange rates
#   treasury <coin_id>          Company/government crypto treasury holdings
#   entities                    List entities holding crypto
#   derivatives                 Derivative tickers
#   nft <nft_id>                NFT collection details
#   platforms                   List blockchain platforms
#   dex-trending                Trending DEX pools (GeckoTerminal)
#
# Environment:
#   COINGECKO_API_KEY           Required. Your CoinGecko Demo API key.

set -euo pipefail

BASE_URL="https://api.coingecko.com/api/v3"
API_KEY="${COINGECKO_API_KEY:-}"

if [[ -z "$API_KEY" ]]; then
  echo "Error: COINGECKO_API_KEY environment variable is not set." >&2
  echo "Get a free key at https://www.coingecko.com/en/api/pricing" >&2
  exit 1
fi

# Check for jq
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed." >&2
  exit 1
fi

api_get() {
  local endpoint="$1"
  shift
  local url="${BASE_URL}${endpoint}"
  # Append query params
  if [[ $# -gt 0 ]]; then
    local params="$1"
    if [[ "$url" == *"?"* ]]; then
      url="${url}&${params}"
    else
      url="${url}?${params}"
    fi
  fi
  curl -sf "$url" -H "x-cg-demo-api-key: $API_KEY"
}

cmd_price() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh price <coin_id...>" >&2
    echo "Example: coingecko.sh price bitcoin ethereum solana" >&2
    exit 1
  fi
  local ids
  ids=$(IFS=,; echo "$*")
  api_get "/simple/price" "ids=${ids}&vs_currencies=usd,cny&include_market_cap=true&include_24hr_change=true&include_last_updated_at=true" | jq '
    to_entries[] | {
      coin: .key,
      price_usd: .value.usd,
      price_cny: .value.cny,
      market_cap_usd: .value.usd_market_cap,
      change_24h: (.value.usd_24h_change | if . then (. * 100 | round / 100 | tostring) + "%" else "N/A" end),
      updated: (.value.last_updated_at | todate)
    }
  '
}

cmd_top() {
  local n="${1:-10}"
  api_get "/coins/markets" "vs_currency=usd&order=market_cap_desc&per_page=${n}&page=1&sparkline=false&price_change_percentage=24h,7d" | jq '
    .[] | {
      rank: .market_cap_rank,
      name,
      symbol: (.symbol | ascii_upcase),
      price: .current_price,
      market_cap: .market_cap,
      volume_24h: .total_volume,
      change_24h: (if .price_change_percentage_24h then (.price_change_percentage_24h * 100 | round / 100 | tostring) + "%" else "N/A" end),
      change_7d: (if .price_change_percentage_24h_in_currency then (.price_change_percentage_24h_in_currency * 100 | round / 100 | tostring) + "%" else "N/A" end)
    }
  '
}

cmd_trending() {
  api_get "/search/trending" | jq '
    .coins[] | {
      rank: .item.market_cap_rank,
      name: .item.name,
      symbol: .item.symbol,
      price_btc: .item.price_btc,
      score: .item.score
    }
  '
}

cmd_info() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh info <coin_id>" >&2
    echo "Example: coingecko.sh info bitcoin" >&2
    exit 1
  fi
  local coin_id="$1"
  api_get "/coins/${coin_id}" "localization=false&tickers=false&community_data=false&developer_data=false" | jq '{
    name,
    symbol: (.symbol | ascii_upcase),
    rank: .market_cap_rank,
    categories,
    homepage: .links.homepage[0],
    blockchain_site: .links.blockchain_site[0],
    price_usd: .market_data.current_price.usd,
    price_cny: .market_data.current_price.cny,
    market_cap_usd: .market_data.market_cap.usd,
    total_volume_usd: .market_data.total_volume.usd,
    ath_usd: .market_data.ath.usd,
    ath_date: .market_data.ath_date.usd,
    atl_usd: .market_data.atl.usd,
    atl_date: .market_data.atl_date.usd,
    circulating_supply: .market_data.circulating_supply,
    total_supply: .market_data.total_supply,
    max_supply: .market_data.max_supply,
    change_24h: (((.market_data.price_change_percentage_24h // 0) * 100 | round / 100 | tostring) + "%"),
    change_7d: (((.market_data.price_change_percentage_7d // 0) * 100 | round / 100 | tostring) + "%"),
    change_30d: (((.market_data.price_change_percentage_30d // 0) * 100 | round / 100 | tostring) + "%"),
    last_updated: .market_data.last_updated
  }'
}

cmd_global() {
  api_get "/global" | jq '.data | {
    total_market_cap_usd: .total_market_cap.usd,
    total_volume_24h_usd: .total_volume.usd,
    btc_dominance: ((.market_cap_percentage.btc * 100 | round / 100 | tostring) + "%"),
    eth_dominance: ((.market_cap_percentage.eth * 100 | round / 100 | tostring) + "%"),
    active_cryptocurrencies,
    markets,
    market_cap_change_24h: ((.market_cap_change_percentage_24h_usd * 100 | round / 100 | tostring) + "%"),
    updated_at: (.updated_at | todate)
  }'
}

cmd_search() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh search <query>" >&2
    echo "Example: coingecko.sh search solana" >&2
    exit 1
  fi
  local query
  query=$(printf '%s' "$*" | jq -sRr @uri)
  api_get "/search" "query=${query}" | jq '
    .coins[:10][] | {
      id,
      name,
      symbol: (.symbol | ascii_upcase),
      market_cap_rank
    }
  '
}

cmd_chart() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh chart <coin_id> [days]" >&2
    echo "Example: coingecko.sh chart bitcoin 30" >&2
    exit 1
  fi
  local coin_id="$1"
  local days="${2:-7}"
  api_get "/coins/${coin_id}/market_chart" "vs_currency=usd&days=${days}" | jq '{
    coin: "'"${coin_id}"'",
    days: '"${days}"',
    data_points: (.prices | length),
    latest_price: (.prices[-1][1]),
    min_price: ([.prices[][1]] | min),
    max_price: ([.prices[][1]] | max),
    recent_5: [.prices[-5:][] | {
      time: (.[0] / 1000 | todate),
      price: .[1]
    }]
  }'
}

cmd_categories() {
  api_get "/coins/categories" | jq '
    .[:20][] | {
      name,
      market_cap: .market_cap,
      market_cap_change_24h: (if .market_cap_change_24h then (.market_cap_change_24h * 100 | round / 100 | tostring) + "%" else "N/A" end),
      volume_24h: .volume_24h,
      top_3_coins: [.top_3_coins[:3][]]
    }
  '
}

cmd_exchanges() {
  local n="${1:-10}"
  api_get "/exchanges" "per_page=${n}&page=1" | jq '
    .[] | {
      rank: .trust_score_rank,
      name,
      country,
      year_established,
      trade_volume_24h_btc: .trade_volume_24h_btc,
      url: .url
    }
  '
}

cmd_rates() {
  api_get "/exchange_rates" | jq '.rates | to_entries | map(select(.key == "usd" or .key == "eur" or .key == "cny" or .key == "jpy" or .key == "gbp" or .key == "krw" or .key == "eth")) | from_entries | to_entries[] | {
    currency: .key,
    name: .value.name,
    value_per_btc: .value.value,
    type: .value.type
  }'
}

cmd_defi() {
  api_get "/global/decentralized_finance_defi" | jq '.data | {
    defi_market_cap,
    eth_market_cap,
    defi_to_eth_ratio,
    defi_dominance,
    top_coin_name,
    top_coin_defi_dominance,
    trading_volume_24h
  }'
}

cmd_tickers() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh tickers <coin_id> [exchange_id]" >&2
    echo "Example: coingecko.sh tickers bitcoin binance" >&2
    exit 1
  fi
  local coin_id="$1"
  local params=""
  if [[ $# -gt 1 ]]; then
    params="exchange_ids=$2"
  fi
  api_get "/coins/${coin_id}/tickers" "$params" | jq '
    .tickers[:10][] | {
      exchange: .market.name,
      base,
      target,
      last_price: .last,
      volume: .volume,
      spread: .bid_ask_spread_percentage,
      trade_url: .trade_url
    }
  '
}

cmd_history() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: coingecko.sh history <coin_id> <date>" >&2
    echo "Date format: dd-mm-yyyy" >&2
    echo "Example: coingecko.sh history bitcoin 01-01-2024" >&2
    exit 1
  fi
  local coin_id="$1"
  local date="$2"
  api_get "/coins/${coin_id}/history" "date=${date}&localization=false" | jq '{
    name,
    symbol: (.symbol | ascii_upcase),
    date: "'"${date}"'",
    price_usd: .market_data.current_price.usd,
    price_cny: .market_data.current_price.cny,
    market_cap_usd: .market_data.market_cap.usd,
    total_volume_usd: .market_data.total_volume.usd
  }'
}

cmd_treasury() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh treasury <coin_id> [companies|governments]" >&2
    echo "Example: coingecko.sh treasury bitcoin" >&2
    echo "Example: coingecko.sh treasury bitcoin governments" >&2
    exit 1
  fi
  local coin_id="$1"
  local entity="${2:-companies}"
  api_get "/${entity}/public_treasury/${coin_id}" | jq '{
    total_holdings,
    total_value_usd,
    market_cap_dominance,
    holders: [.companies[:10][] | {
      name,
      symbol,
      country,
      total_holdings,
      total_current_value_usd,
      percentage_of_total_supply
    }]
  }'
}

cmd_entities() {
  local entity_type="${1:-}"
  local params="per_page=50"
  if [[ -n "$entity_type" ]]; then
    params="${params}&entity_type=${entity_type}"
  fi
  api_get "/entities/list" "$params" | jq '.[] | {
    id,
    name,
    symbol,
    country
  }'
}

cmd_derivatives() {
  api_get "/derivatives" | jq '
    .[:10][] | {
      market,
      symbol,
      price,
      index,
      basis,
      spread,
      funding_rate,
      open_interest,
      volume_24h: .volume_24h
    }
  '
}

cmd_nft() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: coingecko.sh nft <nft_id>" >&2
    echo "Example: coingecko.sh nft pudgy-penguins" >&2
    exit 1
  fi
  local nft_id="$1"
  api_get "/nfts/${nft_id}" | jq '{
    name,
    symbol,
    asset_platform_id,
    contract_address,
    floor_price,
    market_cap,
    volume_24h,
    number_of_unique_addresses,
    total_supply
  }'
}

cmd_platforms() {
  api_get "/asset_platforms" | jq '.[] | select(.id != null and .name != null) | {
    id,
    name,
    chain_identifier,
    native_coin_id
  }'
}

cmd_dex_trending() {
  api_get "/onchain/networks/trending_pools" | jq '
    .data[:10][] | {
      name: .attributes.name,
      network: .relationships.network.data.id,
      price_usd: .attributes.base_token_price_usd,
      volume_24h: .attributes.volume_usd.h24,
      price_change_24h: .attributes.price_change_percentage.h24,
      transactions_24h: .attributes.transactions.h24
    }
  '
}

cmd_help() {
  cat <<'HELP'
CoinGecko CLI — Crypto market data from CoinGecko API

Commands:
  price <coin_id...>          Current prices (USD & CNY) with 24h change
  top [N]                     Top N coins by market cap (default: 10)
  trending                    Trending searches in last 24 hours
  info <coin_id>              Detailed coin info (price, supply, ATH, etc.)
  global                      Global crypto market overview
  defi                        Global DeFi market stats
  search <query>              Search coins by keyword
  chart <coin_id> [days]      Price chart data (default: 7 days)
  categories                  Top coin categories with market data
  tickers <coin_id> [exchange] Coin trading pairs/tickers
  history <coin_id> <date>    Historical data by date (dd-mm-yyyy)
  exchanges [N]               Top N exchanges (default: 10)
  rates                       BTC exchange rates to major currencies
  treasury <coin_id> [type]   Company/gov crypto treasury holdings
  entities [type]             List entities holding crypto
  derivatives                 Derivative tickers
  nft <nft_id>                NFT collection details
  platforms                   List blockchain platforms
  dex-trending                Trending DEX pools (GeckoTerminal)
  help                        Show this help message

Examples:
  coingecko.sh price bitcoin ethereum
  coingecko.sh top 20
  coingecko.sh info solana
  coingecko.sh chart ethereum 30
  coingecko.sh search "polygon"
  coingecko.sh treasury bitcoin
  coingecko.sh treasury bitcoin governments
  coingecko.sh tickers bitcoin binance
  coingecko.sh history bitcoin 01-01-2024
  coingecko.sh derivatives
  coingecko.sh nft pudgy-penguins
  coingecko.sh dex-trending

Environment:
  COINGECKO_API_KEY       Required. Get free at https://www.coingecko.com/en/api/pricing
HELP
}

# Main dispatch
case "${1:-help}" in
  price)        shift; cmd_price "$@" ;;
  top)          shift; cmd_top "$@" ;;
  trending)     shift; cmd_trending "$@" ;;
  info)         shift; cmd_info "$@" ;;
  global)       shift; cmd_global "$@" ;;
  defi)         shift; cmd_defi "$@" ;;
  search)       shift; cmd_search "$@" ;;
  chart)        shift; cmd_chart "$@" ;;
  categories)   shift; cmd_categories "$@" ;;
  tickers)      shift; cmd_tickers "$@" ;;
  history)      shift; cmd_history "$@" ;;
  exchanges)    shift; cmd_exchanges "$@" ;;
  rates)        shift; cmd_rates "$@" ;;
  treasury)     shift; cmd_treasury "$@" ;;
  entities)     shift; cmd_entities "$@" ;;
  derivatives)  shift; cmd_derivatives "$@" ;;
  nft)          shift; cmd_nft "$@" ;;
  platforms)    shift; cmd_platforms "$@" ;;
  dex-trending) shift; cmd_dex_trending "$@" ;;
  help|--help|-h) cmd_help ;;
  *)
    echo "Unknown command: $1" >&2
    echo "Run 'coingecko.sh help' for usage." >&2
    exit 1
    ;;
esac

