# Extracted from test-ci.R:40

# test -------------------------------------------------------------------------
suppressWarnings({
    sp1 <- spatt(re ~ treat,
      t = 1978, tmin1 = 1975, tname = "year",
      data = lalonde.psid.panel, idname = "id", se = FALSE
    )
  })
