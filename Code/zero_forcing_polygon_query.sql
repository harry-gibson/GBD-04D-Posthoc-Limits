SELECT
  mask.area_id,
  mask.year,
  areas.area_dset_code,
  ST_AsEWKB(areas.area_multi_polygon) geom,
  areas.area_name
FROM (SELECT
        area_id,
        year
      FROM staging.gbd_zero_afi_mask
      UNION SELECT
              polys.shape_file_id,
              years.year
            FROM (SELECT 439375688 AS shape_file_id -- Heilongjiang
                  UNION SELECT 439378138 --  Jilin
                  UNION SELECT 439376967 -- Liaoning
                  UNION SELECT 439376363 -- Inner Mongolia/Nei Mongol
                 ) polys CROSS JOIN (SELECT DISTINCT year
                                     FROM staging.gbd_zero_afi_mask) years) mask
  JOIN rds.area_insts areas ON mask.area_id = areas.area_id
ORDER BY area_id, year;