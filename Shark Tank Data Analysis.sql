#SHOW ALL data
SELECT * FROM shark_tank_data;

#Show total number of episodes
SELECT COUNT(DISTINCT EpNo) FROM shark_tank_data;

#Show total number of pitches
SELECT COUNT(DISTINCT Brand) FROM shark_tank_data;

#converted pitches
SELECT COUNT(Deal) FROM shark_tank_data WHERE Deal<>'No Deal';

SELECT SUM(a.converted_or_not_converted) AS pitches_convereted,COUNT(*) AS total_pitches FROM(
SELECT Amount_Invested_lakhs, CASE WHEN Amount_Invested_lakhs>0 THEN 1 ELSE 0 END AS converted_or_not_converted FROM shark_tank_data)a;

#percentage of pitches converted
SELECT (SUM(a.converted_or_not_converted)/COUNT(*))*100 AS percenatge_of_pitches_converted FROM(
SELECT Amount_Invested_lakhs, CASE WHEN Amount_Invested_lakhs>0 THEN 1 ELSE 0 END AS converted_or_not_converted FROM shark_tank_data)a;

#total number of male participants
SELECT SUM(Male) AS total_male FROM shark_tank_data;

#total number of female participants
SELECT SUM(Female) AS total_male FROM shark_tank_data;

#gender ratio
SELECT SUM(Female)/SUM(Male) AS gender_ratio_female_to_male FROM shark_tank_data;

#total amount invested
SELECT SUM(Amount_Invested_lakhs)*100000 AS total_amount_invested FROM shark_tank_data;

#average equity taken
SELECT AVG(Equity_Taken) AS avg_equity_taken FROM shark_tank_data WHERE Equity_taken>0;

SELECT AVG(e.Equity_Taken) FROM(
SELECT * FROM shark_tank_data WHERE Equity_Taken>0)a;

#highest deal taken/highest amount invested
SELECT MAX(Amount_Invested_lakhs)*100000 AS highest_amount_invested FROM shark_tank_data;

#highest equity taken
SELECT MAX(Equity_Taken)*100000 AS highest_equity_taken FROM shark_tank_data;

#number of deals having at least one women enterpreneur
SELECT COUNT(*) AS deals_having_atleast_one_women FROM shark_tank_data WHERE Female>0;

SELECT SUM(a.female_count_deals) AS deals_having_atleast_one_women from
(SELECT Female, CASE WHEN Female>0 THEN 1 ELSE 0 END AS female_count_deals FROM shark_tank_data)a;

#pitches converted having atleast one woman
SELECT COUNT(*)AS deals_converted_having_atleast_one_women FROM shark_tank_data WHERE Deal<>'No Deal' AND Female>0;

SELECT SUM(b.female_count) AS deals_converted_having_atleast_one_women FROM 
(SELECT a.* ,CASE WHEN a.Female>0 THEN 1 ELSE 0 END AS female_count FROM
(SELECT * FROM shark_tank_data WHERE Deal<>'No Deal')a)b;

#average number of team members
SELECT AVG(Team_members) AS avg_team_members FROM shark_tank_data;

#amount invested per deal
SELECT AVG(a.Amount_Invested_lakhs)*100000 AS amount_invested_per_deal FROM 
(SELECT * FROM shark_tank_data WHERE Deal<>'No Deal')a;

#number of contestants according to age group/ average age group of contestants
SELECT Avg_age,COUNT(Avg_age) AS avg_count FROM shark_tank_data GROUP BY Avg_age ORDER BY avg_count;

#location group of contestants
SELECT Location,COUNT(Location) AS avg_count FROM shark_tank_data GROUP BY Location ORDER BY avg_count;

#group of contestants according to sector
SELECT Sector,COUNT(Sector) AS avg_count FROM shark_tank_data GROUP BY Sector ORDER BY avg_count DESC;

#partner deals
SELECT Partners, COUNT(Partners) AS group_count FROM shark_tank_data WHERE Partners<>'-' GROUP BY Partners ORDER BY group_count DESC; 

#total deals, totalamount invested and average equity taken by Ashneer
SELECT a.keyy,a.total_deals_invested,b.total_amount_invested,b.avg_equity_taken FROM (

	(SELECT 'Ashneer' as keyy, SUM(c.Ashneer_Amount_Invested) AS total_amount_invested , AVG(c.Ashneer_Equity_Taken) as avg_equity_taken FROM(
		SELECT * FROM  shark_tank_data WHERE Ashneer_Equity_Taken>0)c)b
	INNER JOIN (

	(SELECT 'Ashneer' as keyy,COUNT(Ashneer_Amount_Invested) AS total_deals_invested FROM shark_tank_data WHERE Ashneer_Amount_Invested>0)a)
	ON a.keyy=b.keyy);
	
#startup in which the highest amount has been invested in each domain/sector
SELECT Sector, MAX(Amount_Invested_lakhs) AS max_amt FROM shark_tank_data GROUP BY Sector order by max_amt DESC;

SELECT c.* FROM 
(SELECT Brand,Amount_Invested_lakhs,RANK() over(PARTITION BY Sector ORDER BY Amount_Invested_lakhs DESC ) AS rnk FROM shark_tank_data)c 
WHERE c.rnk=1 AND Amount_Invested_lakhs<>0;