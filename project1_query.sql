DROP TABLE IF EXISTS tariff;
CREATE TABLE tariff (
		identifier BIGINT,
		container_number VARCHAR(50),
		description_sequence_number BIGINT,
		harmonized_number TEXT,
		harmonized_value MONEY,
		harmonized_weight BIGINT,
		harmonized_weight_unit TEXT, 
		harmonized_weight_kg FLOAT,
		PRIMARY KEY (identifier)
);

COPY tariff FROM 'C:\Users\Public\postgres_sql\silver_layer\tariff__cleaned.csv' DELIMITER '|' CSV HEADER;