DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

-- first well-visit
insert into @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select distinct  @target_cohort_id as cohort_definition_id, t1.person_id as subject_id, t1.cohort_start_date as cohort_start_date, t1.cohort_start_date as cohort_end_date
from
	(
	select p.person_id, min(visit_start_date) as cohort_start_date
	  from @cdm_database_schema.visit_occurrence v
	  join @cdm_database_schema.procedure_occurrence p on procedure_date = visit_start_date and v.person_id = p.person_id
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
	  where visit_start_date >= '1/1/2017'
	  and visit_start_date < '1/1/2018'
	  group by p.person_id

	union all

	select p.person_id, min(visit_start_date) as cohort_start_date
	  from  @cdm_database_schema.visit_occurrence v
		  join @cdm_database_schema.procedure_occurrence p on procedure_date = visit_start_date and v.person_id = p.person_id
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
	  where visit_start_date >= '1/1/2018'
	  and visit_start_date < '1/1/2019'
	  group by p.person_id

	 union all

	select p.person_id, min(visit_start_date) as cohort_start_date
	  from  @cdm_database_schema.visit_occurrence v
		  join @cdm_database_schema.procedure_occurrence p on procedure_date = visit_start_date and v.person_id = p.person_id
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
	  where visit_start_date >= '1/1/2019'
	  and visit_start_date < '1/1/2020'
	  group by p.person_id

	union all

	select p.person_id, min(visit_start_date) as cohort_start_date
	  from  @cdm_database_schema.visit_occurrence v
		join @cdm_database_schema.procedure_occurrence p on procedure_date = visit_start_date and v.person_id = p.person_id
	  join @cdm_database_schema.concept_ancestor on procedure_concept_id = descendant_concept_id and ancestor_concept_id in (4145333,4301122, 4029705, 4132649,45890354)
	  where visit_start_date >= '1/1/2020'
	  and visit_start_date < '1/1/2021'
	  group by p.person_id
	) t1
	inner join
	 @cdm_database_schema.observation_period op1
	on t1.person_id = op1.person_id
	and dateadd(dd,365,op1.observation_period_start_date) <= t1.cohort_start_date
	and op1.observation_period_end_date >= t1.cohort_start_date
;

