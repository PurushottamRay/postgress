--Step-1
------------------------------------------------------------------------------------------------------------------------------------------------------------

	CREATE OR REPLACE FUNCTION summary.func_create_partition_index_detail_data_child(timestamp without time zone, timestamp without time zone)
	RETURNS void
	LANGUAGE plpgsql
	AS $function$
	DECLARE
	create_query text;
	BEGIN
		FOR create_query IN SELECT
			' SET role db_owner; CREATE INDEX idx_detail_data_btree_bd_stream_tag_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (business_date, stream_id, tag);'
			|| ' CREATE INDEX idx_detail_data_btree_data_legal_entity_id_as_text_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (((key ->> ''legalEntityId''::text)));'
			|| ' CREATE INDEX idx_detail_data_btree_data_open_date_as_text_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (((key ->> ''openDate''::text)));'
			|| ' CREATE INDEX idx_detail_data_btree_data_valid_start_as_text_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (((key ->> ''validStart''::text)));'
			|| ' CREATE INDEX idx_detail_data_btree_data_component_id_as_text_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (((key ->> ''componentId''::text)));'
			|| 'CREATE INDEX idx_detail_data_btree_data_book_id_as_text_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' ON summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||'  (((key ->> ''bookId''::text)));' 
			|| 'ALTER TABLE summary.detail_data_'
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			|| ' ADD CONSTRAINT pk_detail_key_business_date_' 
			||  TO_CHAR( d, 'YYYY' ) 
			|| '_'
			|| TO_CHAR( d, 'mm' ) 
			||' PRIMARY KEY (business_date, key, tag);'
			FROM generate_series( $1, $2, '1 month' ) AS d LOOP       
			EXECUTE create_query;
		END LOOP;
	END;
	$function$;


--Step-2
--Call below function to generate the partition tables. It takes start date, end date  as parameter.
------------------------------------------------------------------------------------------------------------------------------------------------------------

--select summary.func_create_partition_index_detail_data_child('20190301' :: timestamp, '20191201' :: timestamp);

