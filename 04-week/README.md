# Module 4: Analytics Engineering

Goal: Transforming the data loaded in DWH into Analytical Views developing a [dbt project](taxi_rides_ny/README.md).

### Prerequisites

The prerequisites depend on which setup path you choose:

**For Cloud Setup (BigQuery):**

- Completed [Module 3: Data Warehouse](../03-data-warehouse/) with:
  - A GCP project with BigQuery enabled
  - Service account with BigQuery permissions
  - NYC taxi data loaded into BigQuery (yellow and green taxi data for 2019-2020)

**For Local Setup (DuckDB):**

- No prerequisites! The local setup guide will walk you through downloading and loading the data.

> [!NOTE]
> This module focuses on **yellow and green taxi data** (2019-2020). While Module 3 may have included FHV data, it is not used in this dbt project.

## Setting up your environment

Choose your setup path:

### 🏠 [Local Setup](setup/local_setup.md)

- **Stack**: DuckDB + dbt Core
- **Cost**: Free
- [→ Get Started](setup/local_setup.md)

### ☁️ [Cloud Setup](setup/cloud_setup.md)

- **Stack**: BigQuery + dbt Cloud
- **Cost**: Free tier available (dbt Cloud Developer), BigQuery costs vary
- **Requires**: Completed Module 3 with BigQuery data
- [→ Get Started](setup/cloud_setup.md)

## Content

### Introduction to Analytics Engineering

[![](https://markdown-videos-api.jorgenkh.no/youtube/HxMIsPrIyGQ)](https://www.youtube.com/watch?v=HxMIsPrIyGQ)

### Introduction to data modeling

[![](https://markdown-videos-api.jorgenkh.no/youtube/uF76d5EmdtU)](https://www.youtube.com/watch?v=uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=40)

### What is dbt?

[![](https://markdown-videos-api.jorgenkh.no/youtube/gsKuETFJr54)](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=5)

### Differences between dbt Core and dbt Cloud

[![](https://markdown-videos-api.jorgenkh.no/youtube/auzcdLRyEIk)](https://www.youtube.com/watch?v=auzcdLRyEIk)

### Project Setup

| Alternative A                                                                                                   | Alternative B                                                                                                   |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| BigQuery + dbt Platform                                                                                         | DuckDB + dbt core                                                                                               |
| [![](https://markdown-videos-api.jorgenkh.no/youtube/GFbwlrt6f54)](https://www.youtube.com/watch?v=GFbwlrt6f54) | [![](https://markdown-videos-api.jorgenkh.no/youtube/GoFAbJYfvlw)](https://www.youtube.com/watch?v=GoFAbJYfvlw) |

### dbt Course

| dbt Project Structure                                                                                           | dbt Sources                                                                                                     | dbt Models                                                                                                      | Seeds and Macros                                                                                                |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [![](https://markdown-videos-api.jorgenkh.no/youtube/2dYDS4OQbT0)](https://www.youtube.com/watch?v=2dYDS4OQbT0) | [![](https://markdown-videos-api.jorgenkh.no/youtube/7CrrXazV_8k)](https://www.youtube.com/watch?v=7CrrXazV_8k) | [![](https://markdown-videos-api.jorgenkh.no/youtube/JQYz-8sl1aQ)](https://www.youtube.com/watch?v=JQYz-8sl1aQ) | [![](https://markdown-videos-api.jorgenkh.no/youtube/lT4fmTDEqVk)](https://www.youtube.com/watch?v=lT4fmTDEqVk) |

| dbt Tests                                                                                                       | Documentation                                                                                                   | dbt Packages                                                                                                    | dbt Commands                                                                                                    |
| --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| [![](https://markdown-videos-api.jorgenkh.no/youtube/bvZ-rJm7uMU)](https://www.youtube.com/watch?v=bvZ-rJm7uMU) | [![](https://markdown-videos-api.jorgenkh.no/youtube/UqoWyMjcqrA)](https://www.youtube.com/watch?v=UqoWyMjcqrA) | [![](https://markdown-videos-api.jorgenkh.no/youtube/KfhUA9Kfp8Y)](https://www.youtube.com/watch?v=KfhUA9Kfp8Y) | [![](https://markdown-videos-api.jorgenkh.no/youtube/t4OeWHW3SsA)](https://www.youtube.com/watch?v=t4OeWHW3SsA) |

## Troubleshooting

- [DuckDB Troubleshooting Guide](setup/duckdb_troubleshooting.md) — If you're getting OOM errors during `dbt build` with DuckDB

## Extra resources

> [!NOTE]
> If you find the videos above overwhelming, we recommend completing the [dbt Fundamentals](https://learn.getdbt.com/courses/dbt-fundamentals) course and then rewatching the module. It provides a solid foundation for all the key concepts you need in this module.

## SQL refresher

The homework for this module focuses heavily on window functions and CTEs. If you need a refresher on these topics, you can refer to these notes.

- [SQL refresher](refreshers/SQL.md)

## Homework

- [2026 Homework](../cohorts/2026/04-analytics-engineering/homework.md)

# Community notes

<details>
