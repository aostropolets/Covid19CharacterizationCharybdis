DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;

--random visit in year, 2017-2020
insert into @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select  @target_cohort_id as cohort_definition_id, t1.person_id as subject_id, t1.visit_start_date as cohort_start_date, t1.visit_start_date as cohort_end_date
from
	(
	select person_id, visit_start_date
	from
	(
	select person_id, row_number() over (partition by person_id order by newid()) as rn1, visit_start_date
		  from @cdm_database_schema.visit_occurrence
		  where visit_start_date >= '1/1/2017'
		  and visit_start_date < '1/1/2018'
	) t1
	where rn1 = 1

	union all

	select person_id, visit_start_date
	from
	(
	select person_id, row_number() over (partition by person_id order by newid()) as rn1, visit_start_date
		  from @cdm_database_schema.visit_occurrence
		  where visit_start_date >= '1/1/2018'
		  and visit_start_date < '1/1/2019'
	) t1
	where rn1 = 1

	 union all

	select person_id, visit_start_date
	from
	(
	select person_id, row_number() over (partition by person_id order by newid()) as rn1, visit_start_date
		  from @cdm_database_schema.visit_occurrence
		  where visit_start_date >= '1/1/2019'
		  and visit_start_date < '1/1/2020'
	) t1
	where rn1 = 1

	union all

	select person_id, visit_start_date
	from
	(
	select person_id, row_number() over (partition by person_id order by newid()) as rn1, visit_start_date
		  from @cdm_database_schema.visit_occurrence
		  where visit_start_date >= '1/1/2020'
		  and visit_start_date < '1/1/2021'
	) t1
	where rn1 = 1
	) t1
	inner join
	@cdm_database_schema.observation_period op1
	on t1.person_id = op1.person_id
	and dateadd(dd,365,op1.observation_period_start_date) <= t1.visit_start_date
	and op1.observation_period_end_date >= t1.visit_start_date
;