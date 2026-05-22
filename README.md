# Finance Data Skills for OpenClaw

一组 OpenClaw 金融数据技能，覆盖美股/宏观/加密三类常见查询场景。

包含 4 个技能：

- `finnhub-expert`：股票实时行情、公司新闻、基础财务指标
- `fred-expert`：FRED 宏观经济数据，如 GDP、CPI、失业率、利率
- `alphavantage-expert`：Alpha Vantage 市场数据、技术指标、基本面、经济指标
- `coingecko`：加密货币价格、榜单、趋势、历史图表、DeFi、NFT、交易所与链上 DEX 数据

## 目录结构

```text
.
├── alphavantage-expert/
├── finnhub-expert/
├── fred-expert/
└── coingecko/
```

每个技能目录都保留了标准的 OpenClaw skill 结构，例如：

- `SKILL.md`：技能说明与触发描述
- `scripts/`：调用 API 的辅助脚本
- `references/`：接口说明或补充文档
- `assets/`：预留资源目录（部分技能为空）

## 适用场景

### 1) Finnhub
适合查询：
- 股票实时价格
- 公司相关新闻
- 基础财务指标
- IPO / earnings calendar 等市场事件

示例：

```bash
python scripts/finnhub_client.py quote '{"symbol": "AAPL"}'
python scripts/finnhub_client.py company-news '{"symbol": "AAPL", "from": "2024-01-01", "to": "2024-03-01"}'
python scripts/finnhub_client.py stock/metric '{"symbol": "AAPL", "metric": "all"}'
```

环境变量：

```bash
export FINNHUB_API_KEY="your_key"
```

---

### 2) FRED
适合查询：
- GDP
- CPI / 通胀
- 失业率
- 利率等美国宏观指标

示例：

```bash
python scripts/fred_client.py series/search '{"search_text": "unemployment rate"}'
python scripts/fred_client.py series '{"series_id": "UNRATE"}'
python scripts/fred_client.py series/observations '{"series_id": "GDP", "observation_start": "2020-01-01"}'
```

环境变量：

```bash
export FRED_API_KEY="your_key"
```

---

### 3) Alpha Vantage
适合查询：
- 股票报价与历史价格
- 技术指标
- 公司基本面
- 宏观经济指标

示例：

```bash
python scripts/alphavantage_client.py '{"function": "GLOBAL_QUOTE", "symbol": "IBM"}'
python scripts/alphavantage_client.py '{"function": "TIME_SERIES_DAILY", "symbol": "IBM"}'
python scripts/alphavantage_client.py '{"function": "COMPANY_OVERVIEW", "symbol": "IBM"}'
```

环境变量：

```bash
export ALPHA_VANTAGE_API_KEY="your_key"
```

---

### 4) CoinGecko
适合查询：
- 币价与市值排行
- 热门币种与趋势榜
- 历史图表 / K 线相关数据
- DeFi、NFT、交易所、Public Treasury
- GeckoTerminal 链上 DEX 热门池

示例：

```bash
scripts/coingecko.sh price bitcoin ethereum
scripts/coingecko.sh top 20
scripts/coingecko.sh trending
scripts/coingecko.sh info bitcoin
scripts/coingecko.sh dex-trending
```

环境变量：

```bash
export COINGECKO_API_KEY="your_key"
```

额外依赖：

- `curl`
- `jq`

## 安装方式

可以直接把对应目录放到本地 OpenClaw skills 目录中使用，例如：

```bash
~/.openclaw/skills/
```

如需继续发布成 `.skill` 包，可再按 OpenClaw 的打包流程处理。

## 注意事项

- 这些技能主要是“数据查询 / 数据拉取”能力，不包含交易执行。
- 使用前请先配置各自 API Key。
- 不同数据源有各自的限频规则，批量调用时建议控制节奏。
- `coingecko` 当前依赖 Demo API key，适合轻量查询与原型验证。
