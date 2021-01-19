DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

--persons at risk at start of year, 2017-2020 + 1 well visit
insert into @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select distinct @target_cohort_id as cohort_definition_id, subject_id, cohort_start_date, cohort_end_date
  from (
select  op1.person_id as subject_id, datefromparts(2017,1,1)
  as cohort_start_date, datefromparts(2017,1,1) as cohort_end_date
from @cdm_database_schema.observation_period op1
		join @cdm_database_schema.procedure_occurrence p on p.person_id = op1.person_id and year(procedure_date) =2017
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2017,1,1)
and op1.observation_period_end_date >= datefromparts(2017,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2018,1,1) as cohort_start_date, datefromparts(2018,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
  	join @cdm_database_schema.procedure_occurrence p on p.person_id = op1.person_id and year(procedure_date) =2018
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2018,1,1)
and op1.observation_period_end_date >= datefromparts(2018,1,1)

union all

select  op1.person_id as subject_id, datefromparts(2019,1,1) as cohort_start_date, datefromparts(2019,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
  	join @cdm_database_schema.procedure_occurrence p on p.person_id = op1.person_id and year(procedure_date) =2019
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2019,1,1)
and op1.observation_period_end_date >= datefromparts(2019,1,1)

union all

select op1.person_id as subject_id, datefromparts(2020,1,1) as cohort_start_date, datefromparts(2020,1,1) as cohort_end_date
from @cdm_database_schema.observation_period  op1
  		join @cdm_database_schema.procedure_occurrence p on p.person_id = op1.person_id and year(procedure_date) =2020
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
where dateadd(dd,365,op1.observation_period_start_date) <= datefromparts(2020,1,1)
and op1.observation_period_end_date >= datefromparts(2020,1,1)
  ) a
;