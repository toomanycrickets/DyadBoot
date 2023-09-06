#' Randomly Assign Roles within Dyads
#'
#' This function takes a dataset and randomly assigns roles within dyads, returning
#' a dataset where each dyad has a 'focal' and an 'opposite' member.
#'
#' @param data A dataframe containing the data to be processed.
#' @param dyad_id_col A character string specifying the name of the column that contains dyad identifiers.
#' @param max_iterations An integer specifying the maximum number of times the function can be called. Defaults to 10,000.
#'
#' @return A dataframe with the original columns prefixed by 'focal_' or 'opposite_' depending on the role assigned.
#' Columns from the same row in the original dataframe will be in separate rows in the output,
#' with their roles indicated by the prefix.
#'
#' @examples
#' \dontrun{
#' dyad_data <- data.frame(dyad_id = c(1,1,2,2), var1 = c("A", "B", "C", "D"))
#' new_data <- randOne(dyad_data, dyad_id_col = "dyad_id")
#' }
#'
#' @export
randOne <- function(data, dyad_id_col, max_iterations = 10000) {
  # ... [the rest of the function code goes here]
}



randOne <- function(data, dyad_id_col, max_iterations = 10000) {
  # Use a counter to track the number of function calls
  if (!exists(".dyad_rand_counter")) {
    .dyad_rand_counter <<- 0
  }

  .dyad_rand_counter <<- .dyad_rand_counter + 1

  if (.dyad_rand_counter > max_iterations) {
    stop("Maximum number of allowed iterations reached!")
  }

  # Split data by dyad
  dyad_groups <- split(data, data[[dyad_id_col]])

  # Function to create focal and opposite data
  create_focal_opposite_data <- function(dyad_groups) {
    focal_opposite_data_list <- lapply(dyad_groups, function(dyad) {
      # Shuffle dyad members to randomly assign roles
      shuffled_dyad <- dyad[sample(1:2), ]

      # Create a new data frame with 'focal' and 'opposite' columns
      focal_data <- shuffled_dyad[1, , drop = FALSE]
      colnames(focal_data) <- paste0("focal_", colnames(focal_data))

      opposite_data <- shuffled_dyad[2, , drop = FALSE]
      colnames(opposite_data) <- paste0("opposite_", colnames(opposite_data))

      # Combine the data into a single row
      combined_data <- cbind(focal_data, opposite_data)
      return(combined_data)
    })

    # Combine all dyads back into a single data frame
    focal_opposite_data <- do.call(rbind, focal_opposite_data_list)
    return(focal_opposite_data)
  }

  # Call the function to create the data
  focal_opposite_data <- create_focal_opposite_data(dyad_groups)

  return(focal_opposite_data)
}
