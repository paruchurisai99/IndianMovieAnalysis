/*
Top 10 Rating Films based on Language?
Top 10 Genres in the movies list?
Top 10 Genres according to the languages?
Top 10 Votes in the movies list?
Top 10 Votes according to the languages?
How many films are there in this dataset in each language?
What are the most genres in each language films (What language does what genres maximum)
How many films are releasing over the years?
Which films got the highest Rating?
Which films got the highest votes?
Which language films got the highest Rating?
Which language films got the highest Votes?
What is the avg run time acc. based on the Languages?
Which films got the highest rating and votes?
What is the avg runtime for the films?
What is the avg no. of films releasing in a year*/



-- Top 10 Rated Films based on Language

WITH Ranked as
(
SELECT M.Movie_ID, M.Movie_name, M.Year, M.Rating_10, L.Language_name,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY M.Rating_10 DESC) as Rank
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON L.Language_ID = I.Language_ID
)
SELECT Movie_ID, Movie_name, Year, Rating_10, Language_name
FROM Ranked
WHERE Rank <=10
ORDER BY Language_name, Rating_10 DESC;

-- Top 10 Genres in the movies_list

SELECT TOP 10 G.Genre_list, COUNT(G.Genre_list) as Genre_count
FROM Genre G JOIN MovieGenres MG ON G.Genre_ID = MG.Genre_ID
JOIN Movies_List M ON MG.Movie_ID = M.Movie_ID
WHERE G.Genre_list <> '-'
GROUP BY G.Genre_list
ORDER BY Genre_count DESC

-- Top 10 Genres for each Language in the movies_list

WITH Ranked as
(
SELECT G.Genre_list, COUNT(G.Genre_list) as Genre_count, L.Language_name,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY COUNT(G.Genre_list) DESC) as Rank
FROM Genre G JOIN MovieGenres MG ON G.Genre_ID = MG.Genre_ID
JOIN Movies_List M ON MG.Movie_ID = M.Movie_ID
JOIN IndianMovies I ON I.Movie_ID = M.Movie_ID
JOIN Languages L ON L.Language_ID = I.Language_ID
WHERE G.Genre_list <> '-'
GROUP BY G.Genre_list, L.Language_name
)
SELECT Genre_list, Genre_count, Language_name
FROM Ranked
WHERE Rank <=10
ORDER BY Language_name ASC, Genre_count DESC

-- Top 10 Votes in the Movies_list

SELECT TOP 10 Movie_ID, Movie_name, Year, CONVERT(BIGINT, REPLACE(Votes, ',', '')) AS Votes
FROM Movies_List
WHERE TRY_CONVERT(BIGINT, REPLACE(Votes, ',', '')) IS NOT NULL  -- Filter out non-numeric or invalid values
ORDER BY CONVERT(BIGINT, REPLACE(Votes, ',', '')) DESC;

-- Top 10 Votes according to the Language in the Movies_list

WITH Ranked as
(
SELECT M.Movie_ID, M.Movie_name, M.Year, L.Language_name, CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) AS Votes,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) DESC) as Rank
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON L.Language_ID = I.Language_ID
WHERE TRY_CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) IS NOT NULL  -- Filter out non-numeric or invalid values
)
SELECT Movie_ID, Movie_name, Year, Language_name, Votes
FROM Ranked
WHERE Rank <=10
ORDER BY Language_name ASC, CONVERT(BIGINT, REPLACE(Votes, ',', '')) DESC;

-- Count of Films according to Language in the IndianMovies dataset

SELECT L.Language_name, COUNT(M.Movie_name) as Movies_count
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
GROUP BY L.Language_name
ORDER BY L.Language_name;

-- Most genres in each language films (What genre is the maximum for each language)

WITH Ranked as
(
SELECT L.Language_name, COUNT(G.Genre_list) as Genre_count, G.Genre_list,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY COUNT(G.Genre_list) DESC) as Rank
FROM Genre G JOIN MovieGenres MG ON G.Genre_ID = MG.Genre_ID
JOIN Movies_List M ON MG.Movie_ID = M.Movie_ID
JOIN IndianMovies I ON I.Movie_ID = M.Movie_ID
JOIN Languages L ON L.Language_ID = I.Language_ID
WHERE G.Genre_list <> '-'
GROUP BY G.Genre_list, L.Language_name
)
SELECT Language_name, Genre_count, Genre_list
FROM Ranked
WHERE Rank <=1
ORDER BY Language_name ASC, Genre_count DESC

-- How many films are releasing over the years?

SELECT M.Year, COUNT(M.Movie_name) as Film_count
FROM Movies_List M
WHERE M.Year IS NOT NULL AND M.Year LIKE '[0-9][0-9][0-9][0-9]'
GROUP BY M.Year
ORDER BY M.Year

-- Which films got the highest Rating?

SELECT TOP 10 M.Movie_ID, M.Movie_name, M.Rating_10, L.Language_name
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
ORDER BY M.Rating_10 DESC

-- Which films got the highest votes?

SELECT TOP 10 M.Movie_ID, M.Movie_name, CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) AS Votes, L.Language_name
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
WHERE TRY_CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) IS NOT NULL
ORDER BY CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) DESC

-- What are the highest rating films for each Language?

WITH Ranked as
(
SELECT M.Movie_ID, M.Movie_name, M.Rating_10, L.Language_name,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY M.Rating_10 DESC) as Rank
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
)
SELECT Movie_ID, Movie_name, Rating_10, Language_name
FROM Ranked
WHERE Rank<=1
ORDER BY Language_name ASC, Rating_10 DESC


-- What are the highest voted films for each Language?

WITH Ranked as
(
SELECT M.Movie_ID, M.Movie_name, CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) AS Votes, L.Language_name,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) DESC) as Rank
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
WHERE TRY_CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) IS NOT NULL
)
SELECT Movie_ID, Movie_name, Votes, Language_name
FROM Ranked
WHERE Rank <=1
ORDER BY Language_name ASC, CONVERT(BIGINT, REPLACE(Votes, ',', '')) DESC

-- What is the avg run time of films for each Language?

SELECT L.Language_name, 
AVG(CAST(LEFT(REPLACE(Timing_min, ',', ''), CHARINDEX(' ', REPLACE(Timing_min, ',', ''))) AS int)) as AvgRuntime
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
WHERE ISNUMERIC(LEFT(REPLACE(Timing_min, ',', ''), CHARINDEX(' ', REPLACE(Timing_min, ',', '')))) = 1
GROUP BY L.Language_name
ORDER BY L.Language_name ASC;

-- Which films got the highest rating and votes?

WITH Ranked as
(
SELECT M.Movie_ID, M.Movie_name, M.Rating_10, CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) AS Votes, L.Language_name,
ROW_NUMBER () OVER (PARTITION BY L.Language_name ORDER BY M.Rating_10 DESC, CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) DESC) as Rank
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
WHERE TRY_CONVERT(BIGINT, REPLACE(M.Votes, ',', '')) IS NOT NULL
)
SELECT Movie_ID, Movie_name, Rating_10, Votes, Language_name
FROM Ranked
WHERE Rank <=10
ORDER BY Language_name ASC, Rating_10 DESC, CONVERT(BIGINT, REPLACE(Votes, ',', '')) DESC;


-- What is the avg runtime for the films?
 
SELECT
AVG(CAST(LEFT(REPLACE(Timing_min, ',', ''), CHARINDEX(' ', REPLACE(Timing_min, ',', ''))) AS int)) as AvgRuntime
FROM Movies_List M JOIN IndianMovies I ON M.Movie_ID = I.Movie_ID
JOIN Languages L ON I.Language_ID = L.Language_ID
WHERE ISNUMERIC(LEFT(REPLACE(Timing_min, ',', ''), CHARINDEX(' ', REPLACE(Timing_min, ',', '')))) = 1;


-- What is the avg no. of films releasing over the years?

WITH Film_count AS
(
SELECT M.Year, COUNT(M.Movie_name) as Film_count
FROM Movies_List M
WHERE M.Year IS NOT NULL AND M.Year LIKE '[0-9][0-9][0-9][0-9]'
GROUP BY M.Year
)
SELECT AVG(Film_count) as AvgFilmsperYear
FROM Film_count;


-- What is the avg Rating of films releasing over the years?

SELECT AVG(CONVERT(float, M.Rating_10)) AS AvgRating
FROM Movies_List M
WHERE M.Year IS NOT NULL AND M.Year LIKE '[0-9][0-9][0-9][0-9]'
AND TRY_CONVERT(float, M.Rating_10) IS NOT NULL; -- Filter out non-numeric values


-- What is the avg Voting of films releasing over the years?

SELECT AVG(CONVERT(float, M.Votes)) AS AvgVoting
FROM Movies_List M
WHERE M.Year IS NOT NULL AND M.Year LIKE '[0-9][0-9][0-9][0-9]'
AND TRY_CONVERT(float, M.Votes) IS NOT NULL; -- Filter out non-numeric values


-- What is the max genre of films releasing over the years?

WITH Ranked AS
(
SELECT G.Genre_list, COUNT(*) AS Genre_count
FROM Genre G 
JOIN MovieGenres MG ON G.Genre_ID = MG.Genre_ID
WHERE G.Genre_list <> '-'
GROUP BY G.Genre_list
)
SELECT TOP 1 Genre_list
FROM Ranked
ORDER BY Genre_count DESC;