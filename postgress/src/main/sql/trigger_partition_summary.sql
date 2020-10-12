------------------------------------------------------------------------------------
-----summary.func_insert_trigger_summary
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-----Step-1
------------------------------------------------------------------------------------
SET role db_owner;

CREATE OR REPLACE FUNCTION summary.func_insert_trigger_summary()
RETURNS TRIGGER AS $$
BEGIN
   
	 execute 'insert into summary.summary_' 
			  ||  TO_CHAR( new.business_date, 'YYYY') 
			  || '_'
			  || TO_CHAR( new.business_date, 'mm') 
			  || ' select   (summary.' || TG_TABLE_NAME || ' ' || quote_literal(NEW) || ').* '
			  || ' ON CONFLICT ON CONSTRAINT pk_tbl_key_business_date_'
			  ||  TO_CHAR( new.business_date, 'YYYY') 
			  || '_'
			  || TO_CHAR( new.business_date, 'mm')  
			  || ' DO UPDATE
				 SET data = excluded."data",
					 timestamp = excluded."timestamp",
					 batch_identifier = excluded."batch_identifier"'
			  ; 

    RETURN NULL;
END
    
$$
LANGUAGE plpgsql;




------------------------------------------------------------------------------------
-----Step-2
------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS insert_trigger_summary on summary.summary;

SET role db_owner;

CREATE TRIGGER insert_trigger_summary
BEFORE INSERT ON summary.summary
FOR EACH ROW EXECUTE PROCEDURE summary.func_insert_trigger_summary();
