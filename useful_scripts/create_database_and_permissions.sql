/*
This SQL creates an empty Database and sets the permissions to a role willibald_developer 
if you don't want to use the ACCOUNTADMIN-role
It assumes the presence of a warehouse called COMPUTE_WH.
*/
CREATE or REPLACE database WILLIBALD_DATA_VAULT_WITH_DBT;
USE DATABASE WILLIBALD_DATA_VAULT_WITH_DBT;
GRANT all on warehouse COMPUTE_WH to role willibald_developer;
GRANT usage on database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT create schema on database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer; 
GRANT usage on future schemas in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT monitor on future schemas in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT select on future tables in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT select on future views in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT usage on all schemas in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT monitor on all schemas in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT select on all tables in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;
GRANT select on all views in database WILLIBALD_DATA_VAULT_WITH_DBT to role willibald_developer;