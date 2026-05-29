-- =========================================
-- EMPLOYEE SURVEY ANALYSIS USING POSTGRESQL
-- =========================================

-- =========================================
-- 1. CREATE TABLE
-- =========================================

-- # Why CREATE TABLE is used?
-- CREATE TABLE is used to create a new table
-- to store employee survey data.

-- # Purpose of Columns:
-- response_ID     -> Unique survey response ID
-- status          -> Employee status
-- department      -> Department name
-- director        -> Director role indicator
-- manager         -> Manager role indicator
-- supervisor      -> Supervisor role indicator
-- staff           -> Staff role indicator
-- question        -> Survey question
-- response        -> Employee rating/score
-- response_text   -> Employee feedback text

CREATE TABLE employee_survery (

    response_ID INT,

    status VARCHAR(100),

    department VARCHAR(50),

    director INT,

    manager INT,

    supervisor INT,

    staff INT,

    question VARCHAR(100),

    response INT,

    response_text VARCHAR(100)

);

-- =========================================
-- 2. DISPLAY COMPLETE TABLE DATA
-- =========================================

-- # Why SELECT * is used?
-- SELECT * displays all records from the table.

-- # Purpose:
-- Used to verify imported data and check table values.

SELECT *
FROM employee_survery;

-- =========================================
-- 3. TOTAL RESPONSES USING CTE
-- =========================================

-- # Why COUNT(*) is used?
-- COUNT(*) counts total number of responses.

-- # Why CTE is used?
-- CTE improves readability and breaks query into steps.

WITH total_response_cte AS (

    SELECT COUNT(*) AS total_responses

    FROM employee_survery

)

SELECT *
FROM total_response_cte;

-- =========================================
-- 4. DEPARTMENT-WISE TOTAL RESPONSES
-- =========================================

-- # Why GROUP BY is used?
-- GROUP BY groups records department-wise.

-- # Why ORDER BY is used?
-- ORDER BY sorts data from highest to lowest.

-- # Purpose:
-- Find departments with highest employee participation.

WITH department_response_cte AS (

    SELECT

        department,

        COUNT(*) AS total_responses

    FROM employee_survery

    GROUP BY department

)

SELECT *
FROM department_response_cte

ORDER BY total_responses DESC;

-- =========================================
-- 5. DEPARTMENT-WISE AVERAGE SATISFACTION
-- =========================================

-- # Why AVG() is used?
-- AVG() calculates average response score.

-- # Purpose:
-- Identify happiest departments.

WITH department_avg_cte AS (

    SELECT

        department,

        AVG(response) AS avg_score

    FROM employee_survery

    GROUP BY department

)

SELECT *
FROM department_avg_cte

ORDER BY avg_score DESC;

-- =========================================
-- 6. ROLE-BASED SATISFACTION ANALYSIS
-- =========================================

-- # Why CASE is used?
-- CASE converts role indicators into readable role names.

-- # Purpose:
-- Compare satisfaction between:
-- Director
-- Manager
-- Supervisor
-- Staff

WITH role_analysis_cte AS (

    SELECT

        CASE

            WHEN director = 1 THEN 'Director'

            WHEN manager = 1 THEN 'Manager'

            WHEN supervisor = 1 THEN 'Supervisor'

            ELSE 'Staff'

        END AS role,

        AVG(response) AS avg_score

    FROM employee_survery

    GROUP BY role

)

SELECT *
FROM role_analysis_cte

ORDER BY avg_score DESC;

-- =========================================
-- 7. TOP 5 HIGHEST-RATED QUESTIONS
-- =========================================

-- # Why LIMIT is used?
-- LIMIT displays only top 5 records.

-- # Purpose:
-- Identify organizational strengths.

WITH top_questions_cte AS (

    SELECT

        question,

        AVG(response) AS avg_score

    FROM employee_survery

    GROUP BY question

)

SELECT *
FROM top_questions_cte

ORDER BY avg_score DESC

LIMIT 5;

-- =========================================
-- 8. LOWEST-RATED QUESTIONS
-- =========================================

-- # Why ASCENDING ORDER is used?
-- ASC shows lowest scores first.

-- # Purpose:
-- Identify employee dissatisfaction areas.

WITH low_questions_cte AS (

    SELECT

        question,

        AVG(response) AS avg_score

    FROM employee_survery

    GROUP BY question

)

SELECT *
FROM low_questions_cte

ORDER BY avg_score ASC

LIMIT 5;

-- =========================================
-- 9. CREATE VIEW USING CTE
-- =========================================

-- # Why VIEW is used?
-- VIEW stores query virtually for reuse.

-- # Benefit:
-- Avoid writing same query repeatedly.

CREATE VIEW department_performance AS

WITH department_view_cte AS (

    SELECT

        department,

        AVG(response) AS avg_score

    FROM employee_survery

    GROUP BY department

)

SELECT *
FROM department_view_cte;

-- =========================================
-- 10. TOP 3 DEPARTMENTS USING RANK()
-- =========================================

-- # Why RANK() is used?
-- RANK() gives ranking based on average score.

-- # Why WINDOW FUNCTION is used?
-- Used for advanced analytical calculations.

-- # Purpose:
-- Find top-performing departments.

WITH department_rank_cte AS (

    SELECT

        department,

        AVG(response) AS avg_score,

        RANK() OVER (

            ORDER BY AVG(response) DESC

        ) AS rank

    FROM employee_survery

    GROUP BY department

)

SELECT *
FROM department_rank_cte

WHERE rank <= 3;

-- =========================================
-- 11. LEADERSHIP IMPACT ANALYSIS
-- =========================================

-- # Purpose:
-- Analyze satisfaction score across different roles.

-- # Insight:
-- Compare satisfaction between leadership and staff.

WITH leadership_analysis_cte AS (

    SELECT

        CASE

            WHEN director = 1 THEN 'Director'

            WHEN manager = 1 THEN 'Manager'

            WHEN supervisor = 1 THEN 'Supervisor'

            ELSE 'Staff'

        END AS employee_role,

        AVG(response) AS avg_score

    FROM employee_survery

    WHERE response IS NOT NULL

    GROUP BY employee_role

)

SELECT *

FROM leadership_analysis_cte

ORDER BY avg_score DESC;


-- =========================================
-- ABOUT CTE (COMMON TABLE EXPRESSION)
-- =========================================

-- # Full Form:
-- CTE = Common Table Expression

-- # Syntax:

-- WITH cte_name AS (
--     query
-- )
-- SELECT * FROM cte_name;

-- =========================================
-- ADVANTAGES OF CTE
-- =========================================

-- # Better Readability
-- Makes query easy to understand.

-- # Cleaner Queries
-- Breaks complex queries into smaller parts.

-- # Reusable Logic
-- Avoids repeated code.

-- # Easy Debugging
-- Helps in step-by-step analysis.

-- =========================================
-- TECHNOLOGIES USED
-- =========================================

-- PostgreSQL
-- pgAdmin
-- SQL
-- CTE
-- Window Functions
-- Excel

-- =========================================
-- PROJECT END
-- =========================================