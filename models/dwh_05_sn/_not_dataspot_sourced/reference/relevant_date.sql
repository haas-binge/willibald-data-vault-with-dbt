{{ config(materialized='table') }}
	select *
	from {{ ref("control_snap_v1") }} b
	