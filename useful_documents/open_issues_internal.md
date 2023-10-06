Abklären:

- when running dbt docs generate, bekomme ich die Meldung Database 'DWS' does not exist or not authorized.
  - 11:48:29  Encountered an error while generating catalog: Database Error
    002003 (02000): SQL compilation error:
    Database 'DWS' does not exist or not authorized.

 - Tests 
    Während ich die tests für customer_h beschreiben wollte, ist mir folgendes aufgefallen.
    
        tests:
        - dbt_utils.unique_combination_of_columns:
            combination_of_columns:
                - ldts          
                - hk_customer_h
        --> da sollte kein ldts enthalten sein!
        
        Wie kann ich das umstellen?


- in clean_all_schemas.sql wird dwh_meta direct referenziert statt über die variable


DONE:

  
- das Schema dwh_02_load muss existieren in der data warehouse datenbank. Das sollte noch angepasst werden.
  Einfach mit rein in create_extra_schemas.sql?
  scheint jetzt zu funktionieren, hab' DWH_WILLIBALD gelöscht und wieder neu erstellt, ohne zusätzliche schemata und dbt build ging.
