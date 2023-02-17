-- exploring which program for each library is the most popular
SELECT MyUnknownColumn, location, childrens_program_attendance, young_adult_program_attendance_calculated, adult_program_attendance_calculated,
CASE
	WHEN childrens_program_attendance >= young_adult_program_attendance_calculated AND childrens_program_attendance >= adult_program_attendance_calculated THEN 'Children'
	WHEN young_adult_program_attendance_calculated >= childrens_program_attendance AND young_adult_program_attendance_calculated >= adult_program_attendance_calculated THEN 'Young Adult'
	ELSE 'Adult'
END AS most_popular_program
FROM la_libraries.la_attend;

-- counting how many libraries has children, young adult, or adult as their most popular program
SELECT most_popular_program, COUNT(*) as count
FROM (
  SELECT 
    CASE 
      WHEN childrens_program_attendance >= young_adult_program_attendance_calculated AND 
           childrens_program_attendance >= adult_program_attendance_calculated
      THEN 'Children'
      WHEN young_adult_program_attendance_calculated >= childrens_program_attendance AND 
           young_adult_program_attendance_calculated >= adult_program_attendance_calculated 
      THEN 'Young adult'
      ELSE 'Adult'
    END AS most_popular_program
  FROM la_libraries.la_attend
) sub_query
GROUP BY most_popular_program;


