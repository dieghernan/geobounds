test_that("metadata converts a single response without losing text fields", {
  local_metadata_responses(list(`gbOpen/PRT/ADM0` = metadata_record()))

  result <- gb_get_metadata("Portugal", "adm0")

  expect_s3_class(result, "tbl_df")
  expect_identical(result$boundaryISO, "PRT")
  expect_identical(result$boundaryType, "ADM0")
  expect_identical(result$boundaryLicense, "CC BY 4.0")
  expect_identical(result$admUnitCount, 2)
  expect_identical(result$meanAreaSqKM, NA_real_)
  expect_identical(result$buildDate, as.Date("2023-01-03"))
  expect_identical(
    format(result$sourceDataUpdateDate, "%Y-%m-%d %H:%M:%S", tz = "GMT"),
    "2023-01-02 03:04:05"
  )
})

test_that("metadata combines multiple countries and administrative levels", {
  local_metadata_responses(list(
    `gbOpen/PRT/ALL` = list(metadata_record(), metadata_record("PRT", "ADM1")),
    `gbOpen/ITA/ALL` = list(metadata_record("ITA", "ADM0"))
  ))

  result <- gb_get_metadata(c("Portugal", "Italy"))

  expect_identical(result$boundaryISO, c("PRT", "PRT", "ITA"))
  expect_identical(result$boundaryType, c("ADM0", "ADM1", "ADM0"))
})

test_that("metadata selects the release and level for all countries", {
  local_metadata_responses(list(
    `gbHumanitarian/ALL/ADM1` = list(metadata_record("PRT", "ADM1"))
  ))

  result <- gb_get_metadata(c("all", "Spain"), "adm1", "gbHumanitarian")

  expect_identical(result$boundaryISO, "PRT")
  expect_identical(result$boundaryType, "ADM1")
})

test_that("metadata returns an empty table when a boundary is unavailable", {
  local_metadata_responses(list(`gbOpen/ESP/ADM5` = NULL))

  expect_message(result <- gb_get_metadata("ESP", "ADM5"), "404")

  expect_s3_class(result, "tbl_df")
  expect_identical(nrow(result), 0L)
})

test_that("metadata keeps successes alongside missing boundaries", {
  local_metadata_responses(list(
    `gbOpen/ESP/ADM2` = NULL,
    `gbOpen/AND/ADM2` = metadata_record("AND", "ADM2"),
    `gbOpen/ATA/ADM2` = NULL
  ))

  expect_message(
    result <- gb_get_metadata(c("ESP", "AND", "ATA"), "ADM2"),
    "404"
  )

  expect_identical(result$boundaryISO, "AND")
  expect_identical(result$boundaryType, "ADM2")
})

test_that("live metadata includes the requested country and level", {
  skip_on_cran()
  skip_if_offline()

  result <- gb_get_metadata("Portugal", "ADM0")

  expect_s3_class(result, "tbl_df")
  expect_identical(result$boundaryISO, "PRT")
  expect_identical(result$boundaryType, "ADM0")
})
