# Naming conventions

## Naming convention tables
```
<business_entity_name>_<src_system>_<table_type_layer>_<table_type detail>_<table_type_base>

<src_system>    standardized code for a source system. Use 'SYS' for system generated records. e.g. webshop : ws, roadshow: rs  

<table_type_layer>  
                <sn: snapshot> this layer contains usually pits based on snapshot and a view on top of the pit containing all describing attributes of all  
                               the  satellites hanging off the hub or link the pit is based on (also snapshot-based). The idea behind separating this is,  
                               that this can also relatively easy automaticly be generated (satellite / pit)
                <b: business> entities containing genuine business logic
<table_type detail>  
                <st: status tracking (satellite)> 
                <rt: record tracking (satellite)> 
                <e: effectivity (satellite)> 
                <nh: non-historised (link)>
                <h: hierarchical (link)>
                <r: reference-table (satellite / hub)>
<table_type_base>  
                <s: satellite>  
                <h: hub>  
                <l: link>  
                <p: pit>  
                <b: bridge>

```
## Naming convention columns
```
hub hash_key-column:    hk_<business_entity_name>_h  
link hash_key-colum:    hk_<link_entity_name>_l  
business_key:           <business_entity_name>_bk

```

CTEs should be named cte_<business_entity_name>[_description]

dbt is case sensitive. To avoid confusion, all objects in dbt should be defined in lower-case.


[   ]	encapsulates optional placeholder 	




