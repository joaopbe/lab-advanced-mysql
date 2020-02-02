# Challenge 1

#Step 1
CREATE TEMPORARY TABLE publications.sales_royalty
SELECT titau.title_id, titau.au_id, (tit.price * sales.qty * tit.royalty /100 * titau.royaltyper / 100) AS sales_royalty 
FROM (titles tit 
JOIN titleauthor titau
ON tit.title_id = titau.title_id 

JOIN sales 
ON sales.title_id = tit.title_id)

#Step 2
CREATE TEMPORARY TABLE publications.sales_royalty_agg
SELECT sr.title_id, sr.au_id, SUM(sr.sales_royalty) AS sales_royalty_sum
FROM sales_royalty sr
GROUP BY sr.title_id, sr.au_id;


#Step 3 
SELECT sra.au_id, (SUM(sra.sales_royalty_sum) + SUM(tit.advance)) AS Total_Profits
FROM sales_royalty_agg sra

JOIN titles tit
ON sra.title_id = tit.title_id

GROUP BY sra.au_id

ORDER BY Total_Profits DESC

LIMIT 3;


# Challenge 2

#Step 1

SELECT titau.title_id, titau.au_id, (tit.price * sales.qty * tit.royalty /100 * titau.royaltyper / 100) AS sales_royalty 
FROM (titles tit 
JOIN titleauthor titau
ON tit.title_id = titau.title_id 

JOIN sales 
ON sales.title_id = tit.title_id)

#Step 2 

SELECT sr.title_id, sr.au_id, SUM(sr.sales_royalty) AS sales_royalty_sum
FROM 

(SELECT titau.title_id, titau.au_id, (tit.price * sales.qty * tit.royalty /100 * titau.royaltyper / 100) AS sales_royalty 
FROM (titles tit 
JOIN titleauthor titau
ON tit.title_id = titau.title_id 
JOIN sales 
ON sales.title_id = tit.title_id)) AS sr

GROUP BY sr.title_id, sr.au_id;

# Step 3

SELECT sra.au_id, (SUM(sra.sales_royalty_sum) + SUM(tit.advance)) AS Total_Profits
FROM

(SELECT sr.title_id, sr.au_id, SUM(sr.sales_royalty) AS sales_royalty_sum
FROM 
(SELECT titau.title_id, titau.au_id, (tit.price * sales.qty * tit.royalty /100 * titau.royaltyper / 100) AS sales_royalty 
FROM (titles tit 
JOIN titleauthor titau
ON tit.title_id = titau.title_id 
JOIN sales 
ON sales.title_id = tit.title_id)) AS sr
GROUP BY sr.title_id, sr.au_id) AS sra

JOIN titles tit
ON sra.title_id = tit.title_id
GROUP BY sra.au_id
ORDER BY Total_Profits DESC
LIMIT 3;

#Challenge 3

CREATE TABLE most_profiting_authors AS 
SELECT * FROM 

(SELECT sra.au_id, (SUM(sra.sales_royalty_sum) + SUM(tit.advance)) AS Total_Profits
FROM sales_royalty_agg sra

JOIN titles tit
ON sra.title_id = tit.title_id

GROUP BY sra.au_id) dertable;
