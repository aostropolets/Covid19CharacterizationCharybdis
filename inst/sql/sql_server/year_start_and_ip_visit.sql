DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;




--persons at risk at start of year, 2017-2020 + 1 IP/ED visit
insert into @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select distinct  @target_cohort_id as cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
  from (
select op1.person_id as subject_id, datefromparts(2017,1,1)
  as cohort_start_date, datefromparts(2017,1,1) as cohort_end_date
from @cdm_database_schema.observation_period op1
join @cdm_database_schema.visit_occurrence v on v.person_id = op1.person_id and year(visit_start_date) = 2017 and visit_concept_id in (9201,9203,262)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2017,1,1)
and op1.observation_period_end_date >= datefromparts(2017,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2018,1,1) as cohort_start_date, datefromparts(2018,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
join @cdm_database_schema.visit_occurrence v on v.person_id = op1.person_id and year(visit_start_date) = 2018 and visit_concept_id in (9201,9203,262)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2018,1,1)
and op1.observation_period_end_date >= datefromparts(2018,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2019,1,1) as cohort_start_date, datefromparts(2019,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
join @cdm_database_schema.visit_occurrence v on v.person_id = op1.person_id and year(visit_start_date) = 2019 and visit_concept_id in (9201,9203,262)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2019,1,1)
and op1.observation_period_end_date >= datefromparts(2019,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2020,1,1) as cohort_start_date, datefromparts(2020,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
join @cdm_database_schema.visit_occurrence v on v.person_id = op1.person_id and year(visit_start_date) = 2020 and visit_concept_id in (9201,9203,262)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2020,1,1)
and op1.observation_period_end_date >= datefromparts(2020,1,1)
  ) a
;
