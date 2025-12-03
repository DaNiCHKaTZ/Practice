SELECT FirstName, LastName, Salary,
    CASE 
        WHEN Salary < 5000 THEN 'Low level'
        WHEN Salary >= 5000 AND Salary < 10000 THEN 'Normal level'
        WHEN Salary >= 10000 THEN 'High level'
    END AS SalaryLevel
FROM Employees;

SELECT CountryName, RegionId,
	CASE
		WHEN RegionId = 1 THEN 'Europe'
		WHEN RegionId = 2 THEN 'America'
		WHEN RegionId = 3 THEN 'Asia'
		WHEN RegionId = 4 THEN 'Africa'
	END AS RegionName
FROM Countries;