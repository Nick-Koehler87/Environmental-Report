use emissionsreport;
select * from emissions;
select * from generation_major_source;
select * from generation_renewable_sources;
select * from emissions_sources;


select count(sub.subsector) from (select distinct subsector from emissions) sub;

select source_name, subsector, start_time, emissions_quantity from emissions_sources
where not subsector = "road-transportation"
order by source_name desc;

-- Tracks emissions of various sectors of economy for methane, carbon dioxide, and Nitrous oxide 
-- entrys for years 2015 - 2022
-- Tracked Gasses: ch4, co2, no2, co2e_100yr, co2e_20yr
select * from emissions 
where (subsector = "electricity-generation" or subsector = "oil-and-gas-production-and-transport" or subsector = "road-transportation") and year(start_time) > "2020";

-- Veiw total emissions for years 2015 to 2022 by subsector
select co2.sector, co2.subsector, format(co2e_20yr.total_co2e_20yr_tons, 0) as "total co2e_20yr in tons", format(co2.total_co2_tons, 0) as "total co2 in tons", format(ch4.total_ch4_tons, 0) as "total ch4 in tons", format(n2o.total_n2o_tons, 0) as "total n2o in tons"
from total_co2_2015_2022_by_subsector co2
join total_ch4_2015_2022_by_subsector ch4 on co2.sector = ch4.sector and co2.subsector = ch4.subsector
join total_n2o_2015_2022_by_subsector n2o on co2.sector = n2o.sector and co2.subsector = n2o.subsector
join total_co2e_20yr_2015_2022_by_subsector co2e_20yr on  co2.sector = co2e_20yr.sector and co2.subsector = co2e_20yr.subsector
order by co2e_20yr.total_co2e_20yr_tons desc, co2.total_co2_tons desc, ch4.total_ch4_tons desc, n2o.total_n2o_tons ;

-- view max co2 emissions per sector
select sector, subsector, format(max_co2_tons, 0) as co2_tons from max_co2_by_sector;

drop view max_co2_by_sector;

create view max_co2_by_sector as
select e.sector, e.subsector, e.total_co2_tons as max_co2_tons
from total_co2_2015_2022_by_subsector e
join (select sector, max(total_co2_tons) as max_co2 from total_co2_2015_2022_by_subsector group by sector) 
max_em on e.sector = max_em.sector and e.total_co2_tons = max_em.max_co2
order by total_co2_tons desc;

-- view max ch4 emissions per sector
select sector, subsector, format(max_ch4_tons, 0) as ch4_tons from max_ch4_by_sector;

drop view max_ch4_by_sector;

create view max_ch4_by_sector as
select e.sector, e.subsector, e.total_ch4_tons as max_ch4_tons
from total_ch4_2015_2022_by_subsector e
join (select sector, max(total_ch4_tons) as max_ch4 from total_ch4_2015_2022_by_subsector group by sector) 
max_em on e.sector = max_em.sector and e.total_ch4_tons = max_em.max_ch4
order by total_ch4_tons desc;

-- view max n2o emissions per sector
select sector, subsector, format(max_n2o_tons, 0) as n2o_tons from max_n2o_by_sector;

drop view max_n2o_by_sector;

create view max_n2o_by_sector as
select e.sector, e.subsector, e.total_n2o_tons as max_n2o_tons
from total_n2o_2015_2022_by_subsector e
join (select sector, max(total_n2o_tons) as max_n2o from total_n2o_2015_2022_by_subsector group by sector) 
max_em on e.sector = max_em.sector and e.total_n2o_tons = max_em.max_n2o
order by total_n2o_tons desc;

-- Veiw total co2 emissions for years 2015 to 2022 by subsector
select sector, subsector, format(total_co2_tons, 0) as "total co2 in tons" from total_co2_2015_2022_by_subsector order by total_co2_tons desc;

drop view total_co2_2015_2022_by_subsector;

create view total_co2_2015_2022_by_subsector as
select sector, subsector, sum(emissions_quantity) as total_co2_tons
from emissions
where gas = "co2"
group by sector, subsector;


-- Veiw total ch4 emissions for years 2015 to 2022 by subsector
select sector, subsector, format(total_ch4_tons, 0) from total_ch4_2015_2022_by_subsector order by total_ch4_tons desc;

drop view total_ch4_2015_2022_by_subsector;

create view total_ch4_2015_2022_by_subsector as
select sector, subsector, sum(emissions_quantity) as total_ch4_tons
from emissions
where gas = "ch4"
group by sector, subsector;

-- Veiw total n2o emissions for years 2015 to 2022 by subsector
select sector, subsector, format(total_n2o_tons, 0) from total_n2o_2015_2022_by_subsector order by total_n2o_tons desc;

drop view total_n2o_2015_2022_by_subsector;

create view total_n2o_2015_2022_by_subsector as
select sector, subsector, sum(emissions_quantity) as total_n2o_tons
from emissions
where gas = "n2o"
group by sector, subsector;

-- Veiw total n2o emissions for years 2015 to 2022 by subsector
select sector, subsector, format(total_n2o_tons, 0) from total_n2o_2015_2022_by_subsector order by total_n2o_tons desc;

drop view total_n2o_2015_2022_by_subsector;

create view total_n2o_2015_2022_by_subsector as
select sector, subsector, sum(emissions_quantity) as total_n2o_tons
from emissions
where gas = "n2o"
group by sector, subsector;

-- Veiw total co2e_20yr emissions for years 2015 to 2022 by subsector
select sector, subsector, format(total_co2e_20yr_tons, 0) as "total co2e_20yr in tons" from total_co2e_20yr_2015_2022_by_subsector order by total_co2e_20yr_tons desc;

drop view total_co2e_20yr_2015_2022_by_subsector;

create view total_co2e_20yr_2015_2022_by_subsector as
select sector, subsector, sum(emissions_quantity) as total_co2e_20yr_tons
from emissions
where gas = "co2e_20yr"
group by sector, subsector;

-- co2 eqivelent per year
select sector, subsector, format(ems_2015, 1) as "2015 emissions", format(ems_2016, 1) as "2016 emissions", format(ems_2017, 1) as "2017 emissions", format(ems_2018, 1) as "2018 emissions", format(ems_2019, 1) as "2019 emissions", format(ems_2020, 1) as "2020 emissions", format(ems_2021, 1) as "2021 emissions", format(ems_2022, 1) as "2022 emissions" from co2e_20yr_yearly_by_subsector;

drop view co2e_20yr_yearly_by_subsector;

create view co2e_20yr_yearly_by_subsector as
select distinct m.sector, m.subsector, a.ems_2015, b.ems_2016, c.ems_2017, d.ems_2018, e.ems_2019, f.ems_2020, g.ems_2021, h.ems_2022
from emissions m
join (select sector, subsector, start_time, emissions_quantity as ems_2015 from emissions
where gas = "co2e_20yr" and year(start_time) = "2015") a on m.sector = a.sector and m.subsector = a.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2016 from emissions
where gas = "co2e_20yr" and year(start_time) = "2016") b on m.sector = b.sector and m.subsector = b.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2017 from emissions
where gas = "co2e_20yr" and year(start_time) = "2017") c on m.sector = c.sector and m.subsector = c.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2018 from emissions
where gas = "co2e_20yr" and year(start_time) = "2018") d on m.sector = d.sector and m.subsector = d.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2019 from emissions
where gas = "co2e_20yr" and year(start_time) = "2019") e on m.sector = e.sector and m.subsector = e.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2020 from emissions
where gas = "co2e_20yr" and year(start_time) = "2020") f on m.sector = f.sector and m.subsector = f.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2021 from emissions
where gas = "co2e_20yr" and year(start_time) = "2021") g on m.sector = g.sector and m.subsector = g.subsector
join (select sector, subsector, start_time, emissions_quantity as ems_2022 from emissions
where gas = "co2e_20yr" and year(start_time) = "2022") h on m.sector = h.sector and m.subsector = h.subsector
order by h.ems_2022 desc;




