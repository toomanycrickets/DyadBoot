#' Replicate Dataset with Up to Three Categorical Variables
#'
#' This function computes the means for each level of provided categorical
#' variables across all iterations of a list of datasets. It then identifies the dataset
#' whose group means are most representative in relation to the overall means.
#'
#' @param resultsMult A list containing multiple datasets. Specifically, it expects a named element `$results_list`
#'        which is the list of datasets.
#' @param num_var The name of the numerical variable for which the mean should be computed.
#' @param cat_var1 The name of the primary categorical variable.
#' @param cat_var2 The name of the secondary categorical variable (default is NULL, i.e., not provided).
#' @param cat_var3 The name of the tertiary categorical variable (default is NULL, i.e., not provided).
#'
#' @return A list containing two elements:
#'   \itemize{
#'     \item \code{each_dataset_means}: A data frame with the mean of the numerical variable
#'           for each combination of the categorical variables for each dataset.
#'     \item \code{closest_dataset}: The dataset from \code{resultsMult$results_list} that
#'           is most representative in relation to the overall means.
#'   }
#'
#' @examples
#' \dontrun{
#'   # Assuming you have a list `results` with multiple datasets
#'   output <- repDataSet(results, "numericalVar", "catVar1", "catVar2", "catVar3")
#'   print(output$each_dataset_means)
#'   print(head(output$closest_dataset))
#' }
#'
#' @export
repDataSet <- function(resultsMult, num_var, cat_var1, cat_var2 = NULL, cat_var3 = NULL) {
  ...
}

repDataSet <- function(resultsMult, num_var, cat_var1, cat_var2 = NULL, cat_var3 = NULL) {
  # Compute the means for each level of the categorical variable(s) across all iterations
  all_means_list <- lapply(resultsMult$results_list, function(data) {
    if (!is.null(cat_var3)) {
      aggregate(data[[num_var]], by = list(data[[cat_var1]], data[[cat_var2]], data[[cat_var3]]), FUN = mean, na.rm = TRUE)
    } else if (!is.null(cat_var2)) {
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
  if (!is.null(cat_var3)) {
    names(all_means_df)[1:3] <- c(cat_var1, cat_var2, cat_var3)
  } else if (!is.null(cat_var2)) {
    names(all_means_df)[1:2] <- c(cat_var1, cat_var2)
  } else {
    names(all_means_df)[1] <- cat_var1
  }
  names(all_means_df)[which(names(all_means_df) == "x")] <- num_var

  # Reorder the columns
  if (!is.null(cat_var3)) {
    all_means_df <- all_means_df[c("Iteration", num_var, cat_var1, cat_var2, cat_var3)]
  } else if (!is.null(cat_var2)) {
    all_means_df <- all_means_df[c("Iteration", num_var, cat_var1, cat_var2)]
  } else {
    all_means_df <- all_means_df[c("Iteration", num_var, cat_var1)]
  }

  # Get the overall means
  overall_means <- do.call(rbind, all_means_list)
  if (!is.null(cat_var3)) {
    overall_means <- aggregate(overall_means$x, by = list(overall_means$Group.1, overall_means$Group.2, overall_means$Group.3), FUN = mean, na.rm = TRUE)
  } else if (!is.null(cat_var2)) {
    overall_means <- aggregate(overall_means$x, by = list(overall_means$Group.1, overall_means$Group.2), FUN = mean, na.rm = TRUE)
  } else {
    overall_means <- aggregate(overall_means$x, by = list(overall_means$Group.1), FUN = mean, na.rm = TRUE)
  }

  # Calculate the absolute difference for each dataset
  diffs <- sapply(resultsMult$results_list, function(data) {
    # Calculate means based on the categorical variables provided
    if (!is.null(cat_var3)) {
      means <- aggregate(data[[num_var]], by = list(data[[cat_var1]], data[[cat_var2]], data[[cat_var3]]), FUN = mean, na.rm = TRUE)
    } else if (!is.null(cat_var2)) {
      means <- aggregate(data[[num_var]], by = list(data[[cat_var1]], data[[cat_var2]]), FUN = mean, na.rm = TRUE)
    } else {
      means <- aggregate(data[[num_var]], by = list(data[[cat_var1]]), FUN = mean, na.rm = TRUE)
    }

    # Merge means with overall_means based on categorical variables
    if (!is.null(cat_var3)) {
      merged_data <- merge(means, overall_means, by = c("Group.1", "Group.2", "Group.3"), all.x = TRUE)
    } else if (!is.null(cat_var2)) {
      merged_data <- merge(means, overall_means, by = c("Group.1", "Group.2"), all.x = TRUE)
    } else {
      merged_data <- merge(means, overall_means, by = "Group.1", all.x = TRUE)
    }

    # Calculate the absolute differences
    abs_diffs <- abs(merged_data$x.x - merged_data$x.y)

    # Return the cumulative absolute difference
    sum(abs_diffs, na.rm = TRUE)
  })


  # Return the dataset that has the minimum cumulative absolute difference
  closest_data <- resultsMult$results_list[[which.min(diffs)]]

  # Return the desired data in a list
  return(list(each_dataset_means = all_means_df, closest_dataset = closest_data))
}
