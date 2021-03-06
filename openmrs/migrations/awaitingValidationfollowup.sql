DELETE FROM global_property where property = 'emrapi.sqlSearch.awaitingValidationFollowup';
 select uuid() into @uuid;


 INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
 VALUES ('emrapi.sqlSearch.awaitingValidationFollowup',
"
SELECT
  `identifier`, name, uuid, `Name of MLO`, `Nationality`, `Specialty`, `Name of Surgeon 1`, `Name of Surgeon 2`
FROM (
       SELECT
         person_data.name                                                                           AS name,
         person_data.id                                                                             AS `identifier`,
         person_data.uuid                                                                           AS uuid,
         person_data.nationality                                                                    AS 'Nationality',
         GROUP_CONCAT(DISTINCT (IF(
             obs_fscn.name = 'FUP, Date of presentation at Followup' AND latest_encounter.person_id IS NOT NULL,
             o.value_datetime, NULL)) ORDER BY o.obs_id
                      DESC)                                                                         AS 'dateOfPresentation',
         GROUP_CONCAT(DISTINCT
                      (IF(obs_fscn.name = 'FV, Date of Presentation' AND latest_encounter.person_id IS NOT NULL,
                          o.value_datetime, NULL)) ORDER BY o.obs_id
                      DESC)                                                                         AS 'FVdateOfPresentation',
         `Name of MLO`,
         `Specialty`,
         GROUP_CONCAT(DISTINCT
                      (IF(obs_fscn.name = 'FUP, Name (s) of Surgeon 1' AND latest_encounter.person_id IS NOT NULL,
                          COALESCE(coded_fscn.name, coded_scn.name), NULL)) ORDER BY o.obs_id
                      DESC)                                                                         AS 'Name of Surgeon 1',
         GROUP_CONCAT(DISTINCT
                      (IF(obs_fscn.name = 'FUP, Name (s) of Surgeon 2' AND latest_encounter.person_id IS NOT NULL,
                          COALESCE(coded_fscn.name, coded_scn.name), NULL)) ORDER BY o.obs_id
                      DESC)                                                                         AS 'Name of Surgeon 2'
       FROM
       (
         SELECT
           concat(pn.given_name, ' ', pn.family_name)                                                  AS name,
           pi.identifier                                                                               AS id,
           p.person_id                                                                                 AS person_id,
           p.uuid                                                                                      AS uuid,
           GROUP_CONCAT(DISTINCT (IF(pat.name = 'nationality1', coalesce(scn.name, fscn.name), NULL))) AS nationality
         FROM person p
         JOIN patient_identifier pi ON p.person_id = pi.patient_id AND p.voided IS FALSE
         JOIN person_name pn ON p.person_id = pn.person_id AND pn.voided IS FALSE
         LEFT OUTER JOIN person_attribute pa ON p.person_id = pa.person_id AND pa.voided IS FALSE
         LEFT OUTER JOIN person_attribute_type pat
         ON pa.person_attribute_type_id = pat.person_attribute_type_id AND pat.retired IS FALSE
         LEFT OUTER JOIN concept_name scn
         ON pat.format = 'org.openmrs.Concept' AND pa.value = scn.concept_id AND scn.concept_name_type = 'SHORT' AND
            scn.voided IS FALSE
         LEFT OUTER JOIN concept_name fscn ON pat.format = 'org.openmrs.Concept' AND pa.value = fscn.concept_id AND
                                              fscn.concept_name_type = 'FULLY_SPECIFIED' AND fscn.voided IS FALSE
         GROUP BY person_id) person_data
       LEFT JOIN obs o ON person_data.person_id = o.person_id AND o.voided IS FALSE
       LEFT JOIN concept_name obs_fscn ON o.concept_id = obs_fscn.concept_id AND
                                          obs_fscn.name IN
                                          ('FUP, Date of presentation at Followup', 'FUP, Name (s) of Surgeon 1', 'FUP, Name (s) of Surgeon 2', 'FV, Date of Presentation')
                                          AND obs_fscn.voided IS FALSE AND
                                          obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
       LEFT JOIN encounter e ON o.encounter_id = e.encounter_id AND e.voided IS FALSE
       LEFT JOIN concept_name coded_fscn
       ON coded_fscn.concept_id = o.value_coded AND coded_fscn.concept_name_type = 'FULLY_SPECIFIED' AND
          coded_fscn.voided IS FALSE
       LEFT JOIN concept_name coded_scn
       ON coded_scn.concept_id = o.value_coded AND coded_fscn.concept_name_type = 'SHORT' AND coded_scn.voided IS FALSE
       LEFT JOIN (SELECT
                    en.visit_id,
                    person_id,
                    obs.concept_id,
                    max(en.encounter_datetime) AS max_encounter_datetime
                  FROM obs
                  JOIN encounter en ON obs.encounter_id = en.encounter_id
                                       AND en.voided IS FALSE
                                       AND obs.voided IS FALSE
                                       AND en.visit_id IN (SELECT v.visit_id
                                                           FROM
                                                           visit v
                                                           JOIN (SELECT
                                                                   patient_id        AS patient_id,
                                                                   max(date_started) AS date_started
                                                                 FROM visit
                                                                 WHERE visit.voided IS FALSE
                                                                 GROUP BY patient_id) latest_visit
                                                           ON v.date_started = latest_visit.date_started AND
                                                              v.patient_id = latest_visit.patient_id AND
                                                              v.voided IS FALSE)
                  GROUP BY obs.person_id, obs.concept_id) latest_encounter
       ON o.person_id = latest_encounter.person_id AND o.concept_id = latest_encounter.concept_id
          AND latest_encounter.max_encounter_datetime = e.encounter_datetime
       LEFT JOIN visit v ON e.visit_id = v.visit_id AND v.voided IS FALSE AND v.visit_type_id = (SELECT visit_type_id
                                                                                                 FROM visit_type
                                                                                                 WHERE name =
                                                                                                       'Follow-Up Validation')
       LEFT JOIN (SELECT
                    obs.person_id,
                    encounter.encounter_id,
                    c_name                                                                                          AS name,
                    GROUP_CONCAT(DISTINCT (IF(c_name = 'FSTG, Specialty determined by MLO',
                                              COALESCE(coded_fscn.name, coded_scn.name),
                                              NULL)))                                                               AS 'Specialty',
                    GROUP_CONCAT(DISTINCT (IF(c_name = 'MH, Name of MLO', COALESCE(coded_fscn.name, coded_scn.name),
                                              NULL)))                                                               AS 'Name of MLO'
                  FROM (SELECT
                          cn.name                 AS c_name,
                          obs.person_id,
                          obs.encounter_id,
                          max(encounter_datetime) AS max_encounter_datetime,
                          obs.concept_id
                        FROM obs
                        JOIN encounter ON obs.encounter_id = encounter.encounter_id AND obs.voided IS FALSE AND
                                          encounter.voided IS FALSE
                        JOIN concept_name cn ON cn.name IN ('MH, Name of MLO', 'FSTG, Specialty determined by MLO')
                                                AND cn.concept_id = obs.concept_id AND cn.voided IS FALSE
                        GROUP BY person_id, concept_id) result
                  JOIN encounter
                  ON result.max_encounter_datetime = encounter.encounter_datetime AND encounter.voided IS FALSE
                  JOIN obs ON encounter.encounter_id = obs.encounter_id AND obs.concept_id = result.concept_id AND
                              obs.voided IS FALSE
                  LEFT JOIN concept_name coded_fscn ON coded_fscn.concept_id = obs.value_coded
                                                       AND coded_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                                       AND coded_fscn.voided IS FALSE
                  LEFT JOIN concept_name coded_scn ON coded_scn.concept_id = obs.value_coded
                                                      AND coded_fscn.concept_name_type = 'SHORT'
                                                      AND coded_scn.voided IS FALSE
                  GROUP BY obs.person_id
                 ) obs_across_visits ON person_data.person_id = obs_across_visits.person_id
       JOIN patient_program pp ON person_data.person_id = pp.patient_id AND pp.voided IS FALSE
       JOIN program_workflow pw ON pw.program_id = pp.program_id AND pw.retired IS FALSE
       JOIN program_workflow_state pws ON pw.program_workflow_id = pws.program_workflow_id AND pws.retired IS FALSE
       JOIN patient_state ps ON
       pws.program_workflow_state_id = ps.state AND ps.patient_program_id = pp.patient_program_id AND
       ps.end_date IS NULL AND ps.voided IS FALSE
       AND pws.concept_id = (SELECT concept_id
                             FROM concept_name
                             WHERE name = 'Network Follow-up' AND concept_name_type = 'FULLY_SPECIFIED')
       GROUP BY person_data.person_id
       ORDER BY Specialty) result
WHERE (dateOfPresentation IS NULL AND FVdateOfPresentation IS NULL)",'awaiting Validation Followup',@uuid);