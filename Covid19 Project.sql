Select*
From [Covid]..[CovidDeaths$]
order by 3,4;

--Select*
--From [dbo].[CovidVaccinations$]
--order by 3,4

--Data we are going to use

Select Location,Date,total_cases,new_cases,total_deaths,population
From [Covid]..[CovidDeaths$]
order by 1,2;

-- Death Percentage (total caces vs total deaths)

Select Location,Date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Covid]..[CovidDeaths$]
order by 1,2;

--(total caces vs population)

Select Location,Date,population,total_cases,(total_cases/population)*100 as PercentofPopulaionInfected
From [Covid]..[CovidDeaths$]
--where location ='India'
order by 1,2;

--Looking for countries with highest infection rates compared to population

Select Location,population,max(total_cases) as HighestInfectionRate,Max((total_cases/population))*100 as HighestPercentofPopulaionInfected
From [Covid]..[CovidDeaths$]
Group by location,population
order by HighestPercentofPopulaionInfected desc

--Looking for countries with highest death counts 

Select Location,max(Cast(total_deaths as int)) as totalDeathCount
From [Covid]..[CovidDeaths$]
where continent is not null
Group by location
order by totalDeathCount desc

--Looking for continents with highest death counts

Select continent,max(Cast(total_deaths as int)) as totalDeathCount
From [Covid]..[CovidDeaths$]
where continent is not null
Group by continent
order by totalDeathCount desc

--Global numbers

Select date,sum(new_cases) as totalCases, Sum(cast(new_deaths as int))as totaldeaths,Sum(cast(new_deaths as int))/sum(new_cases) *100 as GlobalDeathPercentage
From [Covid]..[CovidDeaths$]
where continent is not null
Group by date
order by 1,2

Select sum(new_cases) as totalCases, Sum(cast(new_deaths as int))as totaldeaths,Sum(cast(new_deaths as int))/sum(new_cases) *100 as GlobalDeathPercentage
From [Covid]..[CovidDeaths$]
where continent is not null
--Group by date
order by 1,2

--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

-- Using CTE

With PopVsVac (Continent, location, date, population, new_vaccination, Roolingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (Roolingpeoplevaccinated/population)*100
from PopVsVac

--temp table

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
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select *, (Roolingpeoplevaccinated/population)*100
from #PerPopulationVaccinated


--Creating view to store data for later vizulization

create view PerPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as Roolingpeoplevaccinated 
From Covid..CovidDeaths$ dea
join Covid..CovidVaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
from PerPopulationVaccinated