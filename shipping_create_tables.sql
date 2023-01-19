DROP TABLE IF EXISTS tariff;
CREATE TABLE tariff (
	identifier BIGINT,
	container_number VARCHAR(15),
	description_sequence_number BIGINT,
	harmonized_number VARCHAR(20),
	harmonized_value MONEY,
	harmonized_weight BIGINT,
	harmonized_weight_unit VARCHAR(20), 
	harmonized_weight_kg FLOAT,
	PRIMARY KEY (identifier)
);

DROP TABLE IF EXISTS containers;
CREATE TABLE containers (
	identifier BIGINT,
	container_number VARCHAR(15),
	container_length BIGINT,
	container_height BIGINT,
	container_width BIGINT,
	container_type TEXT, 
	PRIMARY KEY (identifier)
);


DROP TABLE IF EXISTS bill_of_header;
CREATE TABLE bill_of_header (
	identifier BIGINT,
	port_of_unlading VARCHAR(40),
	estimated_arrival_date DATE,
	foreign_port_of_lading TEXT,
	manifest_quantity BIGINT,
	manifest_unit TEXT,
	measurement INT,
	measurement_unit VARCHAR(40),
	port_of_destination TEXT,
	foreign_port_of_destination TEXT,
	actual_arrival_date DATE,
	weight_kg FLOAT,
	PRIMARY KEY (identifier)
);								

CREATE INDEX tariff_idx_container_number ON tariff(container_number) 
	WITH (deduplicate_items = off);
CREATE INDEX containers_idx_container_number ON containers(container_number) 
	WITH (deduplicate_items = off);


COPY tariff FROM 'C:\Users\Public\project_1\silver_layer\tariff__cleaned.csv' 
	DELIMITER '|' CSV HEADER;							
COPY containers FROM 'C:\Users\Public\project_1\silver_layer\containers_cleaned.csv' 
	DELIMITER '|' CSV HEADER;							
COPY bill_of_header FROM 'C:\Users\Public\project_1\silver_layer\bill_header_cleaned.csv' 
	DELIMITER '|' CSV HEADER;							

CREATE ROLE project_1_readonly;
GRANT CONNECT ON DATABASE shipping TO project_1_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO project_1_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO project_1_readonly;
GRANT ALL PRIVILEGES ON DATABASE shipping TO project_1_user;