------ 	Q1 CODE -----------
--update NA values
update continent_map
set country_code = 'N/A'
where country_code = 'NA';

select country_code, COUNT(*) 
from continent_map
GROUP BY country_code
HAVING COUNT(country_code) > 1
ORDER BY (case when "country_code" = 'N/A'
then 1 else 2 end),
"country_code" ASC;



---Q2 CODE ----
--Compute growth 

--the idea here is to create two identical data tables (one for 2011 and one for 2012) that contain all of the necessary columns. The 
--data tables are created by joining the shared keys (country and continental codes) across all of the existing data tables.
--Once the two datasets are created, I want to create a final data table to be used as the final product. I will use the "gdp_per_capita" 
--columns to compute the Growth Percent value between 2011 and 2012 for the final data table. I used INNER JOINS because I only wanted to 
--keep the codes that appeared in both tables.


--2011 numbers 
CREATE TABLE q2_table_2011 as(
SELECT countries.country_code,country_name,continents.continent_code,continent_name,year,gdp_per_capita FROM countries
INNER JOIN  continent_map on countries.country_code = continent_map.country_code
INNER JOIN continents on continents.continent_code = continent_map.continent_code
INNER JOIN per_capita on countries.country_code = per_capita.country_code
WHERE year in (2011));

--2012 numbers
CREATE TABLE q2_table_2012 as(
select countries.country_code,country_name,continents.continent_code,continent_name,year,gdp_per_capita FROM countries
INNER JOIN  continent_map on countries.country_code = continent_map.country_code
INNER JOIN continents on continents.continent_code = continent_map.continent_code
INNER JOIN per_capita on countries.country_code = per_capita.country_code
WHERE year in (2012));

--final table 
CREATE TABLE q2_final_table as (select countries.country_code,country_name,continent_name FROM countries
INNER JOIN  continent_map on countries.country_code = continent_map.country_code
INNER JOIN continents on continents.continent_code = continent_map.continent_code
INNER JOIN per_capita on countries.country_code = per_capita.country_code);

--add additional column for growth percent 
ALTER TABLE q2_answer_table
ADD COLUMN Gowth_Percent INTEGER;

--compute growth percent
UPDATE q2_answer_table set Growth_Percent = ((q2_table_2012.gdp_per_capita - q2_table_2011.gdp_per_capita)/(q2_table_2011.gdp_per_capita))
from q2_table_2012,q2_table_2011

--I moved onto the next question here due to time constraints, but main issue is that the 2011 table contains zero values in the GDP column and I am 
--getting "division by zero" errors for those counties. To fix this I would remove those countries from the analysis and redo the calculations.

--Continuing on with the final product I would order the Growth Percentage column by ascending order and then create an additional "Rank" column. The 
--Rank column would be filled in using a SEQUENCE or other method of creating sequential integers. Finally, I would select the top 10 countries by querying 
--the Rank column (<= 10). If that didn't work I could also use the LIMIT function.




------Q3 CODE------
-- For this problem I needed to subset the per capita dataset by year and continent, which required joining the cointental_code 
--onto the per_capita data table and selecting only values for 2012. After that, I created a final product dataset for the three percentage 
--values. I then updated the three values by taking the sum of the subsetted continental GDP and dividing by the sum of the total GDP. 


CREATE TABLE q3_table as (select per_capita.country_code,year,gdp_per_capita,continent_code from per_capita
INNER JOIN  continent_map on per_capita.country_code = continent_map.country_code
WHERE year = 2012)

CREATE TABLE q3_final_product(
North_America INTEGER,
Europe INTEGER,
Rest_of_the_World INTEGER);

UPDATE q3_final_product set north_america = (((SELECT SUM(gdp_per_capita) from q3_table where continent_code = 'NA')/(SELECT SUM(gdp_per_capita) FROM q3_table))*100)
from q3_table;

UPDATE q3_final_product set europe = (((SELECT SUM(gdp_per_capita) from q3_table where continent_code = 'EU')/(SELECT SUM(gdp_per_capita) FROM q3_table))*100)
from q3_table;

UPDATE q3_final_product set rest_of_the_world = (((SELECT SUM(gdp_per_capita) from q3_table where continent_code not in ('NA','EU'))/(SELECT SUM(gdp_per_capita) FROM q3_table))*100)
from q3_table;

-- I moved on from this question due to time constraints but I feel like I'm very close. I am repeatedly getting a syntax error in the UPDATE queries,
--and it seems to be an issue with the mathematical operators. This was the last step in creating the final product, so I'm sure that given more time I could
--figure out the exact issue and complete the task. 





---Q4 CODE-------------
--I first created a table to store all of the necessary data by joining the per capita table and the continent_map table through the country_code
--key. After consolidating the data, I computed the annual average GDP for each year and continent using GROUP BY statements.

CREATE TABLE q4_table as (SELECT per_capita.country_code,year,gdp_per_capita,continent_code from per_capita
INNER JOIN  continent_map on per_capita.country_code = continent_map.country_code);

Select year, continent_code, AVG(gdp_per_capita)
from q4_table
GROUP BY year, continent_code
order by year;


-----------Q5 CODE-----------
-- I copied the same data set created for problem 5, although I could have just reused the existing table. 

--for the median, I chose to use the 50th percentile value from the distribution of GDP values for each continent for each year

CREATE TABLE q5_table as (SELECT per_capita.country_code,year,gdp_per_capita,continent_code from per_capita
INNER JOIN  continent_map on per_capita.country_code = continent_map.country_code);


SELECT year, continent_code, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY gdp_per_capita) 
FROM q5_table 
GROUP BY year, continent_code
order by year;




