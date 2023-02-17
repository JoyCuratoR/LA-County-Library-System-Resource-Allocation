-- Which libraries has highest and which has lowest total operating income?
SELECT location, total_operating_income
FROM (
  SELECT location, total_operating_income,
         ROW_NUMBER() OVER (ORDER BY total_operating_income DESC) AS rnk_desc,
         ROW_NUMBER() OVER (ORDER BY total_operating_income ASC) AS rnk_asc
  FROM la_libraries.la_income
) sub
WHERE rnk_desc = 1 OR rnk_asc = 1
ORDER BY total_operating_income DESC;

-- per capita distribution analysis
SELECT location,
	CASE 
        WHEN operating_income_from_local_government_per_capita > operating_income_from_state_government_per_capita
            AND operating_income_from_local_government_per_capita > operating_income_from_federal_government_per_capita
		THEN 'Local Gov' 
        WHEN operating_income_from_state_government_per_capita > operating_income_from_local_government_per_capita
            AND operating_income_from_state_government_per_capita > operating_income_from_federal_government_per_capita
		THEN 'State Gov' 
        WHEN operating_income_from_local_government_per_capita = operating_income_from_state_government_per_capita
			OR operating_income_from_local_government_per_capita = operating_income_from_state_government_per_capita
            OR operating_income_from_state_government_per_capita = operating_income_from_federal_government_per_capita
        THEN 'Even'
        ELSE 'Federal Gov' 
	END AS Income_Source
FROM la_libraries.la_income;



