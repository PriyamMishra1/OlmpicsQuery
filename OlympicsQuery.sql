/****** Total Number of different games played  ******/
SELECT COUNT (distinct games) as total_olympic_games
     FROM Olympics_History;

/****Viewing different games played sorted by YEAR ****/
SELECT DISTINCT YEAR,
	 SEASON,CITY 
	 FROM Olympics_History
	 ORDER BY YEAR

/****Number of teams that played olympics each game ****/

SELECT COUNT(Distinct Team),Games
	FROM Olympics_History
	GROUP BY Games
	ORDER BY Games

/****Which country has participated in all of the olympics****/

SELECT DISTINCT Team
	FROM Olympics_History
	GROUP BY Team
	HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM Olympics_History)

/***The sport which was played in all summer olympics**/

SELECT DISTINCT sport
	FROM (
    SELECT DISTINCT Games, sport
    FROM Olympics_History
    WHERE Season = 'Summer'
	) AS T
	GROUP BY sport
	HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games) FROM Olympics_History WHERE Season = 'Summer')
	ORDER BY sport;

/****Which year saw the highest and lowest no of countries participation***/

SELECT Games AS Year, COUNT(DISTINCT Team) AS CountryCount
	FROM Olympics_History
	GROUP BY Games
	HAVING COUNT(DISTINCT Team) = (SELECT MAX(CountryCount) FROM (SELECT COUNT(DISTINCT Team) AS CountryCount FROM Olympics_History GROUP BY Games) AS T)
	OR COUNT(DISTINCT Team) = (SELECT MIN(CountryCount) FROM (SELECT COUNT(DISTINCT Team) AS CountryCount FROM Olympics_History GROUP BY Games) AS T)

/***Which sports were played only Once***/
SELECT sport
	FROM Olympics_History
	GROUP BY sport
	HAVING COUNT(DISTINCT Games) = 1


/***The total number of sports played each year***/

SELECT Games AS Year, COUNT(DISTINCT sport) AS TotalSports
	FROM Olympics_History
	GROUP BY Games
	ORDER BY Games

/***10 oldest athletes to win a gold medal****/

SELECT TOP 10 Name, Age, Year, Medal
	FROM Olympics_History
	WHERE Medal = 'Gold'
	AND AGE not LIKE 'NA' 
	ORDER BY Age DESC

/****Ratio of male to female athletes by year***/

SELECT
    Year,
    SUM(CASE WHEN SEX = 'M' THEN 1 ELSE 0 END) AS MaleCount,
    SUM(CASE WHEN SEX = 'F' THEN 1 ELSE 0 END) AS FemaleCount,
    CASE WHEN SUM(CASE WHEN SEX = 'F' THEN 1 ELSE 0 END) = 0 THEN NULL
         ELSE CAST(SUM(CASE WHEN SEX = 'M' THEN 1 ELSE 0 END) AS FLOAT) / SUM(CASE WHEN SEX = 'F' THEN 1 ELSE 0 END)
    END AS Ratio
	FROM Olympics_History
	GROUP BY Year
	ORDER BY Year

/**Top 10 athletes who won the most number of Gold Medals**/ 
SELECT TOP 10 NAME, COUNT(*) AS GoldMedalCount
	FROM Olympics_History
	WHERE Medal = 'Gold'
	GROUP BY NAME
	ORDER BY GoldMedalCount DESC

/**Top 10 Athletes who won the most number of Medals**/
SELECT TOP 10 NAME, COUNT(*) AS MedalCount
	FROM Olympics_History
	GROUP BY Name
	ORDER BY MedalCount DESC

/***Top 10 most successful Countries with most medals***/
SELECT TOP 10 Team AS Country, COUNT(*) AS MedalCount
	FROM Olympics_History
	WHERE Medal IS NOT NULL
	GROUP BY Team
	ORDER BY COUNT(*) DESC

/** Medals won by each Country**/

SELECT Team AS Country,
			COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS GoldCount,
			COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS SilverCount,
			COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS BronzeCount
	FROM Olympics_History
	WHERE Medal IS NOT NULL
	GROUP BY Team

/** Medals won by each Country in order of Year of Olympics**/
SELECT Year,
       Team AS Country,
		   COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS GoldCount,
		   COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS SilverCount,
		   COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS BronzeCount
	FROM Olympics_History
	WHERE Medal IS NOT NULL
	GROUP BY Year, Team
	ORDER BY Year, Country

/**  Countries that won the most gold, most silver and most bronze medals in each olympic games. **/
SELECT Year,
       MAX(GoldCount) AS MostGold,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Gold' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostGold,
       MAX(SilverCount) AS MostSilver,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Silver' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostSilver,
       MAX(BronzeCount) AS MostBronze,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Bronze' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostBronze
FROM (
    SELECT Year, Team,
           COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS GoldCount,
           COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS SilverCount,
           COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS BronzeCount
    FROM Olympics_History
    WHERE Medal IS NOT NULL
    GROUP BY Year, Team
	) AS M
	GROUP BY Year
	ORDER BY Year

/**Countries that won the most gold, most silver, most bronze medals and the most medals in each olympic games**/
SELECT Year,
       MAX(GoldCount) AS MostGold,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Gold' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostGold,
       MAX(SilverCount) AS MostSilver,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Silver' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostSilver,
       MAX(BronzeCount) AS MostBronze,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year AND Medal = 'Bronze' GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostBronze,
       MAX(TotalCount) AS MostMedals,
       (SELECT TOP 1 Team FROM Olympics_History WHERE Year = M.Year GROUP BY Team ORDER BY COUNT(*) DESC) AS CountryMostMedals
FROM (
    SELECT Year, Team,
           COUNT(CASE WHEN Medal = 'Gold' THEN 1 END) AS GoldCount,
           COUNT(CASE WHEN Medal = 'Silver' THEN 1 END) AS SilverCount,
           COUNT(CASE WHEN Medal = 'Bronze' THEN 1 END) AS BronzeCount,
           COUNT(*) AS TotalCount
    FROM Olympics_History
    WHERE Medal IS NOT NULL
    GROUP BY Year, Team
	) AS M
	GROUP BY Year
	ORDER BY Year

/****Countries that have never won gold medal but have won silver/bronze medals***/
SELECT DISTINCT Team
FROM Olympics_History
WHERE Team NOT IN (
    SELECT Team
    FROM Olympics_History
    WHERE Medal = 'Gold'
	)
	AND Medal IN ('Silver', 'Bronze')


