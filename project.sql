
-- average delay with average gross weight 
CREATE or REPLACE VIEW avg_delay_with_gross_weight AS
	SELECT month, 
		round(avg(actual_arrival_date - estimated_arrival_date),2) as averag_delay,
		CONCAT(round(avg(weight_kg)::numeric,2), ' kg') as average_weight
	FROM 
		(
			SELECT TO_CHAR(actual_arrival_date, 'MONTH') as month,
			actual_arrival_date, estimated_arrival_date, weight_kg
			FROM bill_of_header
		) sq1
	group by month
	order by averag_delay DESC;

-- gather the average weight and average delay filtered to the west coast 
CREATE or REPLACE VIEW avg_weight_delay_west AS
	SELECT port_of_unlading,
		round(avg(actual_arrival_date - estimated_arrival_date),2) as average_delay,
		round(avg(weight_kg)::numeric,2) as average_weight
	FROM bill_of_header 
	WHERE port_of_unlading LIKE '%California%' OR port_of_unlading LIKE '%Oregon%' 
		OR port_of_unlading LIKE '%Washington%'
	GROUP BY port_of_unlading 
	ORDER BY average_delay DESC;

-- gather the average weight and average delay filtered to the east coast 
CREATE or REPLACE VIEW avg_weight_delay_east AS
	SELECT port_of_unlading,
		round(avg(actual_arrival_date - estimated_arrival_date),2) as average_delay,
		round(avg(weight_kg)::numeric,2) as average_weight
	FROM bill_of_header 
	GROUP BY port_of_unlading 
	ORDER BY average_delay DESC;
	

-- finding maximum net weight of the commodity for each container 
CREATE OR REPLACE VIEW weight_distinct_container AS 
	SELECT 
		c.container_number,
		tariff_max_weight.harmonized_number, 
		tariff_max_weight.harmonized_weight_kg, 
		tariff_max_weight.harmonized_value, 
		c.container_width,
		c.container_height, 
		c.container_length
	FROM (
		SELECT DISTINCT ON (container_number) 
			identifier,     
			container_number, 
			harmonized_value,
			harmonized_number,
			harmonized_weight_kg
			FROM tariff
			ORDER BY container_number, harmonized_weight_kg DESC
	) tariff_max_weight
	JOIN containers C ON c.container_number = tariff_max_weight.container_number 
		AND c.identifier = tariff_max_weight.identifier
	ORDER BY harmonized_weight_kg DESC;

-- average delay for each month
CREATE or REPLACE VIEW avg_delay_per_month AS
	SELECT month, 
		round(avg(actual_arrival_date - estimated_arrival_date),2) as averag_delay 
	FROM 
		(
			SELECT TO_CHAR(actual_arrival_date, 'MONTH') as month,
			actual_arrival_date, estimated_arrival_date
			FROM bill_of_header
		) sq1
	group by month
	order by averag_delay DESC;

-- average delay for the year
CREATE or REPLACE VIEW avg_delay_per_year AS
	SELECT  shipping_year, 
		round(avg(actual_arrival_date - estimated_arrival_date),2) as averag_delay 
	FROM 
		(
			SELECT TO_CHAR(actual_arrival_date, 'yyyy') as shipping_year,
			actual_arrival_date, estimated_arrival_date
			FROM bill_of_header
		) sq1
	group by shipping_year
	order by averag_delay DESC;




-- get the heaviest weight from my joined tariff table with containers table
CREATE or REPLACE VIEW maximum_weight AS
	SELECT  MAX(harmonized_weight_kg) FROM (
		SELECT t.harmonized_number, t.harmonized_value, t.harmonized_weight_kg, c.container_type,
		c.container_height, c.container_width, c.container_length
		FROM tariff t
		JOIN containers c ON t.container_number = c.container_number
		) max_weight;
		
CREATE or REPLACE VIEW port_unlading_max_weight AS
	SELECT port_of_unlading, weight_kg FROM bill_of_header
		WHERE weight_kg = 36626000;

-- join maybe the container number from containers to the tariff table weight 
CREATE or REPLACE VIEW tariff_container_join AS
	SELECT t.harmonized_number, t.harmonized_value, t.harmonized_weight_kg, c.container_type,
		c.container_height, c.container_width, c.container_length
		FROM tariff t
		JOIN containers c ON t.container_number = c.container_number;
		
	
	
-- getting average sizes of containers grouped by container number
CREATE OR REPLACE VIEW container_avg_dimensions AS
	SELECT DISTINCT container_number, avg_length, avg_width, avg_height FROM
		(
			SELECT container_number,  round(avg(container_length),2) as avg_length,
			 round(avg(container_width),2) as avg_width,
			round(avg(container_height),2) as avg_height
			FROM containers GROUP BY container_number
		) average_size
	GROUP BY container_number, avg_length, avg_width, avg_height;

-- counts of the sizes of the containers
CREATE OR REPLACE VIEW count_container_dimensions AS
	SELECT (
			SELECT 
			count(*)
			FROM containers
			WHERE container_length = 4000
		) AS length_count,
		( 
			SELECT
			COUNT(*)
			FROM containers 
			WHERE container_width = 800
		) AS width_count, 
		(
			SELECT count(*)
			FROM containers
			WHERE container_height = 900
		) AS height_count;

