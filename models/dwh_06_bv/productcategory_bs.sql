{{ config(materialized='view') }}

WITH cte_relevant_date as
(
	select sdts
	from {{ ref("relevant_date") }} 
)
, cte_productcategory_hierarchy as
(
	select s.*
	from {{ ref('productcategory_hierarchy_sns') }} s
	cross join cte_relevant_date 
	where  s.sdts = cte_relevant_date.sdts
)
, cte_productcategory as
(
	select s.*
	from {{ ref('productcategory_sns') }} s
	cross join cte_relevant_date 
	where  s.sdts = cte_relevant_date.sdts
)
,level AS
(
    SELECT    s.sdts
            , s.hk_productcategory_h
            , s.hk_productcategory_hierarchy_d
            , hk_productcategory_parent_h
            , p.name as name
            , pp.name as parent_name
            , p.hk_productcategory_d
            , p.productcategory_bk as productcategory_bk
            , pp.productcategory_bk as parent_productcategory_bk
    FROM  cte_productcategory_hierarchy s
    INNER JOIN cte_productcategory p
         ON s.hk_productcategory_h = p.hk_productcategory_h
         AND s.sdts = p.sdts
    LEFT JOIN cte_productcategory pp
         ON s.hk_productcategory_parent_h = pp.hk_productcategory_h
         AND s.sdts = pp.sdts
)
SELECT    l1.sdts
        , l1.hk_productcategory_d
        , l1.productcategory_bk as productcategory_id_l3
        , l1.name as productcategory_l3
        , l1.parent_name as productcategory_l2
        , l1.parent_productcategory_bk as productcategory_id_l2
        , l2.parent_name as productcategory_l1
        , l2.parent_productcategory_bk as productcategory_id_l1
FROM LEVEL l1
INNER JOIN level l2
    ON l1.sdts = l2.sdts
    AND l1.hk_productcategory_parent_h = l2.hk_productcategory_h
INNER JOIN level l3
    ON l2.sdts = l3.sdts
    AND l2.hk_productcategory_parent_h = l3.hk_productcategory_h

