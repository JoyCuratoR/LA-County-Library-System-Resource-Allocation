-- just looking at the columns I need
SELECT location, circulation_of_childrens_materials, circulation_of_non_english_materials,
physical_item_circulation,  circulation_of_electronic_materials, 
successful_retrieval_of_electronic_information, total_electronic_content_use, total_annual_circulation,
total_content_use
FROM la_libraries.la_circulation;

-- How are patrons interacting with libraries the most? online (electronic checkouts) or in person (indicated by annual circ for inperson checkouts)
SELECT location, total_annual_circulation, total_electronic_content_use,
CASE
	WHEN total_annual_circulation > total_electronic_content_use THEN 'In-Person'
    WHEN total_annual_circulation = total_electronic_content_use THEN 'Both'
    ELSE 'Online'
END AS In_Person_Or_Online
FROM la_libraries.la_circulation;
-- needed to fill in the rest of data of total_annual_circulation for accuracy

-- filling in the rest of total annual circulation column
SELECT location, total_annual_circulation, total_electronic_content_use, total_content_use
FROM
	(
		SELECT location, total_annual_circulation, total_electronic_content_use, total_content_use,
			(CASE 
				WHEN total_annual_circulation = 'NA' THEN total_content_use - total_electronic_content_use
				ELSE total_annual_circulation
			END) AS New_total_annual
FROM la_libraries.la_circulation);

-- rewriting new query that combines both case-when statements to find online or in-person
SELECT location, total_electronic_content_use, New_total_annual,
CASE
    WHEN New_total_annual > total_electronic_content_use THEN 'In-Person'
    WHEN New_total_annual = total_electronic_content_use THEN 'Both'
    ELSE 'Online'
END AS In_Person_Or_Online
FROM
    (
        SELECT location, total_annual_circulation, total_electronic_content_use, total_content_use,
            (CASE 
                WHEN total_annual_circulation = 'NA' THEN total_content_use - total_electronic_content_use
                ELSE total_annual_circulation
            END) AS New_total_annual
    FROM la_libraries.la_circulation
    ) AS Patron_interaction;

     -- counting how many in-person and online
SELECT location, In_Person_Or_Online, COUNT(*) AS count
FROM
(
SELECT location, total_electronic_content_use, New_total_annual,
CASE
    WHEN New_total_annual > total_electronic_content_use THEN 'In-Person'
    WHEN New_total_annual = total_electronic_content_use THEN 'Both'
    ELSE 'Online'
END AS In_Person_Or_Online
FROM
    (
        SELECT location, total_annual_circulation, total_electronic_content_use, total_content_use,
            (CASE 
                WHEN total_annual_circulation = 'NA' THEN total_content_use - total_electronic_content_use
                ELSE total_annual_circulation
            END) AS New_total_annual
    FROM la_libraries.la_circulation
    ) AS Patron_interaction
    ) AS Counted
    GROUP BY In_Person_Or_Online;

-- Higest and lowest total content use (checkouts being done), which library is being used the most?
SELECT location, total_content_use
FROM la_libraries.la_circulation
ORDER BY total_content_use DESC;

SELECT location, total_content_use
FROM (
  SELECT location, total_content_use,
         ROW_NUMBER() OVER (ORDER BY total_content_use DESC) AS rnk_desc,
         ROW_NUMBER() OVER (ORDER BY total_content_use ASC) AS rnk_asc
  FROM la_libraries.la_circulation
) sub
WHERE rnk_desc = 1 OR rnk_asc = 1
ORDER BY total_content_use DESC;

