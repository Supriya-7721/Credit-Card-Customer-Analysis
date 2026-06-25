--- DATA INSPECTION
USE credit_card_analysis;
SHOW TABLES;
SELECT * FROM cards_data LIMIT 10;
DESCRIBE cards_data;
SET SQL_SAFE_UPDATES = 0;
UPDATE cards_data SET credit_limit = REPLACE(REPLACE(credit_limit, '$',''),',','');
SET SQL_SAFE_UPDATES = 1;
SELECT COUNT(*) AS total_rows FROM cards_data;
--- DATA INSPECTION
SELECT SUM(client_id IS NULL) AS null_client_id FROM cards_data;
SELECT SUM(card_brand IS NULL) AS null_card_brand FROM cards_data;
SELECT SUM(card_type IS NULL) AS null_card_type FROM cards_data;
SELECT client_id, card_number, COUNT(*) AS duplicate_count FROM cards_data GROUP BY client_id, card_number HAVING COUNT(*) > 1;
--- BASIC KPIs
SELECT COUNT(DISTINCT client_id) AS total_customers FROM cards_data;
SELECT COUNT(*) AS total_cards FROM cards_data;
--- CARD ANALYSIS
SELECT card_brand, COUNT(*) AS total_cards FROM cards_data GROUP BY card_brand ORDER BY total_cards DESC;
SELECT card_type, COUNT(*) AS total_cards FROM cards_data GROUP BY card_type;
SELECT ROUND(AVG(credit_limit),2) AS avg_credit_limit FROM cards_data;
SELECT MAX(credit_limit) AS max_credit_limit FROM cards_data;
--- CUSTOMER BEHAVIOUR ANALYSIS
SELECT client_id, COUNT(*) AS total_cards FROM Cards_data GROUP BY client_id HAVING COUNT(*) > 1 ORDER BY total_cards DESC;
SELECT client_id, credit_limit FROM cards_data ORDER BY credit_limit DESC LIMIT 10;
--- CHIP ANALYSIS
SELECT has_chip, COUNT(*) total_cards FROM cards_data GROUP BY has_chip;
--- HIGH VALUE CARDS
SELECT * FROM cards_data WHERE credit_limit > 10000;
--- CREDIT LIMIT RANGE ANALYSIS
SELECT
CASE
    WHEN CAST(REPLACE(REPLACE(credit_limit,'$',''),',','') AS UNSIGNED) < 5000
        THEN 'Low Limit'
    WHEN CAST(REPLACE(REPLACE(credit_limit,'$',''),',','') AS UNSIGNED) BETWEEN 5000 AND 10000
        THEN 'Medium Limit'
    ELSE 'High Limit'
END AS limit_category,
COUNT(*) AS total_cards
FROM cards_data
GROUP BY limit_category;
--- TOP 10 HIGHEST CREDIT LIMIT CARDS
SELECT client_id, card_brand, card_type, credit_limit FROM cards_data ORDER BY credit_limit DESC LIMIT 10;
--- BRAND WISE TOTAL CARDS & AVERAGE LIMIT
SELECT card_brand, COUNT(*) AS total_cards, ROUND(AVG(credit_limit),2) AS avg_limit FROM cards_data GROUP BY card_brand ORDER BY avg_limit DESC;
--- CARD TYPE VS CREDIT LIMIT
SELECT card_type, ROUND(AVG(credit_limit),2) AS avg_limit FROM cards_data GROUP BY card_type ORDER BY avg_limit DESC;
--- BRAND + TYPE COMBINATION ANALYSIS
SELECT card_brand, card_type, COUNT(*) AS total_cards FROM cards_data GROUP BY card_brand, card_type ORDER BY total_cards DESC; 
--- CHIP ADOPTION RATE
SELECT has_chip, COUNT(*) AS total_cards, ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM cards_data),2) AS percentage FROM cards_data GROUP BY has_chip;
--- CUSTOMERS WITH MOST CARDS
SELECT client_id, COUNT(*) AS total_cards FROM cards_data GROUP BY client_id ORDER BY total_cards DESC LIMIT 10;
--- CREDIT LIMIT DISTRIBUTION BY BRAND
SELECT card_brand, MIN(credit_limit) AS min_limit, MAX(credit_limit) AS max_limit, ROUND(AVG(credit_limit),2) AS avg_limit FROM cards_data GROUP BY card_brand;

