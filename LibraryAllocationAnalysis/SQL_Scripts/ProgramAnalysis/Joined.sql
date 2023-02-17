-- joining tables and selecting only the needed columns
SELECT popular.location, popular.most_popular_program, highest.highest_num_programs_offered
FROM mostpopularprogram AS popular
JOIN highestnumprogramoffered AS highest
ON popular.location = highest.location;

-- adding casewhen statement to quickly determine which libraries are optimizing their programs
SELECT 
  popular.location, 
  popular.most_popular_program, 
  highest.highest_num_programs_offered,
  (CASE 
    WHEN popular.most_popular_program = highest.highest_num_programs_offered THEN 'Match' 
    ELSE 'No Match' 
  END) AS compare_result
FROM 
  la_libraries.mostpopularprogram AS popular
JOIN 
  la_libraries.highestnumprogramoffered AS highest
ON 
  popular.location = highest.location;

-- counting number of 'no match' and 'match'
SELECT compare_result, COUNT(*) AS libraries
FROM
(
    SELECT popular.location, popular.most_popular_program, highest.highest_num_programs_offered,
        (CASE 
            WHEN most_popular_program = highest_num_programs_offered THEN 'Match' 
            ELSE 'No Match' 
        END) as compare_result
    FROM la_libraries.mostpopularprogram AS popular
    JOIN la_libraries.highestnumprogramoffered AS highest
    ON popular.location = highest.location
) subq
GROUP BY compare_result;

-- looking at only libraries that had a 'no match'
SELECT *
FROM 
(
    SELECT popular.location, popular.most_popular_program, highest.highest_num_programs_offered,
    (CASE 
        WHEN most_popular_program = highest_num_programs_offered THEN 'Match' 
        ELSE 'No Match' 
    END) as compare_result
    FROM la_libraries.mostpopularprogram AS popular
    JOIN la_libraries.highestnumprogramoffered AS highest
    ON popular.location = highest.location
) AS result_set
WHERE compare_result = 'No Match';

