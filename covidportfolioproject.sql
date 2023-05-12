select * from portfolioprojects..CovidDeaths$
where continent is not null
order by 3,4
select * from portfolioprojects..CovidVaccinations$
order by 3,4
--select data that we are going to be using 
select  location,date,total_cases,new_cases,total_deaths,population from portfolioprojects..CovidDeaths$
where continent is not null
order by 1,2
--Looking at Total cases vs Total deaths
--Shows the likelihood of death when contracting covid in a country
select  location,date,total_cases,total_deaths,((total_deaths/total_cases)*100) as
 deathpercentage from portfolioprojects..CovidDeaths$
 where location like 'Canada'
order by 1,2
select  location,date,total_cases,total_deaths,((total_deaths/total_cases)*100) as
 deathpercentage from portfolioprojects..CovidDeaths$
 where location like 'india'
 order by 1,2

 --Looking at Total cases vs Total population
 --shows what percentage of population got covid
 select  location,date,population,total_cases,((total_cases/population)*100) as
 covidcontractedpercentage from portfolioprojects..CovidDeaths$
 where location like 'india' 
 order by 1,2

 select  location,date,population,total_cases,((total_cases/population)*100) as
 covidcontractedpercentage from portfolioprojects..CovidDeaths$
 where location like 'Canada'
 order by 1,2

 --Looking at countries with highest infection rate compared to population
 select  location,population,Max(total_cases)as HighestInfectioncount,Max((total_cases/population)*100) as
 covidcontractedpercentage 
 from portfolioprojects..CovidDeaths$
 where continent is not null
 group by location,population
 order by covidcontractedpercentage desc

 --Countries with highest death count per population

 select  location,Max(cast(total_deaths as int))as Totaldeathcount
 from portfolioprojects..CovidDeaths$
 where continent is not null
 group by location
 order by Totaldeathcount desc

 --LETS BREAK THINGS IN TO CONTINENT
 --Continents with highest death rate per population

 select  continent,Max(cast(total_deaths as int))as Totaldeathcount
 from portfolioprojects..CovidDeaths$
 where continent is not null
 group by continent
 order by Totaldeathcount desc

 --GLOBAL NUMBERS
 select  date,sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
 from portfolioprojects..CovidDeaths$
 where continent is not null
 group by date
 order by 1,2

 select  sum(new_cases)as totalcases,sum(cast(new_deaths as int)) as totaldeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
 from portfolioprojects..CovidDeaths$
 where continent is not null
 order by 1,2
select * from portfolioprojects..CovidVaccinations$
--Looking at totalpopulation vs vaccination

select * from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over( partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated 
from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Using CTE
with popvsvac(Continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over( partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated 
from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select *, (Rollingpeoplevaccinated/population)*100  from popvsvac 

        --Temp table
drop table if exists #PercentagePopulationVaccinated
create table #PercentagePopulationVaccinated
(continent nvarchar(255)
,location varchar(255)
,date datetime
,population numeric
,new_vaccinations numeric
,Rollingpeoplevaccinated numeric
)
insert into  #PercentagePopulationVaccinated

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over( partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated 
from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date

select *, (Rollingpeoplevaccinated/population)*100  from  #PercentagePopulationVaccinated


 --Creating view to store for later visualization
 create view PercentagePopulationVaccinated as
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over( partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated 
from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
select * from PercentagePopulationVaccinated
drop view PercentagePopulationVaccinated
use portfolioprojects
go 
create view PercentagePopulationVaccinated as
 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,new_vaccinations))over( partition by dea.location order by dea.location, dea.date)
as Rollingpeoplevaccinated 
from portfolioprojects..CovidDeaths$ as dea
join portfolioprojects..CovidVaccinations$ as vac
on dea.location=vac.location
and dea.date=vac.date
select * from PercentagePopulationVaccinated


Queries for tableau visualization

1)Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From portfolioprojects..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
2)
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From portfolioprojects..CovidDeaths$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc
3)
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioprojects..CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc

4)
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From portfolioprojects..CovidDeaths$
Where location in('United states','Canada','India','china','Italy')
Group by Location, Population, date
order by PercentPopulationInfected desc






