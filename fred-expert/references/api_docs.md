# FRED API Documentation Reference

Base URL: `https://api.stlouisfed.org/fred`
API Key: Required via `api_key` parameter.
Format: JSON is supported via `file_type=json`.

## Core Endpoints

### 1. Get Series Info (`/series`)
- **Required**: `series_id` (e.g., `GDP`)
- **Use case**: Get units, frequency, last updated date.

### 2. Get Series Observations (`/series/observations`)
- **Required**: `series_id`
- **Optional**:
  - `observation_start` / `observation_end` (YYYY-MM-DD)
  - `units` (level `lin`, % change `pch`, % change from year ago `pc1`)
  - `frequency` (aggregate to `a`, `q`, `m`, `w`, `d`)
  - `sort_order` (`asc` or `desc`)

### 3. Search Series (`/series/search`)
- **Required**: `search_text`
- **Optional**:
  - `search_type` (`full_text`, `series_id`)
  - `order_by` (`search_rank`, `popularity`, `last_updated`)

## Common Series IDs
- **GDP**: Gross Domestic Product
- **CPIAUCSL**: Consumer Price Index (All Items)
- **UNRATE**: Unemployment Rate
- **FEDFUNDS**: Federal Funds Effective Rate
- **M2SL**: M2 Money Supply
- **TREASURY**: Multiple IDs (e.g., `GS10` for 10-Year Treasury Constant Maturity Rate)
