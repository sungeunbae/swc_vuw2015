#
# Function definition
#

# This function reads all files in directory "data" whose names match
# the first argument "pattern". It creates bar plots of the data in
# column "column", if "column" exists, and inserts the plots into a
# pdf file named "outputfilename".
analyse <- function(pattern, column, outputfilename)
{
  # Start pdf file
  pdf(outputfilename)
  for ( censusfile in list.files(path = "data", pattern = pattern, full.names = TRUE) )
  {
    dat <- read.csv(file = censusfile, header = TRUE, row.names = 1)
    # Check if requested column exists in data frame "dat"
    if ( column %in% colnames(dat) )
    {
      pop_fractions <- dat[,column]/rowSums(dat)
      barplot(pop_fractions, las = 2, main = c(column, censusfile), ylim = c(0.0, 0.7))
    }
  }
  # Close pdf file
  dev.off()
}

#
# Main part of the program starts here
#

# Get command-line arguments, but remove
# the standard arguments from the output
# vector of the "commandArgs" function.
args <- commandArgs(trailingOnly = TRUE)

# Check if all parameters were supplied - if not, issue an
# error message. We expect exactly 3 arguments.
# Note: we could also use "stopifnot" here, but it is helpful
# for users to provide additional usage information.
if ( length(args) == 3)
{
  # Extract the information from args
  file_name_pattern <- args[1]
  column_name <- args[2]
  pdf_file_name <- args[3]
  # Run the "analyse" function
  analyse(file_name_pattern, column_name, pdf_file_name)
} else {
  # There were too few or too many arguments. Create an
  # error message and provide usage information.
  print("analyse_census.R: Too few or too many arguments.")
  print("Usage:")
  print("analyse_census.R pattern column output_file")
  print("")
}
