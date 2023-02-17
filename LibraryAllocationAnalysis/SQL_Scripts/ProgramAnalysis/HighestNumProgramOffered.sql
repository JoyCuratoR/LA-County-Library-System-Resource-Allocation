
SELECT location,
	CASE 
	WHEN childrens_programs_calculated >= num_of_young_adult_programs_calculated 
		AND childrens_programs_calculated >= num_of_adult_programs_calculated 
    THEN 'Children'
    WHEN num_of_young_adult_programs_calculated >= childrens_programs_calculated 
		AND num_of_young_adult_programs_calculated >= num_of_adult_programs_calculated 
    THEN 'Young Adult'
    WHEN num_of_adult_programs_calculated >= childrens_programs_calculated 
		AND num_of_adult_programs_calculated >= num_of_young_adult_programs_calculated 
    THEN 'Adult'
    ELSE 'Undetermined'
END AS highest_num_programs_offered
FROM la_libraries.la_programs;

-- counting how many libraries had adult and children programs as highest number of programs they offered
SELECT highest_num_programs_offered, COUNT(*) AS libraries
FROM (
		SELECT MyUnknownColumn, location, childrens_programs_calculated, num_of_young_adult_programs_calculated, num_of_adult_programs_calculated,
			CASE 
				WHEN childrens_programs_calculated >= num_of_young_adult_programs_calculated 
					AND childrens_programs_calculated >= num_of_adult_programs_calculated 
				THEN 'Children'
				WHEN num_of_young_adult_programs_calculated >= childrens_programs_calculated 
					AND num_of_young_adult_programs_calculated >= num_of_adult_programs_calculated 
				THEN 'Young Adult'
				WHEN num_of_adult_programs_calculated >= childrens_programs_calculated 
					AND num_of_adult_programs_calculated >= num_of_young_adult_programs_calculated 
				THEN 'Adult'
				ELSE 'Undetermined'
			END AS highest_num_programs_offered
FROM la_libraries.la_programs) AS sub
GROUP BY highest_num_programs_offered;