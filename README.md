# IndianMovieAnalysis

## Data cleaning, transforming, and analyzing the Indian Movie dataset.


I took an Indian Movie dataset from Kaggle and then normalized the table in the SQL server database. The goal is to improve integrity, reduce redundancy, and enhance data manipulation efficiency.

### Data Cleaning and Transformation:

The original "IndianMovies" table likely contained redundant information and inconsistencies. I have addressed these issues by:
* Splitting multi-valued columns (e.g., Genre) into separate tables.
* Creating new tables to group related data (e.g., Genres, Languages).
* Establishing relationships between tables using foreign keys.
* Removing duplicate data.
* Setting primary keys for each table.
* Cleaning and transforming data for consistency.
* Data Cleaning and Normalization Steps


### Data Exploration and Analysis: 

After cleaning and transforming the data, several queries were executed to explore the dataset and extract meaningful insights. Some of the queries answered are:

* Top 10 Rating Films based on Language?
* Top 10 Genres in the movies list?
* Top 10 Genres according to the languages?
* Top 10 Votes in the movies list?
* Top 10 Votes according to the languages?
* How many films are in each language in this dataset?
* What are the most genres in each language films (What language does what genres maximum)
* How many films have been released over the years?
* Which films got the highest Rating?
* Which films got the highest votes?
* Which language films got the highest Rating?
* Which language films got the highest Votes?
* What is the average run time acc. based on the Languages?
* Which films got the highest rating and votes?
* What is the average runtime for the films?
* What is the average number of films released in a year?



