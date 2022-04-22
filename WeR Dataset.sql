use employees

####1st Case Study#####
#A company wants to assess its gender equality employment policy by looking into the number of male and female employees in the company. Please find: 
#The number of male and female employees in the company. 

SELECT gender, COUNT(gender) AS Total
FROM employees 
group by gender
# 179,973 Male employees
# 120,051 Female employees


#The ratio of males to females hired in the last 5 years. 
select concat("1:",1/(sum(gender = 'F')/sum(gender = 'M'))) as ratio from employees where hire_date >= 1995-12-31
# Ratio is 1:1.49

#or 
SELECT gender, COUNT(gender), YEAR(hire_date)
FROM employees
WHERE `hire_date` >= DATE_SUB('2000-01-28', INTERVAL 5 YEAR)
GROUP BY gender, YEAR(hire_date)
ORDER BY YEAR(hire_date);
#In the year 1995: the ratio of males to females hired was: 6711 : 4397
#In the year 1996: the ratio of males to females hired was: 5804 : 3770
#In the year 1997: the ratio of males to females hired was: 4060 : 2609
#In the year 1998: the ratio of males to females hired was: 2459 : 1696
#In the year 1999: the ratio of males to females hired was: 905 : 609
#In the year 2000: the ratio of males to females hired was: 6 : 7


#If the ratio is not 1:1, list the departments that have the highest gaps in descending order. 
SELECT  d.dept_name , concat("1:",1/(sum(gender = 'F')/sum(gender = 'M'))) AS fm_ratio
 FROM employees e
 INNER JOIN dept_emp de ON e.emp_no = de.emp_no
 INNER JOIN departments d ON de.dept_no = d.dept_no
 where hire_date  between '1995-12-31' and '2000-12-31'
GROUP BY de.dept_no
ORDER BY fm_ratio DESC
# Human Resources got the highest ratio



#If the ratio is not 1:1, then design a 5-year plan to resolve this difference when hiring new employees to fill new positions. Clearly state the number of employees we need to hire each year. 

SELECT 
    e.gender, COUNT(de.emp_no) AS no_employees, d.dept_name, MAX(de.to_date)
FROM
    employees e
        JOIN
    dept_emp de ON e.emp_no = de.emp_no
    JOIN 
    departments d ON de.dept_no = d.dept_no
 where de.to_date > '2000-12-31' and  hire_date  between '1995-12-31' and '2000-12-31'
GROUP BY gender,d.dept_name;
# Plan is explained in EXCEL file


#If the average salary for males and females is not equal, then find the gap in each department and design a 5-year plan to resolve this situation. Clearly state the number of additional funds that the company needs to allocate. 

SELECT de.dept_no, d.dept_name,  ROUND(AVG(s.salary),2) as avg_salary, e.gender
from  employees e
JOIN dept_emp  de ON e.emp_no = de.emp_no
JOIN salaries_latest s ON e.emp_no = s.emp_no
JOIN departments d ON d.dept_no = de.dept_no 
group by  e.gender  ,d.dept_name
# there is no noticeable gap payment between the two genders

________________
#Second:
SELECT e.gender, AVG(s.salary) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;#
# The average salary for males is 63755.9134
  # The average salary for females is 63769.1222
#The average salary for males and females is not equal.
___
SELECT COUNT(employees.gender) AS `Number of employees`, employees.gender, AVG(salaries.salary), departments.dept_name
FROM employees
JOIN salaries ON employees.emp_no=salaries.emp_no
JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
JOIN departments ON dept_emp.dept_no=departments.dept_no
GROUP BY employees.gender, departments.dept_name;
/*There are 9 departments in the company namely: Customer Service, Development, Finance, Human Resources, Marketing, Production, Quality Management, Research, and Sales.*/
 
#**************#

#### 2nd Case Study ####
#Due to unforeseen events similar to COVID-19 the company wants to downsize its employees to save 20% of the total salaries it pays annually. 

#Find out the total amount of salaries paid to each department and assess whether any service/contract is overpaid by comparing it to the salaries paid to the employees in the same department (also make sure to consider years of experience/work with the company). 

# Total sum of salaries in each department
SELECT  e.emp_no, e.first_name, e.last_name, s.salary, e.hire_date, de.from_date, max(de.to_date) As to_date, d.dept_name,
FLOOR(DATEDIFF('2000-12-31',e.hire_date)/365) as years_of_experience
FROM employees e
JOIN dept_emp  de ON e.emp_no = de.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN departments d ON d.dept_no = de.dept_no
Where de.to_date>'2000-12-31' 
GROUP BY e.emp_no
ORDER BY Max(s.salary) DESC; 
# Salary overpaid for an employee who has 3 years experience or less.
# Overpaid is explained in EXCEL file



#Try to develop a strategy to reduce the cost of all contracts expiring within a year instead of downsizing departments. 
# All contracts expiring within a year 
SELECT  e.emp_no, e.first_name, e.last_name, s.salary, e.hire_date, de.from_date, MAX(de.to_date), d.dept_name
FROM employees e
JOIN dept_emp  de ON e.emp_no = de.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN departments d ON d.dept_no = de.dept_no
where de.to_date between'2000-12-31' and '2001-12-31'
GROUP BY e.emp_no
ORDER BY  e.emp_no DESC;

#If reducing salaries for the new contracts does not work, then find a strategy for downsizing the departments. This might include pushing employees to early retirements. Make sure not to reduce any department by more than 50% of its staff. 

#State the names and the employee’s information whom you plan to either reduce their wages or let them go. 
# All employees who have one year experience and their contracts expiring within a year
SELECT  e.emp_no, e.first_name, e.last_name, s.salary, e.hire_date, de.from_date, max(de.to_date) as to_date, d.dept_name,
FLOOR(DATEDIFF('2000-12-31',e.hire_date)/365) as years_of_experience
FROM employees e
JOIN dept_emp  de ON e.emp_no = de.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE e.hire_date between '1999-01-01' and '2000-12-30'
GROUP BY e.emp_no
ORDER BY  e.emp_no DESC; 

#If the average salary for males and females is not equal, then you can reduce the salaries of the gender paid higher and state how much funds were saved with this plan/practice. 

SELECT e.gender,round( AVG(s.salary),2) AS average_salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
GROUP BY gender;


#**************#
###3rd Case Study###
#The company wants to offer bonuses at the end of the year to reward its employees. The total bonus paid to all the employees should not exceed $50 million. Design a plan for distributing bonuses based on: 



#If the average salary for males and females is not equal, then offer a higher bonus to compensate for this circumstance. 

SELECT e.gender, ROUND(AVG(s.salary),2) AS avg_salary
FROM employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY gender; 

#Years of service with the company. 

SELECT  e.emp_no , s.salary, (2000 - extract(year FROM e.hire_date)) AS year_of_service
from salaries s
join 
employees e ON e.emp_no = s.emp_no
where from_date >='2000-01-01'
group by e.emp_no;


#If their contracts are expiring soon (February 1, 2001) to convince them to stay.

SELECT emp_no, to_date
from salaries
where to_date between '2001-01-01' and '2001-02-01'
