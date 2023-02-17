-- Which library is spent the most, which spend the least?
SELECT location, total_expenditures
FROM (
  SELECT location, total_expenditures,
         ROW_NUMBER() OVER (ORDER BY total_expenditures DESC) AS rnk_desc,
         ROW_NUMBER() OVER (ORDER BY total_expenditures ASC) AS rnk_asc
  FROM la_libraries.la_expenses
) sub
WHERE rnk_desc = 1 OR rnk_asc = 1
ORDER BY total_expenditures DESC;

-- Circulation expenses, are the libraries spending the most money on their popular and most checked out materials?
SELECT location,
	CASE
		WHEN percent_of_collection_expenditures_on_print_materials >= percent_of_collection_expenditures_on_electronic_materials 
			AND percent_of_collection_expenditures_on_print_materials >= percent_of_collection_expenditures_on_serial_subscriptions
		THEN 'Print' 
        WHEN percent_of_collection_expenditures_on_electronic_materials >= percent_of_collection_expenditures_on_print_materials
			AND percent_of_collection_expenditures_on_electronic_materials >= percent_of_collection_expenditures_on_serial_subscriptions
		THEN 'Electronic' 
		WHEN percent_of_collection_expenditures_on_serial_subscriptions >= percent_of_collection_expenditures_on_print_materials
			AND percent_of_collection_expenditures_on_serial_subscriptions >= percent_of_collection_expenditures_on_electronic_materials
		THEN 'Serial' 
        ELSE 'Other'
        END AS highest_expenses
FROM la_libraries.la_expenses;

 -- counting number of print and electronic 
 SELECT highest_expenses, COUNT(*) AS count
 FROM (
 SELECT location,
	CASE
		WHEN percent_of_collection_expenditures_on_print_materials >= percent_of_collection_expenditures_on_electronic_materials 
			AND percent_of_collection_expenditures_on_print_materials >= percent_of_collection_expenditures_on_serial_subscriptions
		THEN 'Print' 
        WHEN percent_of_collection_expenditures_on_electronic_materials >= percent_of_collection_expenditures_on_print_materials
			AND percent_of_collection_expenditures_on_electronic_materials >= percent_of_collection_expenditures_on_serial_subscriptions
		THEN 'Electronic' 
		WHEN percent_of_collection_expenditures_on_serial_subscriptions >= percent_of_collection_expenditures_on_print_materials
			AND percent_of_collection_expenditures_on_serial_subscriptions >= percent_of_collection_expenditures_on_electronic_materials
		THEN 'Serial' 
        ELSE 'Other'
        END AS highest_expenses
FROM la_libraries.la_expenses ) AS sub 
GROUP BY highest_expenses;

-- Looking back on circulation, does what the libraries spend the most money on, match with what's being circulated/checked-out the most?
-- join patron interaction csv with highest expenses csv to find match or no match
SELECT 
  interaction.location, 
  interaction.In_Person_Or_Online, 
  expenses.highest_expenses,
  (CASE 
    WHEN interaction.In_Person_Or_Online = 'In-Person'
		AND expenses.highest_expenses = 'Print' 
	THEN 'Match' 
    WHEN interaction.In_Person_Or_Online = 'Online' 
		AND expenses.highest_expenses = 'Electronic'
	THEN 'Match'
    ELSE 'No Match' 
  END) AS compare_result
FROM 
  la_libraries.patroninteraction AS interaction
JOIN 
  la_libraries.highestexpenses AS expenses
ON 
  interaction.location = expenses.location;
  
  -- Filtering only for No Match
  SELECT *
  FROM (
	  SELECT 
	  interaction.location, 
	  interaction.In_Person_Or_Online, 
	  expenses.highest_expenses,
	  (CASE 
		WHEN interaction.In_Person_Or_Online = 'In-Person'
			AND expenses.highest_expenses = 'Print' 
		THEN 'Match' 
		WHEN interaction.In_Person_Or_Online = 'Online' 
			AND expenses.highest_expenses = 'Electronic'
		THEN 'Match'
		ELSE 'No Match' 
	  END) AS compare_result
	FROM 
	  la_libraries.patroninteraction AS interaction
	JOIN 
	  la_libraries.highestexpenses AS expenses
	ON 
	  interaction.location = expenses.location) as Result_set
  WHERE compare_result = 'No Match';
  
  -- Breakdown on specific library materials' expenditures - which one is the highest spent?
  SELECT id, location,
	CASE 
		WHEN print_materials_expenditures >= print_serial_subscription_expenditures 
			AND print_materials_expenditures >= electronic_materials_expenditures
		THEN 'Print Materials'
        WHEN print_serial_subscription_expenditures >= print_materials_expenditures
			AND print_serial_subscription_expenditures >= electronic_materials_expenditures
		THEN 'Serial Sub'
        WHEN electronic_materials_expenditures >= print_materials_expenditures 
			AND electronic_materials_expenditures >= print_serial_subscription_expenditures
		THEN 'Electronic'
	ELSE 'Other Materials'
    END AS material_expenses
  FROM la_libraries.expenditures_dollars;
  
  -- to check 
  SELECT id, location, print_materials_expenditures, print_serial_subscription_expenditures,
electronic_materials_expenditures, other_materials_expenditures
FROM la_libraries.expenditures_dollars;

-- Is the amount of money libraries are spending to be open per hour worth the amount of visits they get per hour?
-- does the amount of visits a library is getting warrant the expenses of keeping a library open for their set hours?
-- I want to know if it's better to shorten library hours to save money 
-- there's not enough data to accurately calculate this
SELECT visits.location, visits.hours_open_all, expenses.total_operating_expenditures_per_open_hour
FROM la_libraries.la_visits AS visits
JOIN la_libraries.la_expenses AS expenses
ON visits.location = expenses.location;

-- calculating ---
SELECT visits.location, (hours_open_all * total_operating_expenditures_per_open_hour) AS yearly_operating_expense
FROM la_libraries.la_visits AS visits
JOIN la_libraries.la_expenses AS expenses
ON visits.location = expenses.location
