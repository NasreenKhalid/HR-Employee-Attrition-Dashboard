-- HR/EMPLOYEE DASHBOARD 
select * from employees_n
select * from departments_n
select * from employee_department_n
select * from employee_performance_n
-- check duplicates
select employee_id, count(*)
from employees_n
group by employee_id
having count(*) > 1 

select employee_id, count(*)
from employee_department_n
group by employee_id
having count(*) > 1


-- No duplicates in employees, departments,employee_department_n,
-- employee_performance_n  table 
-- No outstanding data quality issues
-- Q1. How many employees are in the dataset, : 1200
-- How are they distributed across departments? 
-- department,count(*)
-- HR,95
-- "Customer Service",214
-- Marketing,116
-- Operations,244
-- Sales,261
-- Finance,115
-- IT,155

-- select count(*) from employees_n
-- where overtime IS NULL

-- What is the overall attrition rate?

select 
CONCAT(ROUND((SUM(CASE WHEN attrition = 'Yes' then 1 else 0 END)/count(*)) * 100.0,2),'%') as Attrition_Rate
from employees_n
-- Attrition rate is 17.42%

-- Which departments have the highest attrition?
select department,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/count(*) * 100,2),'%') as depart_attr_rate
from employees_n
group by department

-- department,depart_attr_rate
-- HR,20.00%
-- "Customer Service",19.16%
-- Marketing,19.83%
-- Operations,15.57%
-- Sales,15.71%
-- Finance,15.65%
-- IT,18.71%

-- Is attrition different across job roles?
select job_role,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/count(*) * 100,2),'%') as depart_attr_rate
from employees_n
group by job_role
job_role,depart_attr_rate
-- "HR Specialist",18.42%
-- "Customer Service Manager",19.35%
-- "Marketing Specialist",19.57%
-- "Operations Manager",12.05%
-- "Sales Executive",16.85%
-- "Sales Manager",15.63%
-- "Account Executive",14.47%
-- "Customer Service Lead",19.51%
-- Accountant,16.13%
-- "IT Manager",17.65%
-- "Data Analyst",20.00%
-- "Finance Manager",21.43%
-- "Operations Coordinator",19.18%
-- "HR Manager",21.21%
-- "IT Support Specialist",23.08%
-- "Operations Analyst",15.91%
-- Recruiter,20.83%
-- "Financial Analyst",9.52%
-- "Marketing Manager",17.86%
-- "Customer Service Representative",18.57%
-- "Digital Marketing Analyst",21.43%
-- "Software Engineer",14.29%


-- What does attrition look like by tenure?
-- calculate the tenure of every employee (in years)
select  TIMESTAMPDIFF(year, hire_date, CURDATE()) as tenure,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / count(*) * 100 as attr_by_tenure
from employees_n
group by TIMESTAMPDIFF(year, hire_date, CURDATE())
order by tenure DESC

-- tenure,attr_by_tenure
-- 8,9.2100
-- 7,11.4500
-- 6,17.2200
-- 5,22.3000
-- 4,16.6700
-- 3,17.3700
-- 2,19.6100
-- 1,19.3300
-- 0,21.1300


-- Does overtime appear associated with higher attrition?
SELECT 
    overtime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_count,
    CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS attr_rate
FROM employees_n
GROUP BY overtime;

-- overtime,total_employees,left_count,attr_rate
-- No,844,132,15.64%
-- Yes,356,77,21.63%

-- Which departments have the greatest number of employees who left, 
-- and how does this compare with their attrition rate?
select department,
COUNT(*) as total_emp,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as left_emp,
concat(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 ,2),'%') AS attr_rate
from employees_n
GROUP BY department
ORDER BY left_emp DESC

-- result shows that HR has the highest attr rate:
-- department,total_emp,left_emp,attr_rate
-- "Customer Service",214,41,19.16%
-- Sales,261,41,15.71%
-- Operations,244,38,15.57%
-- IT,155,29,18.71%
-- Marketing,116,23,19.83%
-- HR,95,19,20.00%
-- Finance,115,18,15.65%

-- Does employee salary appear to differ between employees who stayed 
-- and employees who left?

select  attrition,count(*) as total_emp, AVG(salary),
MAX(salary), MIN(salary)
from employees_n
GROUP BY attrition
-- employees with attrition have lower max salary then the ones who retained
-- both employees who stayed and left have same min salary

-- attrition,total_emp,AVG(salary),MAX(salary),MIN(salary)
-- No,991,9164.0767,15000,4500
-- Yes,209,8870.3349,14300,4500

-- How does attrition vary across job-satisfaction scores from 1 to 5?
select job_satisfaction, count(*) as total_emp,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)AS left_emp,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 ,2 ) ,'%') 
AS attr_rate
from employees_n
GROUP BY job_satisfaction
ORDER BY job_satisfaction DESC

-- employees who hav less job satisfaction (rate=1) are the most who left
--  job_satisfaction,total_emp,left_emp,attr_rate
-- 5,231,31,13.42%
-- 4,219,19,8.68%
-- 3,220,40,18.18%
-- 2,240,53,22.08%
-- 1,290,66,22.76%

-- Q9 — Overtime within departments
select department,overtime, count(*) as total_emp,
-- SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END) as overtime_yes,
-- SUM(CASE WHEN overtime='No' THEN 1 ELSE 0 END)AS overtime_no,
SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END) as left_emp,
CONCAT(ROUND(SUM(CASE WHEN attrition ='Yes' THEN 1 ELSE 0 END) / count(*) * 100,2),'%') AS attr_rate
from employees_n
group by department, overtime
order by department, overtime DESC



-- department,total_emp,overtime_count,left_emp,attr_rate
-- HR,95,28,19,20.00%
-- Marketing,116,36,23,19.83%
-- "Customer Service",214,66,41,19.16%
-- IT,155,37,29,18.71%
-- Sales,261,76,41,15.71%
-- Finance,115,43,18,15.65%
-- Operations,244,70,38,15.57%


-- Overtime is not necessarily linked with attrition rate because we see that in HR department
--  it had 95 employees, whereas 28 has overtime and the attrition rate is 20%. 
--  But operations had 244 employees and 70 did overtime, but the attrition rate is 15.57%, 
--  which is the lowest of all. So, and similarly sales also had 261 employees, and 
--  overtime, the ones that did overtime were 76, but still the attrition rate is on a lower side, 
--  15.71%. Considering to that IT has 155 employees, just 37 did the overtime, but the attrition 
--  rate is on a higher scale. It's like 18.71%. So the employees who work overtime are not 
--  necessarily associated with higher attrition rate. 


-- Q10 — Satisfaction + overtime

select job_satisfaction, overtime,
-- SUM(CASE WHEN overtime = 'Yes' THEN 1 ELSE 0 END) AS  overtime_yes,
-- SUM(CASE WHEN overtime = 'No' THEN 1 ELSE 0 END) AS overtime_no,
COUNT(*) as total_employees,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) as left_empl,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 ,2),'%') AS attr_rate
from employees_n
GROUP BY job_satisfaction, overtime
ORDER BY job_satisfaction


-- job_satisfaction,overtime_yes,overtime_no,total_employees,left_empl,attr_rate
-- 1,82,208,290,66,22.76%
-- 2,65,175,240,53,22.08%
-- 3,72,148,220,40,18.18%
-- 4,66,153,219,19,8.68%
-- 5,71,160,231,31,13.42%

-- From the results, we can see that overtime is not necessarily a root cause of attrition, 
-- because we see that we have the highest overtime percentage, overtime rate of 32.73%, 
-- where job satisfaction is three, which is not very less, not the lowest. And we can 
-- see that the employees who left are 49. It's a medium number, not very high, and the 
-- attrition rate is 18.18%. So the one with the highest and the lowest overtime rate is 
-- 27%, over which we have low job satisfaction, but the attrition rate is the highest
--  among those who have low job satisfaction. And the reason may be otherwise, like 
--  salary or convince problems or something else, but overtime is not the driving 
--  force for the low morale of the employees from this dataset.

-- Q11 — Tenure groups

WITH tenure_calc AS (
select employee_id, attrition,
DATEDIFF(CURRENT_DATE(), CAST(hire_date AS DATE)) / 365.25 AS tenure_years
FROM employees_n
),
tenure_groups AS (
SELECT employee_id,
attrition,
CASE
	WHEN tenure_years <=2 THEN '0-2 Years (New Hires)'
    WHEN tenure_years BETWEEN 3 AND 5 THEN '3-5 Years (Mid-Tenure)'
    ELSE '6+ Years (Veterans)'
END AS tenure_group
FROM tenure_calc
)
select tenure_group,
COUNT(employee_id) as total_empl,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)as attrition,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / count(employee_id)* 100 ,2),'%')as attr_rate
FROM tenure_groups
GROUP BY tenure_group
ORDER BY attr_rate DESC

-- tenure_group,total_empl,attrition,attr_rate
-- "0-2 Years (New Hires)",219,44,20.09%
-- "3-5 Years (Mid-Tenure)",328,56,17.07%
-- "6+ Years (Veterans)",653,109,16.69%
-- The result shows that the highest The result shows that the highest attrition rate is among 
-- the new hires, zero to two years. They have the highest attrition rate of about 20.09%. However, 
-- the number of total employees is also less, but still 44 employees have left. Whereas the ones
--  who are veterans, six plus years, the number of employees is the most, 653, and the attrition 
--  rate is also very low. So the old employees tend to stay, whereas the new ones seem to be unreliable.

-- Q12 — Salary & Attrition
WITH sal_bands AS (
SELECT employee_id,
attrition,
CASE
	WHEN salary <=7000 THEN 'Low Earners'
    WHEN salary BETWEEN 7100 AND 12000 THEN 'Mid Level Earners'
    ELSE 'High Earners'
END AS sal_group
FROM employees_n
)
select sal_group,
count(employee_id),
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)as attrition,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / count(employee_id)* 100 ,2),'%')as attr_rate
from sal_bands
GROUP BY sal_group
ORDER BY attr_rate DESC

-- sal_group,count(employee_id),attrition,attr_rate
-- "Low Earners",303,60,19.80%
-- "Mid Level Earners",668,114,17.07%
-- "High Earners",229,35,15.28%

-- From the result, we can see that high earners
--  have the lowest attrition rate, whereas the ones who are the lower earners, they have the highest attrition rate,
--  about 20%, which shows that attrition appears higher among lower-paid
--  employees.

-- Q13 — Promotion & Attrition
WITH prom_group AS (
select employee_id,attrition,
CASE
	WHEN years_since_promotion <=3 THEN '0-3'
    WHEN years_since_promotion BETWEEN 4 AND 6 THEN '4-6'
    ELSE '7+ Years'
END AS yrs_since_prom
from employees_n 
)

SELECT yrs_since_prom,
count(employee_id) as total_empl,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)as attrition,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / count(employee_id)* 100 ,2),'%')as attr_rate
from prom_group
GROUP BY yrs_since_prom
ORDER BY attr_rate DESC

-- yrs_since_prom,total_empl,attrition,attr_rate
-- "7+ Years",267,54,20.22%
-- 4-6,420,81,19.29%
-- 0-3,513,74,14.42%

-- shows that employees who have not been promoted for a long time
-- (7+ years) have a high attrition as compare to those who
-- have been promoted in recent years

-- Q14 — Performance vs Attrition

WITH perf_group AS (
select employee_id,attrition,
CASE
	WHEN performance_rating <=2 THEN 'Low Performers'
    WHEN performance_rating BETWEEN 3 AND 4 THEN 'Medium Performance'
    ELSE 'High Performers'
END AS perf_ratings
from employees_n 
)

SELECT perf_ratings,
count(employee_id) as total_empl,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)as attrition,
CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / count(employee_id)* 100 ,2),'%')as attr_rate
from perf_group
GROUP BY perf_ratings
ORDER BY attr_rate DESC

-- perf_ratings,total_empl,attrition,attr_rate
-- "Low Performers",244,49,20.08%
-- "High Performers",86,16,18.60%
-- "Medium Performance",870,144,16.55%

-- Low performing employees have the highest attrition ,
-- high perfroming employees have the lowest attr_rate

-- Q15 — Find the Highest-Risk Employee Segments

WITH enriched_employees AS (
    SELECT 
        employee_id,
        department,
        overtime,
        job_satisfaction,
        attrition,
        CASE
            WHEN salary <= 7000 THEN 'Low Earners'
            WHEN salary BETWEEN 7100 AND 10000 THEN 'Mid Earners'
            ELSE 'High Earners'
        END AS salary_band
    FROM employees_n
)
SELECT 
    department,
    overtime,
	-- job_satisfaction,
    salary_band,
    COUNT(employee_id) AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS left_employees,
    CONCAT(ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)/ COUNT(employee_id) * 100, 2), '%') AS attrition_rate
FROM enriched_employees
GROUP BY overtime,department,salary_band
HAVING COUNT(employee_id) >= 1 -- Ensures statistical relevance
ORDER BY department ASC,
-- job_satisfaction DESC,
    overtime ASC, 
    salary_band ASC 
-- SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(employee_id) DESC


department,overtime,salary_band,employees,left_employees,attrition_rate
"Customer Service",No,"High Earners",40,9,22.50%
"Customer Service",No,"Low Earners",52,11,21.15%
"Customer Service",No,"Mid Earners",56,8,14.29%
"Customer Service",Yes,"High Earners",23,4,17.39%
"Customer Service",Yes,"Low Earners",19,6,31.58%
"Customer Service",Yes,"Mid Earners",24,3,12.50%
Finance,No,"High Earners",23,6,26.09%
Finance,No,"Low Earners",13,1,7.69%
Finance,No,"Mid Earners",36,6,16.67%
Finance,Yes,"High Earners",19,3,15.79%
Finance,Yes,"Low Earners",5,1,20.00%
Finance,Yes,"Mid Earners",19,1,5.26%
HR,No,"High Earners",20,3,15.00%
HR,No,"Low Earners",18,5,27.78%
HR,No,"Mid Earners",29,3,10.34%
HR,Yes,"High Earners",14,4,28.57%
HR,Yes,"Low Earners",9,2,22.22%
HR,Yes,"Mid Earners",5,2,40.00%
IT,No,"High Earners",44,8,18.18%
IT,No,"Low Earners",15,3,20.00%
IT,No,"Mid Earners",59,9,15.25%
IT,Yes,"High Earners",14,2,14.29%
IT,Yes,"Low Earners",6,3,50.00%
IT,Yes,"Mid Earners",17,4,23.53%
Marketing,No,"High Earners",22,2,9.09%
Marketing,No,"Low Earners",13,1,7.69%
Marketing,No,"Mid Earners",45,8,17.78%
Marketing,Yes,"High Earners",9,4,44.44%
Marketing,Yes,"Low Earners",3,1,33.33%
Marketing,Yes,"Mid Earners",24,7,29.17%
Operations,No,"High Earners",61,6,9.84%
Operations,No,"Low Earners",49,11,22.45%
Operations,No,"Mid Earners",64,7,10.94%
Operations,Yes,"High Earners",26,4,15.38%
Operations,Yes,"Low Earners",18,3,16.67%
Operations,Yes,"Mid Earners",26,7,26.92%
Sales,No,"High Earners",68,12,17.65%
Sales,No,"Low Earners",60,5,8.33%
Sales,No,"Mid Earners",57,8,14.04%
Sales,Yes,"High Earners",27,3,11.11%
Sales,Yes,"Low Earners",23,7,30.43%
Sales,Yes,"Mid Earners",26,6,23.08%

From this dashboard, we can see that the attrition rate is the most in low earners 
category. For example, in customer service, we have the highest attrition 
rate about 32% in low earners who did the overtime. Similarly, finance 
has a very high attrition rate, 20%, which is not the highest in this 
particular department, but it is again next highest and it's again in
 the low earners salary band and the people who did overtime. 
 Similarly, in HR, we see the highest attrition rate is about 40%
 in mid earners, but this cannot be conclusive because there were
 just five employees in the mid earner band and two of them left,
 and that's why the attrition is 40%. Otherwise, the next result 
 for like in IT, you can say 50% attrition is in the low earners 
 category again, which did overtime. So overtime and low earning 
 is one of the driving factors in the attrition rate.