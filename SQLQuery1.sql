select *
from PortfolioProject..CcovidDeaths$
where continent is not null
order by 3,4

select *
from CcovidVaccinations$
order by 3,4

select location, date, total_cases, new_cases, total_deaths
from PortfolioProject..CcovidDeaths$
order by 1,2


SELECT CAST(total_deaths AS float) FROM CcovidDeaths$
SELECT CAST(total_cases AS float) FROM CcovidDeaths$

--total cases vs total deaths

select location, date, population_density, total_cases, (total_cases/population_density)*100 as DeathPercentage
from PortfolioProject..CcovidDeaths$
where location like '%states%'
order by 1,2

select location, population_density, max(total_cases) as highestinfectionrate , max((total_cases/population_density))*100 as
 Percentpopulationinfected
from PortfolioProject..CcovidDeaths$
where location like '%states%'
group by location, population_density
order by Percentpopulationinfected desc

select continent, max(cast (total_deaths as int)) as totaldeathcount 
from PortfolioProject..CcovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc

-
--highest death continent

select continent, max(cast (total_deaths as int)) as totaldeathcount 
from PortfolioProject..CcovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by totaldeathcount desc

--global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CcovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2

--total population vs vaccination

with popvsvac(continent, location, date,new_cases_per_million, rollingpeoplevaccinated)
as
{
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases_per_million,
sum(convert(int, vac.new_cases_per_million)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
-- (rollingpeoplevaccinated/new_cases_per_million)*100
from PortfolioProject..CcovidVaccinations$ dea
join PortfolioProject..CcovidDeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

CTE
withpopsvac


temp table

Create table percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_cases_per_million numeric,
rollingpeoplevaccinated numeric
)
insert into percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases_per_million,
sum(convert(int, vac.new_cases_per_million)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
-- (rollingpeoplevaccinated/new_cases_per_million)*100
from PortfolioProject..CcovidVaccinations$ dea
join PortfolioProject..CcovidDeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select - (rollingpeoplevaccinated/new_cases_per_million)*100
from percentpopulationvaccinated

--create view
create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_cases_per_million,
sum(convert(int, vac.new_cases_per_million)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
-- (rollingpeoplevaccinated/new_cases_per_million)*100
from PortfolioProject..CcovidVaccinations$ dea
join PortfolioProject..CcovidDeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3