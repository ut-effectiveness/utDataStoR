      --Space Inventory Rooms
        WITH cte_buildings AS (SELECT *
                                 FROM quad.buildings a
                                WHERE (building_to_term_id IS NULL OR building_to_term_id :: numeric > (SELECT DISTINCT
                                                                                                    term_id :: numeric
                                                                                               FROM quad.term
                                                                                              WHERE is_current_term))
                                  AND building_from_term_id :: numeric<= (SELECT DISTINCT
                                                                       term_id :: numeric
                                                                  FROM quad.term
                                                                 WHERE is_current_term)
                                  AND is_state_reported = TRUE
           )

      SELECT DISTINCT
             b.rooms_id,
             a.buildings_id,
             a.building_number,
             b.room_number,
             b.room_use_code,
             b.room_name,
             b.room_stations,
             b.room_area,
             b.room_disabled_access,
             b.room_prorated,
             b.room_prorated_area,
             b.room_activity_date,
             b.room_use_code_group,
             a.building_construction_year,
             a.building_activity_date,
             b.room_group1_code
        FROM cte_buildings a
   LEFT JOIN quad.rooms b
          ON b.building_id = a.buildings_id
       WHERE b.room_status_code = 'AC'
    ORDER BY a.buildings_id, b.room_number;
