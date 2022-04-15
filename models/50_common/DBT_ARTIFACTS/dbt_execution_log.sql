{{ config(materialized = 'view') }}

SELECT DBT_MANIFEST_NODES.NODE_ID
     ,  DBT_MANIFEST_NODES.NODE_JSON:package_name::string as PACKAGE_NAME
     ,  DBT_MANIFEST_NODES.RESOURCE_TYPE
     ,  DBT_MANIFEST_NODES.NODE_DATABASE
     ,  DBT_MANIFEST_NODES.NODE_SCHEMA
     ,  DBT_MANIFEST_NODES.NAME
     ,  DBT_MANIFEST_NODES.COMMAND_INVOCATION_ID
     ,  DBT_MANIFEST_NODES.DBT_CLOUD_RUN_ID
     ,  DBT_MANIFEST_NODES.ARTIFACT_GENERATED_AT MANIFEST_GENERATED_AT
     ,  DBT_MANIFEST_NODES.NODE_JSON:depends_on:nodes as DEPENDS_ON_NODES
     ,  DBT_MANIFEST_NODES.NODE_JSON:path::string as NODE_PATH
     ,  DBT_MANIFEST_NODES.NODE_JSON:config.materialized::string as MATERIALIZATION
     ,  DBT_MANIFEST_NODES.NODE_JSON:meta as META
     ,  DBT_MANIFEST_NODES.NODE_JSON
     ,  DBT_RUN_RESULTS_NODES.ARTIFACT_GENERATED_AT RUN_RESULTS_GENERATED_AT
     ,  DBT_RUN_RESULTS_NODES.WAS_FULL_REFRESH
     ,  DBT_RUN_RESULTS_NODES.STATUS
     ,  DBT_RUN_RESULTS_NODES.COMPILE_STARTED_AT
     ,  DBT_RUN_RESULTS_NODES.QUERY_COMPLETED_AT
     ,  DBT_RUN_RESULTS_NODES.TOTAL_NODE_RUNTIME
     ,  DBT_RUN_RESULTS_NODES.RESULT_JSON:failures::int as failures
     ,  DBT_RUN_RESULTS_NODES.RESULT_JSON
     ,  DBT_RUN_RESULTS.ENV AS RUN_ENV
     ,  DBT_RUN_RESULTS.ELAPSED_TIME AS RUN_ELAPSED_TIME
     ,  DBT_RUN_RESULTS.EXECUTION_COMMAND AS RUN_EXECUTION_COMMAND
     ,  DBT_RUN_RESULTS.SELECTED_MODELS AS RUN_SELECTED_MODELS
     ,  DBT_RUN_RESULTS.TARGET AS RUN_TARGET
     ,  DBT_RUN_RESULTS.METADATA AS RUN_METADATA
     ,  DBT_RUN_RESULTS.ARGS AS RUN_ARGS
from {{ source('dbt_artifacts', 'dbt_run_results') }} DBT_RUN_RESULTS
    INNER JOIN {{ source('dbt_artifacts', 'dbt_manifest_nodes') }} DBT_MANIFEST_NODES on (
        DBT_MANIFEST_NODES.artifact_run_id = DBT_RUN_RESULTS.artifact_run_id)
    INNER JOIN {{ source('dbt_artifacts', 'dbt_run_results_nodes') }} DBT_RUN_RESULTS_NODES on (
        DBT_MANIFEST_NODES.artifact_run_id = DBT_RUN_RESULTS_NODES.artifact_run_id
        and DBT_MANIFEST_NODES.node_id = DBT_RUN_RESULTS_NODES.node_id)
