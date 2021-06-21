/*Q1a
The poetry in this database is the work of children in grades 1 through 5.  
    a. How many poets from each grade are represented in the data?  
    b. How many of the poets in each grade are Male and how many are Female? Only return the poets identified as Male or Female.  
    c. Do you notice any trends across all grades? */

SELECT COUNT(gr.id),
	         gr.name
FROM author AS a INNER JOIN grade AS gr
 ON gr.id=a.grade_id
JOIN gender AS ge
 ON a.gender_id=ge.id
GROUP BY gr.id;

--Q1b&c

SELECT COUNT(gr.id),
	         gr.name,
			 COUNT(CASE WHEN ge.name ='Male' THEN 1 END) AS Male,
	   		 COUNT(CASE WHEN ge.name ='Female' THEN 1 END) AS Female
FROM author AS a INNER JOIN grade AS gr
 ON gr.id=a.grade_id
JOIN gender AS ge
 ON a.gender_id=ge.id
GROUP BY gr.id
ORDER BY gr.id;

-- Female students outnumber Male students across all grades

/*Q2
Love and death have been popular themes in poetry throughout time. 
Which of these things do children write about more often? 
Which do they have the most to say about when they do? 
Return the **total** number of poems, their **average character count** for poems that mention **death** and 
poems that mention **love**. Do this in a single query. */

(SELECT
	   ROUND(AVG(char_count),2) AS avg_Char,
 		count(id)
FROM poem AS p
WHERE p.text ILIKE '%death%'
OR p.title ILIKE '%death%'
and p.text IS NOT NULL)
UNION
(SELECT
	   ROUND(AVG(char_count),2),
 		count(id)
FROM poem AS p
WHERE p.text ILIKE '%love%'
OR p.title ILIKE '%love%'
and p.text IS NOT NULL);

--226.79 Avg Words for poems about love, 4464 poems containing the word "love"
--342.53 Avg Words for poems about death, 86 poems containing the word "death"

/*Q3
a. Do longer poems have more emotional intensity compared to shorter poems?  
   Start by writing a query to return each emotion in the database with it's average intensity and character count.   
     - Which emotion is associated the longest poems on average?  
     - Which emotion has the shortest?  

b. Convert the query you wrote in part a into a CTE. 
   Then find the 5 most intense poems that express joy and whether they are to be longer or shorter than the average joy poem.   
     -  What is the most joyful poem about?  
     -  Do you think these are all classified correctly? */

SELECT e.name,
	   ROUND(AVG(pe.intensity_percent),2) AS avg_intensity,
	   ROUND(AVG(p.char_count),2) AS char_count 
	   
FROM poem_emotion AS pe INNER JOIN poem AS p
ON pe.poem_id = p.id
INNER JOIN emotion AS e
ON e.id = pe.emotion_id
group by e.name;

--Longest poems are Angry
--Joy has the greatest propensity for brevity

--Q3b

WITH cte AS (SELECT *
FROM poem_emotion AS pe INNER JOIN poem AS p
ON pe.poem_id = p.id
INNER JOIN emotion AS e
ON e.id = pe.emotion_id)

SELECT *
FROM cte
WHERE cte.emotion_id = 4
ORDER BY cte.intensity_percent DESC
LIMIT 7;

-- these poems are a little shorter on average
-- MOST JOYFUL POEM IS TITLED "My Dog"
-- I dont believe these are classified properly, looking at the poem "Dark":
	/*gone,  
	black, 
	depressed you can't see or hear any happiness for you can't see or hear anything. */
	
/*Q4
Compare the 5 most angry poems by 1st graders to the 5 most angry poems by 5th graders.  

	a. Which group writes the angreist poems according to the intensity score?  
    b. Who shows up more in the top five for grades 1 and 5, males or females?  
    c. Which of these do you like the best? */

(WITH cte AS (SELECT *
FROM poem_emotion AS pe INNER JOIN poem AS p
ON pe.poem_id = p.id
INNER JOIN emotion AS e
ON e.id = pe.emotion_id)

SELECT *
FROM cte
INNER JOIN author AS a
ON cte.author_id=a.id
WHERE cte.name ='Anger'
AND a.grade_id='5'
ORDER BY cte.intensity_percent DESC
LIMIT 5)

UNION ALL

(WITH cte AS (SELECT *
FROM poem_emotion AS pe INNER JOIN poem AS p
ON pe.poem_id = p.id
INNER JOIN emotion AS e
ON e.id = pe.emotion_id)

SELECT *
FROM cte
INNER JOIN author AS a
ON cte.author_id=a.id
WHERE cte.name ='Anger'
AND a.grade_id='1'
ORDER BY cte.intensity_percent DESC
LIMIT 5);

--fifth graders write much more intense poems
--females write angrier poems
--my favorite poem is:
--the pie,  a cinnamony breeze attacking you,  yum. 

/*Q5
5. Emily Dickinson was a famous American poet, who wrote many poems in the 1800s, including one about a caterpillar that begins:

	  	> A fuzzy fellow, without feet,
		> Yet doth exceeding run!
		> Of velvet, is his Countenance,
		> And his Complexion, dun!

	a. Examine the poets in the database with the name `emily`. Create a report showing the count of emilys by grade along with the distribution of emotions that characterize their work.  
	b. Export this report to Excel and create a visualization that shows what you have found. */

WITH cte AS (SELECT *
FROM poem_emotion AS pe INNER JOIN poem AS p
ON pe.poem_id = p.id
INNER JOIN emotion AS e
ON e.id = pe.emotion_id)

SELECT DISTINCT a.name,
				a.grade_id,
				COUNT(CASE WHEN cte.name = 'Joy' THEN 'Joy'END) AS joy_count,
				COUNT(CASE WHEN cte.name = 'Anger' THEN 'Anger'END) AS anger_count,
				COUNT(CASE WHEN cte.name = 'Fear' THEN 'Fear'END) AS fear_count,
				COUNT(CASE WHEN cte.name = 'Sadness' THEN 'Sadness'END) AS sadness_count
	   
FROM cte
INNER JOIN author AS a
ON cte.author_id=a.id
WHERE a.name ILIKE 'emily'
GROUP BY a.name, a.grade_id;

--284 emily poems (with collaborations)
--5 Distinct emilies (not group projects)

