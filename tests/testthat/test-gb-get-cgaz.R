test_that("sf output", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(
    wrld <- gb_get_cgaz()
  )

  expect_true(sf::st_is_longlat(wrld))
  expect_s3_class(wrld, "sf")
  expect_gt(nrow(wrld), 150)

  and <- gb_get_cgaz("Andorra")

  expect_s3_class(and, "sf")
  expect_equal(nrow(and), 1)

  # What about level 2?
  lvl2 <- gb_get_cgaz("Andorra", adm_lvl = "ADM1")
  expect_true(sf::st_is_longlat(lvl2))
  expect_s3_class(lvl2, "sf")
  expect_gt(nrow(lvl2), 1)
  expect_true(all(lvl2$shapeGroup == "AND"))
  expect_true(all(lvl2$shapeType == "ADM1"))
})
