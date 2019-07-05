SELECT
  pv_mask.area_id,
  pv_mask.year,
  ST_AsEWKB(areas.area_multi_polygon) geom,
  areas.area_name
FROM staging.gbd_zero_avi_mask pv_mask
  JOIN rds.area_insts areas ON pv_mask.area_id = areas.area_id
ORDER BY area_id, year;