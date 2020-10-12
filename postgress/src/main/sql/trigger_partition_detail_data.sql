------------------------------------------------------------------------------------
-----summary.func_insert_trigger_detail_data
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-----Step-1
------------------------------------------------------------------------------------

SET role db_owner;

CREATE OR REPLACE FUNCTION summary.func_insert_trigger_detail_data()
RETURNS TRIGGER AS $$
BEGIN
   
	 execute 'insert into summary.detail_data_' 
			  ||  TO_CHAR( new.business_date, 'YYYY') 
			  || '_'
			  || TO_CHAR( new.business_date, 'mm') 
			  || ' select   (summary.' || TG_TABLE_NAME || ' ' || quote_literal(NEW) || ').*'
			  || ' ON CONFLICT ON CONSTRAINT pk_detail_key_business_date_'
			  ||  TO_CHAR( new.business_date, 'YYYY') 
			  || '_'
			  || TO_CHAR( new.business_date, 'mm')  
			  || ' DO UPDATE
                SET "data" = excluded."data",
                batch_identifier = excluded.batch_identifier,
                batch_number = excluded.batch_number,
                timestamp = excluded.timestamp'
			  ;
               
    RETURN NULL;
END
    
$$
LANGUAGE plpgsql;


------------------------------------------------------------------------------------
-----Step-2
------------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS insert_trigger_detail_data on summary.detail_data;

SET role db_owner;

CREATE TRIGGER insert_trigger_detail_data
BEFORE INSERT ON summary.detail_data
FOR EACH ROW EXECUTE PROCEDURE summary.func_insert_trigger_detail_data();
