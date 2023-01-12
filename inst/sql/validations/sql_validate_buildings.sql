-- Space Inventory Buildings
SELECT a.building_activity_date,
       a.building_area_gross,
       a.building_auxiliary,
       a.building_condition_code,
       a.building_condition_desc,
       a.building_construction_year,
       a.building_cost_myr,
       a.building_cost_replacement,
       a.building_location_code,
       a.building_location_desc,
       a.building_number,
       a.building_remodel_year,
       -- need to add to fake data for the below columns
       a.building_name,
       a.building_abbrv,
       a.building_number as building_risk_number,
       a.building_ownership_code
FROM quad.buildings a
WHERE is_state_reported
 AND (building_to_term_id IS NULL OR building_to_term_id > (SELECT DISTINCT term_id FROM quad.term WHERE is_current_term))
 AND building_from_term_id <= (SELECT DISTINCT term_id FROM quad.term WHERE is_current_term)
