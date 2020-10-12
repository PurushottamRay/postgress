--Step-1
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION summary.func_create_partition_index_summary_child(timestamp without time zone, timestamp without time zone)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
create_query text;
BEGIN
    FOR create_query IN SELECT
        ' SET role db_owner; CREATE INDEX idx_summary_btree_business_date_tag_cid_' 
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        ||' ON summary.summary_'
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        ||'  (business_date, summary_config_id, tag);'
		|| 'CREATE INDEX idx_summary_gin_data_all_' 
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        ||' ON summary.summary_'
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        ||' USING gin (data);' 
		|| 'ALTER TABLE summary.summary_'
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
		|| ' ADD CONSTRAINT pk_tbl_key_business_date_' 
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        ||' PRIMARY KEY (summary_config_id, business_date, key, tag);'
        FROM generate_series( $1, $2, '1 month' ) AS d LOOP       
        EXECUTE create_query;
    END LOOP;
END;
$function$;


--Step-2
--Call below function to generate the partition tables. It takes start date, end date  as parameter.
------------------------------------------------------------------------------------------------------------------------------------------------------------

--select summary.func_create_partition_index_summary_child('20190301' :: timestamp, '20191201' :: timestamp);


