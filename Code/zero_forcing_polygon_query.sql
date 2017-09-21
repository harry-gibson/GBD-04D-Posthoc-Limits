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
                  UNION (
                    SELECT area_id
                    FROM staging.gbd_api
                    WHERE iso_3_code = 'CHN'
                          AND admin_level != 'ADMIN0'
                          AND area_id NOT IN (
                      439378754, -- Hainan
                      439377079 -- Yunnan
                    ) AND area_id NOT IN (
                      -- All descendants of Hainan
                      SELECT (SELECT area_id
                              FROM rds.area_insts
                              WHERE area_fdef_id = hainan_descs.fdef_id
                                    AND area_fstp_code = 'MG_5K_GBD2017')
                      FROM rds.get_fdef_subunit_ids_and_levels(
                               (SELECT area_fdef_id
                                FROM rds.area_insts
                                WHERE area_id = 439378754),
                               '2015-01-01' :: DATE
                           ) hainan_descs
                    ) AND area_id NOT IN (
                      SELECT (SELECT area_id
                              FROM rds.area_insts
                              WHERE area_fdef_id = yunnan_descs.fdef_id
                                    AND area_fstp_code = 'MG_5K_GBD2017')
                      FROM rds.get_fdef_subunit_ids_and_levels(
                               (SELECT area_fdef_id
                                FROM rds.area_insts
                                WHERE area_id = 439377079),
                               '2015-01-01' :: DATE
                           ) yunnan_descs
                    )
                  )) polys CROSS JOIN (SELECT DISTINCT YEAR
                                       FROM staging.gbd_zero_afi_mask) YEARS) mask
  JOIN rds.area_insts areas ON mask.area_id = areas.area_id
ORDER BY area_id, year;