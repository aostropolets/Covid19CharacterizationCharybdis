DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

--persons at risk at start of year, 2017-2020
insert into @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select distinct @target_cohort_id as cohort_definition_id, subject_id, min(cohort_start_date), min(cohort_end_date)
from (
select  op1.person_id as subject_id, datefromparts(2017,1,1)
  as cohort_start_date, datefromparts(2017,1,1) as cohort_end_date
from @cdm_database_schema.observation_period op1
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2017,1,1)
and op1.observation_period_end_date >= datefromparts(2017,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2018,1,1) as cohort_start_date, datefromparts(2018,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2018,1,1)
and op1.observation_period_end_date >= datefromparts(2018,1,1)

union all

select op1.person_id as subject_id, datefromparts(2019,1,1) as cohort_start_date, datefromparts(2019,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2019,1,1)
and op1.observation_period_end_date >= datefromparts(2019,1,1)

union all

select op1.person_id as subject_id, datefromparts(2020,1,1) as cohort_start_date, datefromparts(2020,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2020,1,1)
and op1.observation_period_end_date >= datefromparts(2020,1,1)
) a
group by subject_id
;
