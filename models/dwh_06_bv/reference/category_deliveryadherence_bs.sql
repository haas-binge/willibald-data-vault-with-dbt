with d as
(
    select 
          try_to_number(s.cdm_count_days_from) as number_of_days_from_num
        , try_to_number(s.cdm_count_days_to) as number_of_days_till_num
        , s.cdm_count_days_from as number_of_days_from
        , s.cdm_count_days_to as number_of_days_till
        , s.cdm_name as name
        , s.category_deliveryadherence_nk as rating
        , CASE WHEN rating ='Abverkauf, keine Lieferung'
               THEN 1
               WHEN rating ='mehr als 10 Tage zu früh'
               THEN 2               
               WHEN rating ='bis zu 10 Tagen zu früh'
               THEN 3
               WHEN rating ='mehr als 5 Tage früher'
               THEN 4               
               WHEN rating ='bis zu 5 Tagen zu früh'
               THEN 5
               WHEN rating ='bis zu 3 Tagen zu früh'
               THEN 6
               WHEN rating ='pünktlich'
               THEN 7
               WHEN rating ='bis zu 3 Tagen zu spät'
               THEN 8 
               WHEN rating ='4 bis 10 Tage zu spät'
               THEN 9   
               WHEN rating ='mehr als 10 Tage spät'
               THEN 10                
               WHEN rating ='bis zu 10 Tage zu spät'
               THEN 11  
               WHEN rating ='Auftrag zu lange aktiv'
               THEN 12                  
		       ELSE -9999999 END AS sort_order       
        , s.hk_category_deliveryadherence_d
        , s.sdts
    from {{ ref("category_deliveryadherence_sns") }} s
 )
select *
from d
