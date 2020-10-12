--Step-1
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION summary.func_create_partition_summary(timestamp without time zone, timestamp without time zone)
RETURNS void
LANGUAGE plpgsql
AS $function$
DECLARE
create_query text;
BEGIN
    FOR create_query IN SELECT
        'SET role db_owner; CREATE TABLE summary.summary_' 
    
        ||  TO_CHAR( d, 'YYYY' ) 
        || '_'
        || TO_CHAR( d, 'mm' ) 
        || '(CHECK ( business_date >= ''' || TO_CHAR(d,'YYYY/MM/DD') || ''' AND 
            business_date < ''' || TO_CHAR(d + interval '1 month', 'YYYY/MM/DD') || '''' ||'
          )) INHERITS (summary.summary);'
        FROM generate_series( $1, $2, '1 month' ) AS d LOOP       
        EXECUTE create_query;
    END LOOP;
END;
$function$;


--Step-2
--Call below function to generate the partition tables. It takes start date, end date and dataset source id as parameter.
------------------------------------------------------------------------------------------------------------------------------------------------------------

--select summary.func_create_partition_summary('20190301' :: timestamp, '20191201' :: timestamp);

