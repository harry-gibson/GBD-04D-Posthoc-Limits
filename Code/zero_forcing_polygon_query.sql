SELECT
  pf_mask.area_id,
  pf_mask.year,
  areas.area_dset_code,
  ST_AsEWKB(areas.area_multi_polygon) geom,
  areas.area_name
FROM staging.gbd_zero_afi_mask pf_mask
  JOIN rds.area_insts areas ON pf_mask.area_id = areas.area_id
ORDER BY area_id, year;