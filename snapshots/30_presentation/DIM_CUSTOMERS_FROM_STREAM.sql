{% snapshot DIM_CUSTOMERS_STREAM_SCD %}
{{
    config(
        unique_key='C_CUSTKEY',
        strategy='timestamp',
        updated_at='dbt_last_update_ts')
}}
/*
Type 2 Customers dimension based on stream and simulated CDC
 */
SELECT DIM_CUSTOMERS.*,
    IFF(METADATA$ACTION = 'DELETE', 'Y', 'N') AS DELETE_FLAG
FROM {{ snowflake_get_stream( ref('DIM_CUSTOMERS') ) }} DIM_CUSTOMERS

-- We do not want the DELETE rows from the stream for updates
WHERE NOT (METADATA$ACTION = 'DELETE' AND METADATA$ISUPDATE)

-- It is possible the same key was deleted and inserted
-- The following will deduplicate records, keeping the newest record and keeping INSERT over DELETE
qualify 1 = row_number() over (partition by C_CUSTKEY order by dbt_last_update_ts DESC, METADATA$ACTION DESC)

{% endsnapshot %}
