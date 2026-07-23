## -----------------------------------------------------------------------------
#| label: setup
#| message: false
library(qte)
library(ggplot2)
library(ptetools)
set.seed(42)
data(mpdta, package = "did")


## -----------------------------------------------------------------------------
#| label: compute-results
#| include: false
# Results are precomputed and cached so CRAN's vignette rebuild doesn't have
# to re-run the bootstrap on every check. Delete
# precomputed/staggered-adoption-results.rds and re-render to regenerate
# after a code change (see CLAUDE.md).
cache_file <- "precomputed/staggered-adoption-results.rds"
use_cache <- file.exists(cache_file)

if (use_cache) {
  cached   <- readRDS(cache_file)
  res_qtt  <- cached$res_qtt
  res_att  <- cached$res_att
  res_cic  <- cached$res_cic
  res_qdid <- cached$res_qdid
  res_pqtt <- cached$res_pqtt
  res_ddid <- cached$res_ddid
  res_mdid <- cached$res_mdid
  res_lou  <- cached$res_lou
} else {
  res_qtt <- cic(
    yname   = "lemp",
    gname   = "first.treat",
    tname   = "year",
    idname  = "countyreal",
    data    = mpdta,
    biters  = 100,
    gt_type = "qtt",
    probs   = seq(0.1, 0.9, by = 0.1)
  )

  res_att <- cic(
    yname   = "lemp",
    gname   = "first.treat",
    tname   = "year",
    idname  = "countyreal",
    data    = mpdta,
    biters  = 100,
    gt_type = "att"
  )

  res_cic <- cic(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  res_qdid <- qdid(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  res_pqtt <- panel_qtt(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  res_ddid <- ddid(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  res_mdid <- mdid(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  res_lou <- lou_qtt(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )

  saveRDS(
    list(res_qtt = res_qtt, res_att = res_att, res_cic = res_cic,
         res_qdid = res_qdid, res_pqtt = res_pqtt, res_ddid = res_ddid,
         res_mdid = res_mdid, res_lou = res_lou),
    cache_file
  )
}


## -----------------------------------------------------------------------------
#| label: data-summary
table(mpdta$first.treat)


## -----------------------------------------------------------------------------
#| label: qtt-estimate
#| eval: false
# res_qtt <- cic(
#   yname   = "lemp",
#   gname   = "first.treat",
#   tname   = "year",
#   idname  = "countyreal",
#   data    = mpdta,
#   biters  = 100,
#   gt_type = "qtt",
#   probs   = seq(0.1, 0.9, by = 0.1)
# )


## -----------------------------------------------------------------------------
#| label: qtt-summary
summary(res_qtt)


## -----------------------------------------------------------------------------
#| label: qtt-plot
#| fig-alt: "Overall QTT curve from cic()"
autoplot(res_qtt)


## -----------------------------------------------------------------------------
#| label: qtt-dynamic-single
#| fig-alt: "Event-study plot for the median QTT"
autoplot(res_qtt, type = "dynamic", plot_probs = 0.5)


## -----------------------------------------------------------------------------
#| label: qtt-dynamic-multi
#| fig-alt: "Event-study plot for multiple quantiles of the QTT"
autoplot(res_qtt, type = "dynamic", plot_probs = c(0.1, 0.5, 0.9))


## -----------------------------------------------------------------------------
#| label: att-estimate
#| eval: false
# res_att <- cic(
#   yname   = "lemp",
#   gname   = "first.treat",
#   tname   = "year",
#   idname  = "countyreal",
#   data    = mpdta,
#   biters  = 100,
#   gt_type = "att"
# )
# summary(res_att)


## -----------------------------------------------------------------------------
#| label: att-estimate-output
#| echo: false
summary(res_att)


## -----------------------------------------------------------------------------
#| label: att-event-study
#| fig-alt: "Event-study plot of ATT estimates by event time"
autoplot(res_att, type = "dynamic")


## -----------------------------------------------------------------------------
#| label: compare-estimators
#| eval: false
# res_cic <- cic(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )
# 
# res_qdid <- qdid(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )
# 
# res_pqtt <- panel_qtt(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )
# 
# res_ddid <- ddid(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )
# 
# res_mdid <- mdid(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )
# 
# res_lou <- lou_qtt(
#   yname = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = 0.5, biters = 100
# )


## -----------------------------------------------------------------------------
#| label: compare-table
median_qtt <- function(res, label) {
  row <- res$overall[res$overall$probs == 0.5, ]
  data.frame(estimator = label, qtt = round(row$qtt, 4), se = round(row$se, 4))
}

do.call(rbind, list(
  median_qtt(res_cic,  "cic()"),
  median_qtt(res_qdid, "qdid()"),
  median_qtt(res_pqtt, "panel_qtt()"),
  median_qtt(res_ddid, "ddid()"),
  median_qtt(res_mdid, "mdid()"),
  median_qtt(res_lou,  "lou_qtt()")
))


## -----------------------------------------------------------------------------
#| label: rcs-example
#| eval: false
# res_rcs <- cic(
#   yname  = "lemp",
#   gname  = "first.treat",
#   tname  = "year",
#   data   = mpdta,   # no idname
#   panel  = FALSE,
#   biters = 100
# )

