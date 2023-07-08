Select *
FROM PortfolioProject..CovidDeaths
Where continent is not null
Order By 3,4

--Select *
--FROM PortfolioProject..CovidVaccinations
--Order By 3,4

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location like '%states%'
Order By 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select location, date, total_cases, population, (total_cases/population)*100 as PercentofPopulationInfected
FROM PortfolioProject..CovidDeaths
Where location like '%states%'
Order By 1,2


-- Looking at Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
Group By location, population
Order By PercentPopulationInfected DESC


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select location,MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group By location
Order By TotalDeathCount DESC


-- Showing Countries with Highest Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By location
Order By TotalDeathCount DESC


-- Showing continents with the Highest Death Count

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent
Order By TotalDeathCount DESC


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
Order By 1,2

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group By date
Order By 1,2


-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinted
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	And dea.date=vac.date
Where dea.continent is not null
Order by 2,3


-- USE CTE

With PopvsVac (Contintent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinted)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinted
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	And dea.date=vac.date
Where dea.continent is not null
--Order by 2,3
)
Select*, (RollingPeopleVaccinted/Population)*100
From PopvsVac


-- TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinted
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	And dea.date=vac.date
Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- TEMP TABLE

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinted
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	And dea.date=vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store date for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinted
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    On dea.location=vac.location
	And dea.date=vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated