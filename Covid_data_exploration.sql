/*  Covid Data Exploration based on the tables coviddeaths and covidvaccinations  */ 

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM coviddeaths
order by 1,2;

/* Shows likelihood of dying if you contract covid in your country */

SELECT location,date,total_cases,total_deaths,(total_deaths::decimal/total_cases)*100 as deathpercent
FROM coviddeaths
WHERE location LIKE 'India'
order by 1,2;

/* Looking at total cases vs population */
/* Shows the percentage of people who got covid  */

SELECT location,date,population,total_cases,(total_cases::decimal/population)*100 as infectedpopulationpercentage
FROM coviddeaths
WHERE location LIKE 'India'
order by 1,2;

/* Looking at countries with highest infection rate compared to population */

SELECT location,population,MAX(total_cases) as highestcount,MAX((total_cases::decimal/population))*100 
as infectedpopulationpercentage
FROM coviddeaths
/* WHERE location LIKE 'India' */
WHERE continent is not null
GROUP BY location,population
order by infectedpopulationpercentage desc;

/* Showing countries with highest death counts per population  */

SELECT location,MAX(total_deaths) as Totaldeathcount
FROM coviddeaths
/* WHERE location LIKE 'India' */
WHERE continent is not null
GROUP BY location
order by Totaldeathcount desc;

/*  Break down by continent  */
/* Showing continents with highest death count per population  */


SELECT continent,MAX(total_deaths) as Totaldeathcount
FROM coviddeaths
/* WHERE location LIKE 'India' */
WHERE continent is not null
GROUP BY continent
order by Totaldeathcount desc;

/*  Global Numbers  */

SELECT date,SUM(new_cases),SUM(new_deaths),SUM(new_deaths::decimal)/SUM(new_cases)*100 as deathpercent
FROM coviddeaths
/*WHERE location LIKE 'India'*/
WHERE continent is not null
GROUP BY date
order by 1,2;

/*  Showing the total cases globally  */

SELECT SUM(new_cases) AS total,SUM(new_deaths),SUM(new_deaths::decimal)/SUM(new_cases)*100 as deathpercent
FROM coviddeaths
/*WHERE location LIKE 'India'*/
WHERE continent is not null
GROUP BY date
order by 1,2;


/* Covid vaccination table */

SELECT * FROM covidvaccinations;

/* Join the two tables */

SELECT * FROM coviddeaths AS death
JOIN covidvaccinations AS vacc
ON death.location = vacc.location
AND death.date = vacc.date;

/* Looking at total population vs vaccinations */

SELECT death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (Partition by death.location ORDER BY death.location,death.date)
AS Peoplevaccinated
FROM coviddeaths AS death
JOIN covidvaccinations AS vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent is not null
ORDER BY 1,2,3;


/*  USE CTE  */

WITH PopvsVac (continent,location,date,population,new_vaccinations,peoplevaccinated)
AS
(
SELECT death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (Partition by death.location ORDER BY death.location,death.date)
AS Peoplevaccinated
FROM coviddeaths AS death
JOIN covidvaccinations AS vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent is not null
/* ORDER BY 1,2,3  */
)
SELECT *,(peoplevaccinated::decimal/population)*100
FROM PopvsVac;


/* Temporary table  */

DROP TABLE if exists percentpeoplevaccinated;
CREATE TABLE percentpeoplevaccinated(
	continent varchar(255),
	location varchar(255),
	date date,
	population INTEGER,
	new_vaccinations INTEGER,
	peoplevaccinated INTEGER
);

INSERT INTO percentpeoplevaccinated

(SELECT death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (Partition by death.location ORDER BY death.location,death.date)
AS Peoplevaccinated
FROM coviddeaths AS death
JOIN covidvaccinations AS vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent is not null
/* ORDER BY 1,2,3  */
);
SELECT *,(peoplevaccinated::decimal/population)*100
FROM percentpeoplevaccinated;

/* Creating view to store data for later visualizations  */

CREATE VIEW percent_people_vaccinated as
SELECT death.continent,death.location,death.date,death.population,vacc.new_vaccinations,
SUM(vacc.new_vaccinations) OVER (Partition by death.location ORDER BY death.location,death.date)
AS Peoplevaccinated
FROM coviddeaths AS death
JOIN covidvaccinations AS vacc
ON death.location = vacc.location
AND death.date = vacc.date
WHERE death.continent is not null
/* ORDER BY 1,2,3  */
;

