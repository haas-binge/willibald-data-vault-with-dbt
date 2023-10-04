{{ config(materialized='view') }}

{%- set yaml_metadata -%}
control_snap_v0: 'control_snap_v0'
log_logic: 
    daily:
        duration: 7
        unit: 'DAY'
    weekly:
        duration: 0
        unit: 'YEAR'
    monthly:
        duration: 1
        unit: 'YEAR'
    yearly:
        forever: true
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set control_snap_v0 = metadata_dict['control_snap_v0'] -%}
{%- set log_logic = metadata_dict['log_logic'] -%}
with control_snap_v1 as
(
{{ datavault4dbt.control_snap_v1(control_snap_v0=control_snap_v0,
                                log_logic=log_logic) }}
),
load_sdts as
(
    select sdts, 
            max(sdts) over () = sdts as is_latest
    from {{ ref('load_sdts') }}
),
cte_esdts as
(
    select * 
        , COALESCE(LEAD(replacement_sdts - INTERVAL '1 MICROSECOND') OVER ( ORDER BY  replacement_sdts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS replacement_esdts
    from control_snap_v1
)
select    cte_esdts.* exclude (is_latest, is_active)  
        , l.is_latest
        , true as is_active
from load_sdts l
left join cte_esdts
    on l.sdts between cte_esdts.replacement_sdts and cte_esdts.replacement_esdts




