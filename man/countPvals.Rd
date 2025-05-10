\name{countPvals}
\alias{countPvals}
\title{Count Significant p-values Across Bootstrapped Models}
\description{
This function counts how many times each predictor was statistically significant
(e.g., p-value < 0.05) across bootstrapped models. It supports both bootstrapped model summaries
(e.g., from \code{summary(glm())}) and Analysis of Deviance tables (e.g., from \code{car::Anova()}).
}
\usage{
countPvals(bootstrap_results, pval_threshold = 0.05)
}
\arguments{
  \item{bootstrap_results}{A list of model outputs, either with \code{summary()} or \code{Anova()} tables.}
  \item{pval_threshold}{A numeric value indicating the significance threshold (default is 0.05).}
}
\value{
A named numeric vector giving the count of bootstrap iterations in which each predictor's p-value was below the threshold.
}
\examples{
\dontrun{
# Using bootstrapped summaries
results <- bootstrap_lm(data, y ~ x, 100)
sig_counts <- countPvals(results$bootstrap_results)

# Using bootstrapped Anova results
results <- list()
for (i in 1:1000) {
  model <- glm(y ~ x1 * x2, data = some_data, family = binomial)
  results[[i]] <- car::Anova(model, type = 2)
}
sig_counts <- countPvals(results)
}
}
\author{
Your Name
}
\keyword{models}
\keyword{bootstrap}
\keyword{statistics}
