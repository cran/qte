## -----------------------------------------------------------------------------
#| label: setup
#| message: false
library(qte)
library(ggplot2)
set.seed(42)
data(lalonde)
xf <- ~ age + I(age^2) + education + black + hispanic + married + nodegree


## -----------------------------------------------------------------------------
#| label: compute-results
#| include: false
# Results are precomputed and cached so CRAN's vignette rebuild doesn't have
# to re-run the bootstrap on every check. Delete precomputed/intro-results.rds
# and re-render to regenerate after a code change (see CLAUDE.md).
cache_file <- "precomputed/intro-results.rds"
use_cache <- file.exists(cache_file)

if (use_cache) {
  cached   <- readRDS(cache_file)
  res_exp  <- cached$res_exp
  res_psid <- cached$res_psid
  res_qtt  <- cached$res_qtt
} else {
  res_exp <- unc_qte(
    yname  = "re78",
    dname  = "treat",
    data   = lalonde.exp,
    target = "qte",
    probs  = seq(0.1, 0.9, 0.1),
    biters = 100
  )
  res_psid <- unc_qte(
    yname      = "re78",
    dname      = "treat",
    data       = lalonde.psid,
    xformula   = xf,
    est_method = "aipw",
    target     = "qte",
    probs      = seq(0.1, 0.9, 0.1),
    biters     = 100
  )
  res_qtt <- unc_qte(
    yname      = "re78",
    dname      = "treat",
    data       = lalonde.psid,
    xformula   = xf,
    est_method = "aipw",
    target     = "qtt",
    probs      = seq(0.1, 0.9, 0.1),
    biters     = 100
  )
  # pscore.reg (the fitted propensity score model) is never read by
  # summary()/autoplot(); dropping it keeps the cache small.
  save_psid <- res_psid; save_psid$pscore.reg <- NULL
  save_qtt  <- res_qtt;  save_qtt$pscore.reg  <- NULL
  saveRDS(list(res_exp = res_exp, res_psid = save_psid, res_qtt = save_qtt), cache_file)
}


## -----------------------------------------------------------------------------
#| label: random-qte
#| eval: false
# res_exp <- unc_qte(
#   yname  = "re78",
#   dname  = "treat",
#   data   = lalonde.exp,
#   target = "qte",
#   probs  = seq(0.1, 0.9, 0.1),
#   biters = 100
# )
# summary(res_exp)


## -----------------------------------------------------------------------------
#| label: random-qte-output
#| echo: false
summary(res_exp)


## -----------------------------------------------------------------------------
#| label: random-qte-plot
#| fig-alt: "QTE curve under random assignment"
autoplot(res_exp, ylab = "QTE (earnings, 1978)")


## -----------------------------------------------------------------------------
#| label: obs-qte
#| eval: false
# xf <- ~ age + I(age^2) + education + black + hispanic + married + nodegree
# 
# res_psid <- unc_qte(
#   yname      = "re78",
#   dname      = "treat",
#   data       = lalonde.psid,
#   xformula   = xf,
#   est_method = "aipw",
#   target     = "qte",
#   probs      = seq(0.1, 0.9, 0.1),
#   biters     = 100
# )
# summary(res_psid)


## -----------------------------------------------------------------------------
#| label: obs-qte-output
#| echo: false
summary(res_psid)


## -----------------------------------------------------------------------------
#| label: obs-qte-plot
#| fig-alt: "QTE curve under unconfoundedness"
autoplot(res_psid, ylab = "QTE (earnings, 1978)")


## -----------------------------------------------------------------------------
#| label: qtt
#| eval: false
# res_qtt <- unc_qte(
#   yname      = "re78",
#   dname      = "treat",
#   data       = lalonde.psid,
#   xformula   = xf,
#   est_method = "aipw",
#   target     = "qtt",
#   probs      = seq(0.1, 0.9, 0.1),
#   biters     = 100
# )
# summary(res_qtt)


## -----------------------------------------------------------------------------
#| label: qtt-output
#| echo: false
summary(res_qtt)


## -----------------------------------------------------------------------------
#| label: qtt-plot
#| fig-alt: "QTT curve under unconfoundedness"
autoplot(res_qtt, ylab = "QTT (earnings, 1978)")


## -----------------------------------------------------------------------------
#| label: custom-plot
#| eval: false
# autoplot(res_qtt) +
#   ggplot2::labs(title = "QTT — Lalonde (observational)",
#                 subtitle = "AIPW with pre-treatment covariates")

