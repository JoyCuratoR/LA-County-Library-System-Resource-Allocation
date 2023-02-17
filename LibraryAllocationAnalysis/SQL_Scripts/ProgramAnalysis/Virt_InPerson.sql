SELECT location,
(CASE
	WHEN childrens_program_attendance_live_in_person > childrens_program_attendance_live_virtual THEN 'In Person'
    WHEN childrens_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN childrens_program_attendance_live_virtual = 'NA' THEN 'NA'
	ELSE 'Virtual'
END) AS children,
(CASE
	WHEN young_adult_program_attendance_live_in_person > young_adult_program_attendance_live_virtual THEN 'In person'
    WHEN young_adult_program_attendance_live_in_person = 'NA' THEN 'NA' 
    WHEN young_adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS YA,
(CASE 
	WHEN adult_program_attendance_live_in_person > adult_program_attendance_live_virtual THEN 'In Person'
    WHEN adult_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS adult
FROM la_libraries.la_attend;

-- counting how many libraries did YA programs inperson, virtual or was NA
SELECT YA AS YA_programs, COUNT(*) AS libraries
FROM (
		SELECT location,
(CASE
	WHEN childrens_program_attendance_live_in_person > childrens_program_attendance_live_virtual THEN 'In Person'
    WHEN childrens_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN childrens_program_attendance_live_virtual = 'NA' THEN 'NA'
	ELSE 'Virtual'
END) AS children,
(CASE
	WHEN young_adult_program_attendance_live_in_person > young_adult_program_attendance_live_virtual THEN 'In person'
    WHEN young_adult_program_attendance_live_in_person = 'NA' THEN 'NA' 
    WHEN young_adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS YA,
(CASE 
	WHEN adult_program_attendance_live_in_person > adult_program_attendance_live_virtual THEN 'In Person'
    WHEN adult_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS adult
FROM la_libraries.la_attend) AS sub
GROUP BY YA;

-- counting adult programs
SELECT adult AS Adult_programs, COUNT(*) AS libraries
FROM (
		SELECT location,
(CASE
	WHEN childrens_program_attendance_live_in_person > childrens_program_attendance_live_virtual THEN 'In Person'
    WHEN childrens_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN childrens_program_attendance_live_virtual = 'NA' THEN 'NA'
	ELSE 'Virtual'
END) AS children,
(CASE
	WHEN young_adult_program_attendance_live_in_person > young_adult_program_attendance_live_virtual THEN 'In person'
    WHEN young_adult_program_attendance_live_in_person = 'NA' THEN 'NA' 
    WHEN young_adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS YA,
(CASE 
	WHEN adult_program_attendance_live_in_person > adult_program_attendance_live_virtual THEN 'In Person'
    WHEN adult_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS adult
FROM la_libraries.la_attend) AS sub
GROUP BY adult;

-- counting children's programs
SELECT children AS children_programs, COUNT(*) AS libraries
FROM (
		SELECT location,
(CASE
	WHEN childrens_program_attendance_live_in_person > childrens_program_attendance_live_virtual THEN 'In Person'
    WHEN childrens_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN childrens_program_attendance_live_virtual = 'NA' THEN 'NA'
	ELSE 'Virtual'
END) AS children,
(CASE
	WHEN young_adult_program_attendance_live_in_person > young_adult_program_attendance_live_virtual THEN 'In person'
    WHEN young_adult_program_attendance_live_in_person = 'NA' THEN 'NA' 
    WHEN young_adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS YA,
(CASE 
	WHEN adult_program_attendance_live_in_person > adult_program_attendance_live_virtual THEN 'In Person'
    WHEN adult_program_attendance_live_in_person = 'NA' THEN 'NA'
    WHEN adult_program_attendance_live_virtual = 'NA' THEN 'NA'
    ELSE 'Virtual'
END) AS adult
FROM la_libraries.la_attend) AS sub
GROUP BY children;