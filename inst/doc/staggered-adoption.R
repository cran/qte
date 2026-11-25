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

median_fit <- function(estimator) {
  estimator(
    yname = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = 0.5, biters = 100
  )
}

if (use_cache) {
  cached <- readRDS(cache_file)
} else {
  cached <- list()
  cached$res_qtt <- cic(
    yname   = "lemp",
    gname   = "first.treat",
    tname   = "year",
    idname  = "countyreal",
    data    = mpdta,
    biters  = 100,
    gt_type = "qtt",
    probs   = seq(0.1, 0.9, by = 0.1)
  )
  cached$res_att <- cic(
    yname   = "lemp",
    gname   = "first.treat",
    tname   = "year",
    idname  = "countyreal",
    data    = mpdta,
    biters  = 100,
    gt_type = "att"
  )
  cached$res_cic  <- median_fit(cic)
  cached$res_qdid <- median_fit(qdid)
  cached$res_pqtt <- median_fit(panel_qtt)
  cached$res_ddid <- median_fit(ddid)
  cached$res_mdid <- median_fit(mdid)
  cached$res_cdf  <- median_fit(cdf_did)
  cached$res_lou  <- median_fit(lou_qtt)
  cached$res_cdf_x <- cdf_did(
    yname      = "lemp",
    gname      = "first.treat",
    tname      = "year",
    idname     = "countyreal",
    data       = mpdta,
    xformula   = ~lpop,
    est_method = "aipw",
    biters     = 100,
    gt_type    = "qtt",
    probs      = seq(0.1, 0.9, by = 0.1)
  )
  cached$res_cic_x <- cic(
    yname     = "lemp",
    gname     = "first.treat",
    tname     = "year",
    idname    = "countyreal",
    data      = mpdta,
    xformula  = ~lpop,
    cond_dist = "dr",
    biters    = 100,
    gt_type   = "qtt",
    probs     = seq(0.1, 0.9, by = 0.1)
  )
  saveRDS(cached, cache_file)
}
list2env(cached, envir = environment())


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
#| fig-alt: "Overall QTT curve from cic(), with the overall ATT"
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
#| label: qtt-group
#| fig-alt: "Median QTT by treatment cohort"
autoplot(res_qtt, type = "group", plot_probs = 0.5)


## -----------------------------------------------------------------------------
#| label: qtt-minus-att
#| fig-alt: "QTT minus ATT across quantiles, with a uniform confidence band"
autoplot(res_qtt, type = "qtt_minus_att")


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
# # ... and the same call for qdid(), panel_qtt(), ddid(), mdid(), cdf_did()
# # and lou_qtt(), saved as res_qdid, res_pqtt, res_ddid, res_mdid, res_cdf
# # and res_lou


## -----------------------------------------------------------------------------
#| label: compare-table
median_qtt <- function(res, label) {
  row <- res$overall[res$overall$probs == 0.5, ]
  data.frame(estimator = label, qtt = round(row$qtt, 4), se = round(row$se, 4),
             att = round(res$att$overall$att, 4))
}

do.call(rbind, list(
  median_qtt(res_cic,  "cic()"),
  median_qtt(res_qdid, "qdid()"),
  median_qtt(res_pqtt, "panel_qtt()"),
  median_qtt(res_ddid, "ddid()"),
  median_qtt(res_mdid, "mdid()"),
  median_qtt(res_cdf,  "cdf_did()"),
  median_qtt(res_lou,  "lou_qtt()")
))


## -----------------------------------------------------------------------------
#| label: covariates
#| eval: false
# res_cdf_x <- cdf_did(
#   yname      = "lemp",
#   gname      = "first.treat",
#   tname      = "year",
#   idname     = "countyreal",
#   data       = mpdta,
#   xformula   = ~lpop,
#   est_method = "aipw",
#   biters     = 100,
#   gt_type    = "qtt",
#   probs      = seq(0.1, 0.9, by = 0.1)
# )
# 
# res_cic_x <- cic(
#   yname     = "lemp",
#   gname     = "first.treat",
#   tname     = "year",
#   idname    = "countyreal",
#   data      = mpdta,
#   xformula  = ~lpop,
#   cond_dist = "dr",
#   biters    = 100,
#   gt_type   = "qtt",
#   probs     = seq(0.1, 0.9, by = 0.1)
# )


## -----------------------------------------------------------------------------
#| label: covariates-plot-cdf
#| fig-alt: "Overall QTT curve from cdf_did() with covariates"
autoplot(res_cdf_x)


## -----------------------------------------------------------------------------
#| label: covariates-plot-cic
#| fig-alt: "Overall QTT curve from cic() with covariates"
autoplot(res_cic_x)


## -----------------------------------------------------------------------------
#| label: rcs-example
#| eval: false
# res_rcs <- cic(
#   yname   = "lemp",
#   gname   = "first.treat",
#   tname   = "year",
#   data    = mpdta,   # no idname
#   panel   = FALSE,
#   gt_type = "qtt",
#   biters  = 100
# )

