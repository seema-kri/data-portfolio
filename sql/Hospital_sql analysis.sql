create table hospital_data(
date text,
facility_name text,
system text,
setting text,
count int)
;

select * from hospital_data limit 10;

--How big is the dataset?
select count(*) as total_record
from hospital_data;

--What are the unique hospital settings?
select distinct setting
from hospital_data;

--Total patient volume
select sum(count) as total_patients
from hospital_data;

--Which setting has highest demand?
select setting,sum(count) as total
from hospital_data
group by setting
order by total desc;

--Which hospitals are busiest?
select facility_name,sum(count) as total
from hospital_data
group by facility_name
order by total desc
limit 5;

--Which hospitals are least used?
select facility_name,sum(count) as total
from hospital_data
group by facility_name
order by total asc
limit 5;

--Which healthcare system handles most patients?
select system,sum(count) as total
from hospital_data
group by system
order by total desc;

--What % of total load each hospital handles?
select facility_name,sum(count) as total,
round(100.0*sum(count)/sum(sum(count))over(),2) as percentage
from hospital_data
group by facility_name
order by percentage desc;

--Which setting is dominant in each hospital?
select facility_name,setting,sum(count) as total
from hospital_data
group by facility_name,setting
order by total desc

--Top 3 busiest hospitals
select facility_name,sum(count) as total
from hospital_data
group by facility_name
order by total desc
limit 3;


--insight:
--The dataset contains 64,997 records, providing a strong base for analysis.
--Hospital services are mainly divided into Inpatient, Emergency Department, and Ambulatory Surgery.
--Total patient volume is 175.6 million, indicating very high healthcare demand.
--Emergency Department has the highest demand, showing strong reliance on urgent care services.
--A few hospitals handle the majority of patients, with Kaiser facilities among the top performers.
--Some hospitals have extremely low patient counts, indicating underutilization or specialized services.
--The Statewide category dominates, showing aggregated data and should be excluded for detailed comparison.
--Patient load is unevenly distributed, with top hospitals contributing a large share of total volume.
--Hospitals show different service focus, with some specializing in specific settings like emergency or surgery.
--The top hospitals act as major healthcare hubs, indicating high demand and resource concentration.


