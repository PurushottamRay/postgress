------------------------------------------------------------------------------------
-----summary.processed_feed_data_keys
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
			  || ' select   (summary.' || TG_TABLE_NAME || ' ' || quote_literal(NEW) || ').*'; 

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
