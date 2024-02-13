/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select*
From [Covid]..[CovidDeaths$]
Where continent is not null 
order by 3,4;


-- Select Data that we are going to be starting with

Select Location,Date,total_cases,new_cases,total_deaths,population
From [Covid]..[CovidDeaths$]
Where continent is not null 
order by 1,2;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location,Date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Covid]..[CovidDeaths$]
Where location like 'India'
and continent is not null 
order by 1,2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location,Date,population,total_cases,(total_cases/population)*100 as PercentofPopulaionInfected
From [Covid]..[CovidDeaths$]
--where location ='India'
order by 1,2;


-- Countries with Highest Infection Rate compared to Population

Select Location,population,max(total_cases) as HighestInfectionRate,Max((total_cases/population))*100 as HighestPercentofPopulaionInfected
From [Covid]..[CovidDeaths$]
Group by location,population
order by HighestPercentofPopulaionInfected desc
  

-- Countries with Highest Death Count per Population

Select Location,max(Cast(total_deaths as int)) as totalDeathCount
From [Covid]..[CovidDeaths$]
where continent is not null
Group by location
order by totalDeathCount desc
  

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent,max(Cast(total_deaths as int)) as totalDeathCount
From [Covid]..[CovidDeaths$]
where continent is not null
Group by continent
order by totalDeathCount desc

  
--Global numbers

Select sum(new_cases) as totalCases, Sum(cast(new_deaths as int))as totaldeaths,Sum(cast(new_deaths as int))/sum(new_cases) *100 as GlobalDeathPercentage
From [Covid]..[CovidDeaths$]
where continent is not null
--Group by date
order by 1,2

  
-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
    on dea.location=vac.location 
    and dea.date=vac.date
where dea.continent is not null
order by 2,3

  
-- Using CTE to perform Calculation on Partition By in previous query

With PopVsVac (Continent, location, date, population, new_vaccination, Roolingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
      on dea.location=vac.location 
      and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Roolingpeoplevaccinated/population)*100
from PopVsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

Create table #PerPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
new_vaccination numeric,
Roolingpeoplevaccinated numeric
)
insert into #PerPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
      on dea.location=vac.location 
      and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *, (Roolingpeoplevaccinated/population)*100
from #PerPopulationVaccinated


-- Creating View to store data for later visualizations

create view PerPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
      on dea.location=vac.location 
      and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
from PerPopulationVaccinated
