SET role db_owner;

-- Drop table

-- DROP TABLE summary.detail_data

CREATE TABLE summary.detail_data (
	id serial NOT NULL,
	"timestamp" timestamp NOT NULL,
	business_date date NOT NULL,
	tenant_id int2 NOT NULL,
	stream_id int2 NOT NULL,
	tag varchar(1024) NOT NULL,
	batch_identifier varchar(1024) NOT NULL,
	batch_number int4 NOT NULL,
	"data" jsonb NOT NULL,
	"key" jsonb NOT NULL,
	CONSTRAINT pk_detail_key_business_date PRIMARY KEY (business_date, key, tag)
);
CREATE INDEX idx_detail_data_btree_bd_stream_tag ON summary.detail_data USING btree (business_date, stream_id, tag);
CREATE INDEX idx_detail_data_btree_data_book_id_as_text ON summary.detail_data USING btree (((key ->> 'bookId'::text)));
CREATE INDEX idx_detail_data_btree_data_component_id_as_text ON summary.detail_data USING btree (((key ->> 'componentId'::text)));
CREATE INDEX idx_detail_data_btree_data_legal_entity_id_as_text ON summary.detail_data USING btree (((key ->> 'legalEntityId'::text)));
CREATE INDEX idx_detail_data_btree_data_open_date_as_text ON summary.detail_data USING btree (((key ->> 'openDate'::text)));
CREATE INDEX idx_detail_data_btree_data_valid_start_as_text ON summary.detail_data USING btree (((key ->> 'validStart'::text)));

