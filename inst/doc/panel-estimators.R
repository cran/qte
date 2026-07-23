## -----------------------------------------------------------------------------
#| label: setup
#| message: false
library(qte)
library(ptetools)
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

if (use_cache) {
  cached   <- readRDS(cache_file)
  res_cic  <- cached$res_cic
  res_qdid <- cached$res_qdid
  res_pqtt <- cached$res_pqtt
  res_ddid <- cached$res_ddid
  res_mdid <- cached$res_mdid
  res_lou  <- cached$res_lou
} else {
  res_cic <- cic(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "att", biters = 100
  )
  res_qdid <- qdid(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "att", biters = 100
  )
  res_pqtt <- panel_qtt(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
  )
  res_ddid <- ddid(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "att", biters = 100
  )
  res_mdid <- mdid(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "att", biters = 100
  )
  res_lou <- lou_qtt(
    yname  = "lemp", gname = "first.treat", tname = "year",
    idname = "countyreal", data = mpdta,
    gt_type = "att", biters = 100
  )
  saveRDS(
    list(res_cic = res_cic, res_qdid = res_qdid, res_pqtt = res_pqtt,
      res_ddid = res_ddid, res_mdid = res_mdid, res_lou = res_lou),
    cache_file
  )
}


## -----------------------------------------------------------------------------
#| label: cic-att
#| eval: false
# res_cic <- cic(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "att", biters = 100
# )
# summary(res_cic)


## -----------------------------------------------------------------------------
#| label: cic-att-output
#| echo: false
summary(res_cic)


## -----------------------------------------------------------------------------
#| label: qdid-att
#| eval: false
# res_qdid <- qdid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "att", biters = 100
# )
# summary(res_qdid)


## -----------------------------------------------------------------------------
#| label: qdid-att-output
#| echo: false
summary(res_qdid)


## -----------------------------------------------------------------------------
#| label: panel-qtt
#| eval: false
# res_pqtt <- panel_qtt(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "qtt", probs = seq(0.1, 0.9, 0.1), biters = 100
# )
# summary(res_pqtt)


## -----------------------------------------------------------------------------
#| label: panel-qtt-output
#| echo: false
summary(res_pqtt)


## -----------------------------------------------------------------------------
#| label: ddid-att
#| eval: false
# res_ddid <- ddid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "att", biters = 100
# )
# summary(res_ddid)


## -----------------------------------------------------------------------------
#| label: ddid-att-output
#| echo: false
summary(res_ddid)


## -----------------------------------------------------------------------------
#| label: mdid-att
#| eval: false
# res_mdid <- mdid(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "att", biters = 100
# )
# summary(res_mdid)


## -----------------------------------------------------------------------------
#| label: mdid-att-output
#| echo: false
summary(res_mdid)


## -----------------------------------------------------------------------------
#| label: lou-att
#| eval: false
# res_lou <- lou_qtt(
#   yname  = "lemp", gname = "first.treat", tname = "year",
#   idname = "countyreal", data = mpdta,
#   gt_type = "att", biters = 100
# )
# summary(res_lou)


## -----------------------------------------------------------------------------
#| label: lou-att-output
#| echo: false
summary(res_lou)

