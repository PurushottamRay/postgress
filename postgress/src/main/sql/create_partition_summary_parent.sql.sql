SET role db_owner;

-- Drop table

-- DROP TABLE summary.summary

CREATE TABLE summary.summary (
	id serial NOT NULL,
	summary_config_id int2 NOT NULL,
	batch_identifier varchar(1024) NOT NULL,
	tag varchar(1024) NOT NULL,
	business_date date NOT NULL,
	"timestamp" timestamp NULL,
	"key" jsonb NOT NULL,
	"data" jsonb NULL,
	CONSTRAINT pk_tbl_key_business_date PRIMARY KEY (summary_config_id, business_date, key, tag)
);
CREATE INDEX idx_summary_btree_business_date_tag_cid ON summary.summary USING btree (business_date, summary_config_id, tag);
CREATE INDEX idx_summary_gin_data_all ON summary.summary USING gin (data);
