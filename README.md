# Fundamentals Database with SimFin and MySQL

A MySQL database that unifies company fundamentals, share prices, and company profile data into a single, query-ready structure for financial analysis — built as a MySQL-native alternative to scraping Yahoo Finance.

Full write-up (with all SQL): https://aaron-san.github.io/indicators/

## What this is

Raw accounting data alone doesn't tell you much. This project takes raw fundamentals (balance sheet, income statement, cash flow) and share price data, loads them into MySQL, and computes a full suite of financial ratios — profitability, liquidity, solvency, efficiency, and valuation — directly in SQL. The result is one relational database you can query for screening, backtesting, or ad hoc ratio analysis, instead of reconciling multiple CSV exports or fighting API rate limits.

## Data sources

- **Fundamentals & company profiles**: [SimFin](https://www.simfin.com/en/fundamental-data-download/) (free account required), delivered as CSVs and loaded into MySQL tables.
- **Share prices**: daily prices, aggregated into monthly prices for backtesting use cases.

## Database structure

**Raw tables** (loaded directly from SimFin CSVs, see [`sql/raw`](./sql/raw))

| Table | Contents |
|---|---|
| `us_companies` | Company profile data (ticker, name, industry, sector, employees, business summary) |
| `industries` | Sector / industry classification, joined via `IndustryId` |
| `us_balance_annual` / `_quarterly` / `_ttm` | Balance sheet data |
| `us_income_annual` / `_quarterly` / `_ttm` | Income statement data |
| `us_cashflow_annual` / `_quarterly` / `_ttm` | Cash flow statement data |
| `us_shareprices_daily` | Raw daily share prices |

**Derived tables** (built in-notebook or via [`sql/derived`](./sql/derived))

| Table | Contents |
|---|---|
| `us_shareprices_daily_filtered` | Daily prices with tickers removed where `Close`/`AdjClose` exceeded $100,000 (data errors) |
| `us_shareprices_monthly` | Monthly share prices, aggregated from daily |
| `us_shareprices_monthly_returns` | Month-over-month returns from the monthly price series |
| `us_shareprices_stats` | Running max, drawdown, 3/6/12-month moving averages, and trailing 3-year annualized volatility |
| `dates_lookup` | Maps each fundamentals report date to the next market/month-end price date, to avoid look-ahead bias |
| `metrics_misc` | Effective tax rate, market cap, total debt, free cash flow, enterprise value |
| `metrics_growth` | Year-over-year growth rates for key income/balance/cash flow line items |
| `metrics_profitability_annual` / `_quarterly` | Gross margin, operating margin, profit margin, ROA, ROE, ROIC, EBIT/EV |
| `metrics_activity` | Efficiency / turnover ratios |
| `metrics_value` | PE, PS, PB |
| `metrics_liquidity` | Cash ratio, quick ratio, current ratio |
| `metrics_solvency` | Debt-to-equity, debt ratio, interest coverage |
| `metrics_earnings_quality` | Earnings quality, FCF margin, FCF conversion |

## Key engineering decisions

- **No look-ahead bias**: fundamentals are matched to the first share price date *after* the report's publish date (not the report date itself), so any backtest built on this data reflects information actually available at the time.
- **Outlier filtering**: daily prices with a `Close` or `AdjClose` above $100,000 were identified as data errors and excluded before ratio calculations, since no ratio should be distorted by a $99,999,999.99 "close."
- **Messy source data cleanup**: the SimFin company list arrived with rows split unpredictably across cells; this was normalized in Excel via `CONCAT()` + Text-to-Columns before loading into MySQL.

## Getting started

1. Download fundamentals and share price data from [SimFin](https://www.simfin.com/en/fundamental-data-download/) (free account).
2. Set up a MySQL database and create `secrets.json` in the project root with `{"secrets": ["username", "password", "host", "database_name"]}`.
3. Run the table-load scripts (see [`load_data.html`](https://aaron-san.github.io/indicators/load_data.html) for the full loading SQL).
4. Run the derived-table SQL (price statistics, dates lookup, growth, profitability, efficiency, valuation, liquidity, solvency, cash flow quality) to populate the `metrics_*` and other derived tables.
5. Query directly, or pull into Python via `pymysql`, `pandas`, and `sqlalchemy` for further analysis.

### Requirements

- MySQL
- Python 3.x with `pandas`, `sqlalchemy`, `pymysql`

## Further ideas

- Automate raw data acquisition via SimFin's native API (download, unzip, cleanup).
- Improve outlier handling beyond the current price filter.

## Author

Aaron Hardy, CFA, CAIA