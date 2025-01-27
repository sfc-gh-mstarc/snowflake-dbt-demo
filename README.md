### dbt for Snowflake Demonstration Project

### This project depends on the following two data sets
- SNOWFLAKE_SAMPLE_DATA that is available by default in all new Snowflake accounts
- [Knoema: Economy Data Atlas](https://www.snowflake.com/datasets/knoema-economy-data-atlas/)
    - It is available for free in the Snowflake Data Markeplace
    - If named other than "KNOEMA_ECONOMY_DATA_ATLAS", update the database name in sources.yml

### How to get started:
- Create a target schema in Snowflake that you want to deploy your dbt demo into
- Add the Knoema Economy Data Atlas and Snowflake Sample Data to your account if necessary
- Copy the sample profiles.yml file to your ~/.dbt/ folder and update it with your credentials and target DB/schema
- Install dbt into python.
    - The recommended approach is to use [Anaconda](https://www.anaconda.com/) or [Miniconda](https://docs.conda.io/en/latest/miniconda.html) and create an isolated environment just for dbt. A dbt-conda-env.yml file has been provided so you can set up this environment and switch to it with:
    ```
    conda env create -f dbt-conda-env.yml
    conda activate dbt
    ```
    - Alternately you could use the following to install/update dbt using pip:
    ```
    pip install -U dbt-core dbt-snowflake
    ```
- From the root folder, run `dbt deps` to download modules from the dbt hub
- Run `dbt build --full-refresh` and troubleshoot any errors such as missing objects or permission issues

### Cheatsheet of most common dbt commands:
- `dbt deps` - download 3rd party packages (necessary for this project before build)
- `dbt build` - both compile and then run all models & associated tests
- `dbt build --full-refresh` - have incremental models run as a full reload
- `dbt build --models modelname` - will only compile/run modelname
- `dbt build --models +modelname` - will compile/run modelname and all parents
- `dbt build --models modelname+` - will compile/run modelname and all children
- `dbt build --models +modelname+` - will compile/run modelname, and all parents and children
- `dbt build --models @modelname` - will compile/run modelname, all parents, all children, AND all parents of all children
- `dbt build --exclude modelname` - will compile/run all models except modelname
- `dbt compile` - compile all models but do not execute them
- `dbt run` - run all models & tests
- `dbt seed` - create or refresh small tables from .csv seed files
- `dbt clean` - clear your logs and compiled scripts (can fix issues)
- `dbt docs generate` - refresh the documentation for your project
- `dbt docs serve` - open this documentation in your browser

Additional commands and details are available in [dbt's documentation](https://docs.getdbt.com/reference/dbt-commands)

### Project features:
- How to nest models:
    - DIM_ORDERS
    - DIM_CURRENT_YEAR_ORDERS
    - DIM_CURRENT_YEAR_OPEN_ORDERS
- Snowflake commands in a pre-hook:
    - DIM_CALENDAR_DAY
- Materializations:
    - LKP_EXCHANGE_RATES (table)
    - LKP_CUSTOMERS_WITH_ORDERS (ephemeral)
    - DIM_CUSTOMERS_SHARE (secure view)
    - FACT_ORDER_LINE (incremental)
    - DIM_CUSTOMERS_TYPE2 (snapshot)
- Source data quality tests:
    - sources.yml
- Model data quality tests:
    - schema.yml
- Features available in dbt_project.yml
    - run-start/run-end hooks
    - logging before and after modules
    - default materializations by folder path
    - Snowflake features - copy_grants, secure views, warehouse
    - schemas for models
- Macro examples:
    - snowflake_surrogate_key
    - copy_log_to_snowflake
    - create_masking_policies
- Jinja expressions:
    - Q1_FACT_PRICING_SUMMARY_REPORT_QUERY
    - Q2_MINIMUM_COST_SUPPLIER_QUERY
    - Q3_SHIPPING_PRIORITY_QUERY
    - Q4_ORDER_PRIORITY_CHECKING_QUERY


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Free [on-demand training](https://courses.getdbt.com/)
- [Additional Packages](https://hub.getdbt.com/)
- Create PK, UK, and FK in Snowflake using [dbt Constraints](https://github.com/Snowflake-Labs/dbt_constraints)
- Snowflake Guide - [Accelerating Data Teams with dbt Core & Snowflake](https://quickstarts.snowflake.com/guide/data_teams_with_dbt_core/index.html)
- Snowflake Guide - [Accelerating Data Teams with dbt Cloud & Snowflake](https://quickstarts.snowflake.com/guide/data_teams_with_dbt_cloud/index.html)
- Snowflake Guide - [Data Engineering with Apache Airflow, Snowflake & dbt](https://quickstarts.snowflake.com/guide/data_engineering_with_apache_airflow/index.html)
