#' repDataSet function
#'
#' This function takes a list of datasets along with names of a numerical variable and one or two categorical variables.
#' It computes the mean of the numerical variable for each level (or combination of levels) of the categorical variable(s)
#' in each dataset. It also identifies the dataset whose mean value(s) are closest to the overall mean value(s) across
#' all datasets.
#'
#' @param resultsMult A list containing multiple datasets.
#' @param num_var The name of the numerical variable as a string.
#' @param cat_var1 The name of the first categorical variable as a string.
#' @param cat_var2 The name of the second categorical variable as a string (optional).
#'
#' @return A list containing two elements:
#' \itemize{
#'   \item each_dataset_means: A data frame containing the iteration number and the mean of the numerical variable for each level (or combination of levels) of the categorical variable(s) in each dataset.
#'   \item closest_dataset: The dataset from the input list that has the mean value(s) closest to the overall mean value(s) across all datasets.
#' }
#'
#' @examples
#' \dontrun{
#' repDataSet(resultsMult, "dant", "Group")
#' repDataSet(resultsMult, "dant", "Group", "Song")
#' }
#'
#' @export
repDataSet <- function(resultsMult, num_var, cat_var1, cat_var2 = NULL) {
  # (Function body goes here)
}

repDataSet <- function(resultsMult, num_var, cat_var1, cat_var2 = NULL) {
  # Compute the means for each level of the categorical variable across all iterations
  all_means_list <- lapply(resultsMult$results_list, function(data) {
    if (!is.null(cat_var2)) {
      aggregate(data[[num_var]], by = list(data[[cat_var1]], data[[cat_var2]]), FUN = mean, na.rm = TRUE)
    } else {
      aggregate(data[[num_var]], by = list(data[[cat_var1]]), FUN = mean, na.rm = TRUE)
    }
  })

  # Construct the all_means data frame
  all_means_df <- data.frame()
  for (i in 1:length(resultsMult$results_list)) {
    iteration_data <- all_means_list[[i]]
    iteration_data$Iteration <- i
    all_means_df <- rbind(all_means_df, iteration_data)
  }

  # Rename the columns to match the input variable names
  if (!is.null(cat_var2)) {
    names(all_means_df)[1:2] <- c(cat_var1, cat_var2)
  } else {
    names(all_means_df)[1] <- cat_var1
  }
  names(all_means_df)[which(names(all_means_df) == "x")] <- num_var

  # Reorder the columns to have "Iteration" as the first column and the numerical variable as the second column
  if (!is.null(cat_var2)) {
    all_means_df <- all_means_df[c("Iteration", num_var, cat_var1, cat_var2)]
  } else {
    all_means_df <- all_means_df[c("Iteration", num_var, cat_var1)]
  }

  # Get the overall means
  overall_means <- do.call(rbind, all_means_list)
  if (!is.null(cat_var2)) {
    overall_means <- aggregate(overall_means$x, by = list(overall_means$Group.1, overall_means$Group.2), FUN = mean, na.rm = TRUE)
  } else {
    overall_means <- aggregate(overall_means$x, by = list(overall_means$Group.1), FUN = mean, na.rm = TRUE)
  }

  # Calculate the absolute difference for each dataset
  diffs <- sapply(resultsMult$results_list, function(data) {
    if (!is.null(cat_var2)) {
      means <- aggregate(data[[num_var]], by = list(data[[cat_var1]], data[[cat_var2]]), FUN = mean, na.rm = TRUE)
    } else {
      means <- aggregate(data[[num_var]], by = list(data[[cat_var1]]), FUN = mean, na.rm = TRUE)
    }
    sum(abs(means$x - overall_means$x), na.rm = TRUE)  # Changed this line to subtract with overall_means
  })

  # Return the dataset that has the minimum cumulative absolute difference
  closest_data <- resultsMult$results_list[[which.min(diffs)]]

  # Return the desired data in a list
  return(list(each_dataset_means = all_means_df, closest_dataset = closest_data))
}
