# test_func <- function(par_mu, par_sd) {
#   samp <- rnorm(10^6, par_mu, par_sd)
#   c(s_mu = mean(samp), s_sd = sd(samp))
# }
# 
# pars <- data.frame(par_mu = 1:10,
#                    par_sd = seq(0.1, 1, length.out = 10))
# head(pars, 3)
# 
# library(rslurm)
# sjob <- slurm_apply(test_func, pars, jobname = 'test_apply',
#                     nodes = 2, cpus_per_node = 2, submit = FALSE)
# 
# 
# x <- iris[which(iris[,5] != "setosa"), c(1,5)]
# trials <- 10000
# res <- data.frame()
# system.time({
#   trial <- 1
#   while(trial <= trials) {
#     ind <- sample(100, 100, replace=TRUE)
#     result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
#     r <- coefficients(result1)
#     res <- rbind(res, r)
#     trial <- trial + 1
#   }
# })

#by lapply
library(parallel)
library(MASS)

x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- seq(1, 1000000)
boot_fx <- function(trial) {
  ind <- sample(10000, 10000, replace=TRUE)
  result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}

#system.time({
#  results <- lapply(trials, boot_fx)
#})

numCores <- detectCores()

system.time({
  results <- mclapply(trials, boot_fx, mc.cores = numCores)
})
