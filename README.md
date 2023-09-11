# DyadBoot

R package that provides tools for analysing experimental dyad data at the individual level. Randomly assigns the role of "focal" or "opposite" to each individual of each dyad. Performs bootstrapping of chosen model (so far only supports lm, glm, lmer, and glmer), reassigning the "focal" and "opposite" roles at each iteration of the bootstrapping to mitigate sampling bias. Output contains summary tables and Anova tables ('car' package) of all bootstapping iterations. Includes other functions for summary statistics and plotting capabilites (read vignette).

<img src="./images/imageee3.png" width="150" height="150">

## Introduction

`DyadBoot` provides tools for dyadic random bootstrapping and analysis.
It is indicated for experimental data involving dyads, in which effects
want to be explored at the individual level. It is important to note
that it requires 1) there to be a column pertaining to the Dyad
(e.g. “Dyad\_id”), 2) that each invidual is on a different row, and 3)
for individuals belonging to the same dyad to be in adjecent rows.
Example provided below:

-Example-

Original Data

    library(knitr)

    data <- data.frame(
      Dyad_id = c("Trial1", "Trial1", "Trial2", "Trial2", "Trial3", "Trial3"),
      Individual = c(100, 101, 102, 103, 104, 105),
      Treatment = c("High protein", "Low protein", "Low protein", "High protein", "High protein", "Low protein"),
      Body_Size = c(0.5, 0.433, 0.552, 0.601, 0.342, 0.56)
    )

    kable(data)

<table>
<thead>
<tr class="header">
<th style="text-align: left;">Dyad_id</th>
<th style="text-align: right;">Individual</th>
<th style="text-align: left;">Treatment</th>
<th style="text-align: right;">Body_Size</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Trial1</td>
<td style="text-align: right;">100</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: right;">0.500</td>
</tr>
<tr class="even">
<td style="text-align: left;">Trial1</td>
<td style="text-align: right;">101</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: right;">0.433</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Trial2</td>
<td style="text-align: right;">102</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: right;">0.552</td>
</tr>
<tr class="even">
<td style="text-align: left;">Trial2</td>
<td style="text-align: right;">103</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: right;">0.601</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Trial3</td>
<td style="text-align: right;">104</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: right;">0.342</td>
</tr>
<tr class="even">
<td style="text-align: left;">Trial3</td>
<td style="text-align: right;">105</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: right;">0.560</td>
</tr>
</tbody>
</table>

With DyadBoot::randOne, DyadBoot::randMult or DyadBoot::randBoot

    library(knitr)

    data <- data.frame(
      Dyad_id = c("Trial1", "Trial2", "Trial3"),
      focal_Individual = c(100, 102, 104),
      opposite_Individual = c(101, 103, 105),
      focal_Treatment = c("High protein", "Low protein", "High protein"),
      opposite_Treatment = c("Low protein", "High protein", "Low protein"),
      focal_Body_Size = c(0.5, 0.552, 0.342),
      opposite_Body_Size = c(0.433, 0.601, 0.56)
    )

    kable(data)

<table>
<colgroup>
<col style="width: 6%" />
<col style="width: 14%" />
<col style="width: 17%" />
<col style="width: 13%" />
<col style="width: 16%" />
<col style="width: 13%" />
<col style="width: 16%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Dyad_id</th>
<th style="text-align: right;">focal_Individual</th>
<th style="text-align: right;">opposite_Individual</th>
<th style="text-align: left;">focal_Treatment</th>
<th style="text-align: left;">opposite_Treatment</th>
<th style="text-align: right;">focal_Body_Size</th>
<th style="text-align: right;">opposite_Body_Size</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Trial1</td>
<td style="text-align: right;">100</td>
<td style="text-align: right;">101</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: right;">0.500</td>
<td style="text-align: right;">0.433</td>
</tr>
<tr class="even">
<td style="text-align: left;">Trial2</td>
<td style="text-align: right;">102</td>
<td style="text-align: right;">103</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: right;">0.552</td>
<td style="text-align: right;">0.601</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Trial3</td>
<td style="text-align: right;">104</td>
<td style="text-align: right;">105</td>
<td style="text-align: left;">High protein</td>
<td style="text-align: left;">Low protein</td>
<td style="text-align: right;">0.342</td>
<td style="text-align: right;">0.560</td>
</tr>
</tbody>
</table>

## Installation

Install the package from GitHub using `devtools`:

    install.packages("devtools")
    devtools::install_github("toomanycrickets/DyadBoot")

## Functions:

1.  ‘randBoot’ - Randomly assigns the role of “focal” and “opposite” to
    each individual of each dyad. Bootstrapping is then performed on the
    chosen model (package only supports lm, glm, lmer, and glmer so
    far). The random assignment of “focal” and “ooposite” roles occurs
    at every iteration of the bootstrapping to mitigate random sampling
    bias. The output includes
    “results$bootstrap\_results", a string of all summary tables from each bootstrapping iteration, and "results$anova\_results”,
    a string of all Anova tables from each bootstrapping iteration.

<!-- -->

    model_formula <- dependent_variable ~ independent_variable #specify model formula. It takes the format generated by the randBoot function with the "focal" and "opposite" roles attributed. Example: model_formula <- focal_aggression ~ opposite_mass

    results <- DyadBoot::randBoot(data = data,
                               dyad_id_col = "dyad_id",
                               model_formula = model_formula,
                               model_type = "lm",
                               n_bootstraps = 1000,
                               focal_cols = c("dependent_variable"), 
                               opposite_cols = c("dependent_variable"))

    #"focal_cols" and "opposite_cols" both take the original name of the variable, without the attribution of "focal" or "opposite". Must be same variable. 
    #Example: (...) focal_cols = c("aggression"), 
                   #opposite_cols = c("aggression"))
                   
    results$bootstrap_results #for list of all summary(model) performed in the bootstrapping
    results$anova_results #for list of all car::Anova(model) performed in the bootstrapping

------------------------------------------------------------------------

1.  ‘randOne’ - To only perform the random assignment of roles without
    performing the bootstrapping step. Returns a dataset called
    “focal\_opposite\_data”. Useful for testing model assumptions before
    analysis.

<!-- -->

    focal_opposite_data <- DyadBoot::randOne(data = data, dyad_id_col = "your_dyad_column_name")

------------------------------------------------------------------------

1.  ‘randMult’ - To perform the random assignment of roles a specified
    number of times without performing the bootstrapping step. Returns a
    list with all datasets.

<!-- -->

    resultsMult <- randMult(data, dyad_id_col = "your_dyad_column_name", num_iterations = number_of_iterations_desired)

    resultsMult$results_list #access all datasets

------------------------------------------------------------------------

1.  ‘repDataSet’ - Takes ‘randMult’ output as input and chooses the most
    representative dataset for the particular variables specified
    (whereby the mean for that dataset is closest to the overall mean of
    all datasets generated by randMult). Can handle up to two categorical variables.
    Also provides a dataframe that contains the mean for the categorical variable(s) of interested for all
    its levels - for all datasets (the number of rows in this dataframe
    is the number of datasets).

<!-- -->

    rep_data<- DyadBoot::repDataSet(resultsMult, "numerical_variable", "categorical_variable1", "categorical_variable2")

    rep_data$closest_data #access most representative dataset
    rep_data$each_dataset_means #access dataframe with means for each level of the categorical variable for each dataset generated by randMult

------------------------------------------------------------------------

1.  ‘averages’ - Takes the output of DyadBoot::randBoot as input and
    returns a table with the averages of all coeficients (e.g. estimate,
    standard error, z-value, p-value) (for each tested factor) from all
    iterations of the bootstrapping. Also provides standard errors of
    these averages).

<!-- -->

    DyadBoot::averages(results$bootstrap_results)

------------------------------------------------------------------------

1.  ‘anovaPvals’ - Extracts all P-values from the Anova output generated
    by DyadBoot::randBoot (results$anova\_results) for the specified
    factor.

<!-- -->

    pvals<-DyadBoot::anovaPvals(results$anova_results, "factor_name")

------------------------------------------------------------------------

1.  ‘MeanOfMeans’ - Calculates the overall mean of all bootstrap
    iterations of a specified numerical variable for all levels of up to two
    specified categorical variables.

<!-- -->

    overall_means <- DyadBoot::MeanOfMeans(mrep_data$each_dataset_means, "numerical_variable", "categorical_variable1", "categorical_variable2") 

    #each_dataset_means is one of the outputs of DyadBoot::repDataSet, a dataframe that contains the mean for the categorical variable of interested for all its levels - for each dataset generated by DyadBoot::randMult. 

------------------------------------------------------------------------

1.  ‘histMeans’ - Histogram of distribution of means for specified level
    of specified categorical variable.

<!-- -->

    histMeans(each_dataset_means, numerical_variable, categorical_variable, level) #each_dataset_means is one of the outputs of DyadBoot::repDataSet, a dataframe that contains the mean for the categorical variable of interested for all its levels (can be accessed via rep_data$each_dataset_means) - for each dataset generated by DyadBoot::randMult. 

------------------------------------------------------------------------

1.  ‘histPvals’ - Histogram of the distribution of all p-values for the
    selected factor. Text within the plot specifies the number of
    iterations that the selected factor had a significant p-value.

<!-- -->

    DyadBoot::histPvals(results$bootstrap_results, coeff_name = "your_coefficient_name")

------------------------------------------------------------------------

1.  -   ‘plotBoot’ - Two grid plot. Left grid -raincloud plot (with
        boxplot) of the most representative dataset with overlay of
        overall mean for the specified variable. Handles up to two
        categorical variables. Right grid - Histogram of pvalues
        with red dashed line at 0.05.

<!-- -->

    plot1<-DyadBoot::plotBoot(rep_data$closest_data, "numerical_variable", "categorical_variable1", "categorical_variable2", overall_means = overall_means, 
                   xlab_name = "name", ylab_name = "name", main_title = "name", p_values = pvals)
                   
    plot1 #to generate plot

    #overall_means is the output of fucntion DyadBoot::MeanOfMeans
    #pvals is list of p-values of factor of interest, output of DyadBoot::anovaPvals.



## Running functions with example data:

    library(DyadBoot)

    ## Loading required package: lme4

    ## Loading required package: Matrix

    ## Loading required package: car

    ## Loading required package: carData

    data("mydata", package = "DyadBoot")
    # Check if the dataset is loaded correctly
    if (!exists("mydata")) {
      stop("The 'mydata' dataset could not be loaded.")
    }
    head(mydata)

    ##   dyad_id group song ind tmass morph line dant  dantlog
    ## 1 AN1.1.3     A    N 164 0.703    Nw    1  7.4 2.128232
    ## 2 AN1.1.3     A    N 165 0.516    Nw    1 17.4 2.912351
    ## 3 AN1.5.1     A    N 503 0.613    Nw    5 24.8 3.250374
    ## 4 AN1.5.1     A    N 108 0.467    Nw    1 29.8 3.427515
    ## 5 AN1.5.2     A    N 101 0.411    Nw    1  9.6 2.360854
    ## 6 AN1.5.2     A    N 501 0.515    Nw    5 10.0 2.397895

    mydata$dantlog <- log(mydata$dant + 1)

    model_formula <- focal_dantlog ~ focal_group * focal_song #specify model formula. It takes the format generated by the randBoot function with the "focal" and "opposite" roles attributed. Example: model_formula <- focal_aggression ~ opposite_mass

    results <- DyadBoot::randBoot(data = mydata,
                                  dyad_id_col = "dyad_id",
                                  model_formula = model_formula,
                                  model_type = "lm",
                                  n_bootstraps = 1000,
                                  focal_cols = c("dantlog"), 
                                  opposite_cols = c("dantlog"))

    #"focal_cols" and "opposite_cols" both take the original name of the variable, without the attribution of "focal" or "opposite". Must be same variable. 
    #Example: (...) focal_cols = c("aggression"), 
    #opposite_cols = c("aggression"))

    head(results$bootstrap_results) #for list of all summary(model) performed in the bootstrapping

    ## [[1]]
    ## [[1]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                   2.4860                   -0.8271                   -1.0082  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                   0.1505                    0.2470                    1.1865  
    ## 
    ## 
    ## [[1]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -2.63643 -0.44159  0.07193  0.59975  2.35957 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                2.4860     0.2180  11.405  < 2e-16 ***
    ## focal_groupB              -0.8271     0.2849  -2.903 0.004369 ** 
    ## focal_groupC              -1.0082     0.2965  -3.401 0.000903 ***
    ## focal_songY                0.1505     0.2932   0.513 0.608742    
    ## focal_groupB:focal_songY   0.2470     0.3817   0.647 0.518776    
    ## focal_groupC:focal_songY   1.1865     0.4138   2.867 0.004862 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.8987 on 125 degrees of freedom
    ## Multiple R-squared:  0.2287, Adjusted R-squared:  0.1979 
    ## F-statistic: 7.413 on 5 and 125 DF,  p-value: 4.047e-06
    ## 
    ## 
    ## 
    ## [[2]]
    ## [[2]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                  2.34717                  -0.67863                  -0.90410  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                  0.34377                   0.09238                   0.72356  
    ## 
    ## 
    ## [[2]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.5104 -0.4370  0.1038  0.6593  2.3942 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               2.34717    0.22515  10.425  < 2e-16 ***
    ## focal_groupB             -0.67863    0.29428  -2.306  0.02275 *  
    ## focal_groupC             -0.90410    0.30624  -2.952  0.00377 ** 
    ## focal_songY               0.34377    0.30287   1.135  0.25854    
    ## focal_groupB:focal_songY  0.09238    0.39426   0.234  0.81513    
    ## focal_groupC:focal_songY  0.72356    0.42743   1.693  0.09298 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.9283 on 125 degrees of freedom
    ## Multiple R-squared:  0.1853, Adjusted R-squared:  0.1527 
    ## F-statistic: 5.686 on 5 and 125 DF,  p-value: 9.263e-05
    ## 
    ## 
    ## 
    ## [[3]]
    ## [[3]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                  2.38612                  -0.53893                  -0.82305  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                  0.25721                   0.02026                   0.81646  
    ## 
    ## 
    ## [[3]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -2.64333 -0.53564  0.07256  0.63441  2.27423 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               2.38612    0.22469  10.620  < 2e-16 ***
    ## focal_groupB             -0.53893    0.29367  -1.835  0.06886 .  
    ## focal_groupC             -0.82305    0.30561  -2.693  0.00805 ** 
    ## focal_songY               0.25721    0.30224   0.851  0.39639    
    ## focal_groupB:focal_songY  0.02026    0.39344   0.051  0.95901    
    ## focal_groupC:focal_songY  0.81646    0.42655   1.914  0.05789 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.9264 on 125 degrees of freedom
    ## Multiple R-squared:  0.1528, Adjusted R-squared:  0.1189 
    ## F-statistic: 4.509 on 5 and 125 DF,  p-value: 0.0008203
    ## 
    ## 
    ## 
    ## [[4]]
    ## [[4]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                  2.41497                  -0.70016                  -0.95642  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                  0.02261                   0.51118                   1.34334  
    ## 
    ## 
    ## [[4]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.4376 -0.4828  0.1199  0.5326  2.3788 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               2.41497    0.21638  11.161  < 2e-16 ***
    ## focal_groupB             -0.70016    0.28282  -2.476  0.01464 *  
    ## focal_groupC             -0.95642    0.29431  -3.250  0.00148 ** 
    ## focal_songY               0.02261    0.29107   0.078  0.93822    
    ## focal_groupB:focal_songY  0.51118    0.37890   1.349  0.17974    
    ## focal_groupC:focal_songY  1.34334    0.41078   3.270  0.00139 ** 
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.8922 on 125 degrees of freedom
    ## Multiple R-squared:  0.2041, Adjusted R-squared:  0.1722 
    ## F-statistic:  6.41 on 5 and 125 DF,  p-value: 2.463e-05
    ## 
    ## 
    ## 
    ## [[5]]
    ## [[5]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                   2.2925                   -0.5420                   -0.7008  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                   0.1776                    0.2385                    0.9850  
    ## 
    ## 
    ## [[5]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.4701 -0.4931  0.1360  0.5218  3.3987 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                2.2925     0.2297   9.980   <2e-16 ***
    ## focal_groupB              -0.5420     0.3002  -1.805   0.0734 .  
    ## focal_groupC              -0.7008     0.3124  -2.243   0.0267 *  
    ## focal_songY                0.1776     0.3090   0.575   0.5666    
    ## focal_groupB:focal_songY   0.2385     0.4022   0.593   0.5543    
    ## focal_groupC:focal_songY   0.9850     0.4361   2.259   0.0256 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.9471 on 125 degrees of freedom
    ## Multiple R-squared:  0.1458, Adjusted R-squared:  0.1117 
    ## F-statistic: 4.268 on 5 and 125 DF,  p-value: 0.001286
    ## 
    ## 
    ## 
    ## [[6]]
    ## [[6]]$model
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Coefficients:
    ##              (Intercept)              focal_groupB              focal_groupC  
    ##                   2.4703                   -0.7145                   -0.9606  
    ##              focal_songY  focal_groupB:focal_songY  focal_groupC:focal_songY  
    ##                   0.0896                    0.2574                    1.0147  
    ## 
    ## 
    ## [[6]]$summary
    ## 
    ## Call:
    ## lm(formula = model_formula, data = focal_opposite_data)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -2.6140 -0.4802  0.1586  0.5219  2.3276 
    ## 
    ## Coefficients:
    ##                          Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                2.4703     0.2249  10.982  < 2e-16 ***
    ## focal_groupB              -0.7145     0.2940  -2.430  0.01651 *  
    ## focal_groupC              -0.9606     0.3059  -3.140  0.00211 ** 
    ## focal_songY                0.0896     0.3026   0.296  0.76764    
    ## focal_groupB:focal_songY   0.2574     0.3939   0.653  0.51466    
    ## focal_groupC:focal_songY   1.0147     0.4270   2.376  0.01901 *  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.9274 on 125 degrees of freedom
    ## Multiple R-squared:  0.1643, Adjusted R-squared:  0.1308 
    ## F-statistic: 4.913 on 5 and 125 DF,  p-value: 0.0003864

    head(results$anova_results) #for list of all car::Anova(model) performed in the bootstrapping

    ## [[1]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                         Sum Sq  Df F value    Pr(>F)    
    ## focal_group             10.787   2  6.6775 0.0017568 ** 
    ## focal_song              11.685   1 14.4658 0.0002221 ***
    ## focal_group:focal_song   7.599   2  4.7036 0.0107269 *  
    ## Residuals              100.967 125                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## [[2]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                         Sum Sq  Df F value    Pr(>F)    
    ## focal_group              9.673   2  5.6122 0.0046339 ** 
    ## focal_song              11.428   1 13.2606 0.0003955 ***
    ## focal_group:focal_song   3.048   2  1.7683 0.1748681    
    ## Residuals              107.724 125                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## [[3]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                         Sum Sq  Df F value   Pr(>F)   
    ## focal_group              6.605   2  3.8482 0.023889 * 
    ## focal_song               8.243   1  9.6050 0.002398 **
    ## focal_group:focal_song   4.341   2  2.5290 0.083816 . 
    ## Residuals              107.278 125                    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## [[4]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                        Sum Sq  Df F value    Pr(>F)    
    ## focal_group             3.956   2  2.4852 0.0874133 .  
    ## focal_song             12.813   1 16.0974 0.0001029 ***
    ## focal_group:focal_song  8.722   2  5.4791 0.0052366 ** 
    ## Residuals              99.495 125                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## [[5]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                         Sum Sq  Df F value    Pr(>F)    
    ## focal_group              3.854   2  2.1480 0.1210022    
    ## focal_song              10.349   1 11.5371 0.0009152 ***
    ## focal_group:focal_song   5.093   2  2.8392 0.0622509 .  
    ## Residuals              112.125 125                      
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## [[6]]
    ## Anova Table (Type II tests)
    ## 
    ## Response: focal_dantlog
    ##                         Sum Sq  Df F value   Pr(>F)   
    ## focal_group              7.719   2  4.4869 0.013126 * 
    ## focal_song               7.899   1  9.1837 0.002968 **
    ## focal_group:focal_song   5.357   2  3.1140 0.047885 * 
    ## Residuals              107.518 125                    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    resultsMult <- DyadBoot::randMult(mydata, dyad_id_col = "dyad_id", num_iterations = 1000)

    rep_data<- DyadBoot::repDataSet(resultsMult, "focal_dant", "focal_group", "focal_song")

    head(rep_data$closest_data) #access most representative dataset

    ##         focal_dyad_id focal_group focal_song focal_ind focal_tmass focal_morph focal_line
    ## AN1.1.3       AN1.1.3           A          N       165       0.516          Nw          1
    ## AN1.5.1       AN1.5.1           A          N       503       0.613          Nw          5
    ## AN1.5.2       AN1.5.2           A          N       501       0.515          Nw          5
    ## AN1.5.3       AN1.5.3           A          N       569       0.571          Nw          5
    ## AN1.5.4       AN1.5.4           A          N       136       0.647          Nw          1
    ## AN1.5.5       AN1.5.5           A          N       137       0.521          Nw          1
    ##         focal_dant focal_dantlog opposite_dyad_id opposite_group opposite_song opposite_ind
    ## AN1.1.3       17.4     2.9123507          AN1.1.3              A             N          164
    ## AN1.5.1       24.8     3.2503745          AN1.5.1              A             N          108
    ## AN1.5.2       10.0     2.3978953          AN1.5.2              A             N          101
    ## AN1.5.3       43.2     3.7887248          AN1.5.3              A             N          133
    ## AN1.5.4       21.4     3.1090610          AN1.5.4              A             N          575
    ## AN1.5.5        1.6     0.9555114          AN1.5.5              A             N          576
    ##         opposite_tmass opposite_morph opposite_line opposite_dant opposite_dantlog
    ## AN1.1.3          0.703             Nw             1           7.4         2.128232
    ## AN1.5.1          0.467             Nw             1          29.8         3.427515
    ## AN1.5.2          0.411             Nw             1           9.6         2.360854
    ## AN1.5.3          0.551             Nw             1          56.0         4.043051
    ## AN1.5.4          0.561             Nw             5          10.4         2.433613
    ## AN1.5.5          0.550             Nw             5           6.6         2.028148

    head(rep_data$each_dataset_means) #access dataframe with means for each level of the categorical variable for each dataset generated by randMult

    ##   Iteration focal_dant focal_group focal_song
    ## 1         1  13.870588           A          N
    ## 2         1   7.158333           B          N
    ## 3         1   7.360000           C          N
    ## 4         1  16.685714           A          Y
    ## 5         1  11.716129           B          Y
    ## 6         1  17.377778           C          Y

    DyadBoot::averages(results$bootstrap_results)

    ## $averages
    ##                            Estimate Std. Error    t value     Pr(>|t|)
    ## (Intercept)               2.3925433  0.2267784 10.5675817 2.896514e-17
    ## focal_groupB             -0.6207503  0.2964067 -2.0976761 5.294068e-02
    ## focal_groupC             -0.8884799  0.3084520 -2.8864462 8.381201e-03
    ## focal_songY               0.1765130  0.3050590  0.5788427 5.745494e-01
    ## focal_groupB:focal_songY  0.1648257  0.3971048  0.4187488 6.496242e-01
    ## focal_groupC:focal_songY  0.9608542  0.4305189  2.2388943 4.178648e-02
    ## 
    ## $standard_errors
    ##                             Estimate   Std. Error    t value     Pr(>|t|)
    ## (Intercept)              0.002751259 0.0002706918 0.01894102 5.294026e-18
    ## focal_groupB             0.003640120 0.0003538029 0.01265139 1.481120e-03
    ## focal_groupC             0.003869548 0.0003681806 0.01349503 3.160685e-04
    ## focal_songY              0.003410669 0.0003641306 0.01120051 6.626099e-03
    ## focal_groupB:focal_songY 0.005052883 0.0004740001 0.01289121 6.768719e-03
    ## focal_groupC:focal_songY 0.005576223 0.0005138845 0.01390195 1.369283e-03

    pvals<-DyadBoot::anovaPvals(results$anova_results, "focal_group:focal_song")
    head(pvals)

    ## [[1]]
    ## [1] 0.0107269
    ## 
    ## [[2]]
    ## [1] 0.1748681
    ## 
    ## [[3]]
    ## [1] 0.08381614
    ## 
    ## [[4]]
    ## [1] 0.005236585
    ## 
    ## [[5]]
    ## [1] 0.06225089
    ## 
    ## [[6]]
    ## [1] 0.04788509

    overall_means <- DyadBoot::MeanOfMeans(rep_data$each_dataset_means, "focal_dant", "focal_group", "focal_song") 
    head(overall_means)

    ##   focal_group focal_song focal_dant
    ## 1           A          N  13.699447
    ## 2           B          N   7.383208
    ## 3           C          N   9.206430
    ## 4           A          Y  16.187676
    ## 5           B          Y  11.086013
    ## 6           C          Y  17.478311

    DyadBoot::histPvals(results$bootstrap_results, coeff_name = "focal_groupC:focal_songY")

![](DyadBoot_vignette_files/figure-markdown_strict/unnamed-chunk-21-1.png)

    plot1<-DyadBoot::plotBoot(rep_data$closest_data, "focal_dant", "focal_group", "focal_song", overall_means = overall_means, 
                              xlab_name = "Genotype Group", ylab_name = "Focal Duration of Antennal Contact (s)", main_title = NULL, p_values = pvals)

    plot1 #to generate plot

![](DyadBoot_vignette_files/figure-markdown_strict/unnamed-chunk-22-1.png)

------------------------------------------------------------------------
