## -----------------------------------------------------------------------------
#| label: setup
#| message: false
library(qte)
library(ptetools)
library(ggplot2)
set.seed(42)
data(mpdta, package = "did")


## -----------------------------------------------------------------------------
#| label: compute-results
#| include: false
# Results are precomputed and cached so CRAN's vignette rebuild doesn't have
# to re-run the bootstrap on every check. Delete
# precomputed/panel-estimators-results.rds and re-render to regenerate after
# a code change (see CLAUDE.md).
cache_file <- "precomputed/panel-estimators-results.rds"
use_cache <- file.exists(cache_file)

fit <- function(estimator) {
  estimator(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
  )
}

if (use_cache) {
  cached <- readRDS(cache_file)
} else {
  cached <- list(
    res_cic  = fit(cic),
    res_qdid = fit(qdid),
    res_pqtt = fit(panel_qtt),
    res_ddid = fit(ddid),
    res_mdid = fit(mdid),
    res_cdf  = fit(cdf_did),
    res_lou  = fit(lou_qtt)
  )
  saveRDS(cached, cache_file)
}
list2env(cached, envir = environment())


## -----------------------------------------------------------------------------
#| label: cic
#| eval: false
# res_cic <- cic(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_cic)


## -----------------------------------------------------------------------------
#| label: cic-plot
#| echo: false
#| fig-alt: "Overall QTT curve from cic()"
autoplot(res_cic)


## -----------------------------------------------------------------------------
#| label: qdid
#| eval: false
# res_qdid <- qdid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_qdid)


## -----------------------------------------------------------------------------
#| label: qdid-plot
#| echo: false
#| fig-alt: "Overall QTT curve from qdid()"
autoplot(res_qdid)


## -----------------------------------------------------------------------------
#| label: panel-qtt
#| eval: false
# res_pqtt <- panel_qtt(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_pqtt)


## -----------------------------------------------------------------------------
#| label: panel-qtt-plot
#| echo: false
#| fig-alt: "Overall QTT curve from panel_qtt()"
autoplot(res_pqtt)


## -----------------------------------------------------------------------------
#| label: ddid
#| eval: false
# res_ddid <- ddid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_ddid)


## -----------------------------------------------------------------------------
#| label: ddid-plot
#| echo: false
#| fig-alt: "Overall QTT curve from ddid()"
autoplot(res_ddid)


## -----------------------------------------------------------------------------
#| label: mdid
#| eval: false
# res_mdid <- mdid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_mdid)


## -----------------------------------------------------------------------------
#| label: mdid-plot
#| echo: false
#| fig-alt: "Overall QTT curve from mdid()"
autoplot(res_mdid)


## -----------------------------------------------------------------------------
#| label: cdf-did
#| eval: false
# res_cdf <- cdf_did(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_cdf)


## -----------------------------------------------------------------------------
#| label: cdf-did-plot
#| echo: false
#| fig-alt: "Overall QTT curve from cdf_did()"
autoplot(res_cdf)


## -----------------------------------------------------------------------------
#| label: lou
#| eval: false
# res_lou <- lou_qtt(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# autoplot(res_lou)


## -----------------------------------------------------------------------------
#| label: lou-plot
#| echo: false
#| fig-alt: "Overall QTT curve from lou_qtt()"
autoplot(res_lou)

