{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
start_date: '2022-01-01'
daily_snapshot_time: '23:59:59'
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set start_date = metadata_dict['start_date'] -%}
{%- set daily_snapshot_time = metadata_dict['daily_snapshot_time'] -%}


with s0data as
(
{{ datavault4dbt.control_snap_v0(start_date=start_date,
                                daily_snapshot_time=daily_snapshot_time
                                ) }} 
)
select    date_trunc(day, sdts) as replacement_sdts
        , * exclude replacement_sdts
       
from s0data                               
where sdts  < dateadd(day, 1, date_trunc(day, sysdate()))                             


