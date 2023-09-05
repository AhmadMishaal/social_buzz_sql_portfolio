# In this project i have created a database named social_content_analysis where it will contain my data.

use social_content_analysis;

# We have 3 tables named (reactions, content, reaction_type) that we need to analyze it,

# First we need to explore our data and prepare it for analysis:

SELECT * FROM reactions;

SELECT * FROM content;

SELECT * FROM reaction_types;

# Check the content categories that has been posted 

SELECT
	DISTINCT category
FROM
	content
;

# Process and clean the category columns in the content table

SELECT DISTINCT
	LOWER(REPLACE (category,'"',''))AS Category
FROM
	content
ORDER BY
	category ASC
;
 
# Check the content types of the posts 

SELECT
	DISTINCT type
FROM
	content
;

# Find the number of reaction types in the data

SELECT
    DISTINCT type AS reaction_type,
    COUNT(type) AS num_of_reactions
FROM
	reactions
GROUP BY
	reaction_type
ORDER BY
	type
;

SELECT
	`Content ID`,
    type AS reaction_type,
    datetime
FROM
	reactions
WHERE
	`Content ID` IS NOT NULL
;

# Create a temporary table that will contain the full data of the three table and join it together

# DROP TEMPORARY TABLE IF EXISTS full_data;

CREATE TEMPORARY TABLE full_data AS
SELECT 
	reactions.`Content ID`,
    reactions.type AS "Reaction Type",
    LOWER(REPLACE (content.category,'"',''))AS category,
    types.sentiment,
    types.score,
    reactions.datetime
FROM
	reactions JOIN content ON reactions.`Content ID` = content.`Content ID`
	JOIN reaction_types AS types ON reactions.type = types.type
;

# Get insights from the data

SELECT * FROM full_data;

# Find the most categories that has the best reactions
SELECT
	category,
    SUM(score) AS total_score
FROM
	full_data
GROUP BY
	category
ORDER BY
	total_score DESC
;

# Look at the sentiments and find how does people feel about the contents
SELECT
    DISTINCT sentiment,
    COUNT(sentiment) AS total_reactions_by_sentiment
FROM
	full_data
GROUP BY
	sentiment
;

# Find how many posts has been posted for each month
SELECT
    DISTINCT MONTHNAME(datetime) AS month,
    COUNT(datetime) total_reactions_by_sentiment
FROM
	full_data
GROUP BY
	month
ORDER BY MONTH(datetime) ASC
;

