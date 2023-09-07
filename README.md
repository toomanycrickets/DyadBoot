# DyadBoot

R package that provides tools for analysing experimental data that pertains to dyads at the individual level. Randomly assigns the role of "focal" or "opposite" to each individual of each dyad. Performs bootstrapping of chosen model (so far only supports lm, glm, lmer, and glmer), reassigning the roles at each iteration of the bootstrapping to mitigate sampling bias. Output contains summary tables and Anova tables ('car' package) of all bootstapping iterations. Includes other functions and plotting capabilites (read vignette).

<img src="./images/imageee3.png" width="150" height="150">

