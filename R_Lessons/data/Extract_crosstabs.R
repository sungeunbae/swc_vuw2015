# Read csv file with data from UNdata website
# This will turn columns that contain only numbers into numeric variables,
# anything else will become a string variable and will also be made into factors
#
# It can be useful to have a quick look at the data with a spreadsheet program first,
# if the dataset is not too big - datasets often need to be structured to be understandable
# for the computer, and it is easy to spot problematic spots.
undata <- read.csv("UNdata_Export_20150722_004249658.csv", header = TRUE, nrows = 45556)

# Correct typo
levels(undata$Type.of.household) <- c(levels(undata$Type.of.household), "Two or more family nuclei")
undata$Type.of.household[undata$Type.of.household == "Two or more familiy nuclei"] <- "Two or more family nuclei"
undata$Type.of.household <- droplevels(undata$Type.of.household)

# ---------------------------------------------------------------------------------------

#
# Select latest data for each country
#

# Compute a dataframe with maxima of years for each country and country
Country_Year <- aggregate(undata$Year, by = list(undata$Country.or.Area), FUN = max)

# Reset colum names to the original ones
colnames(Country_Year)[1] <- "Country.or.Area"
colnames(Country_Year)[2] <- "Year"

# Compute inner join of the two data frames, to select latest data for each country
undata <- merge(Country_Year, undata, by = c("Country.or.Area", "Year"))

# Compute a dataframe with maxima of years for each country and country
Country_Year <- aggregate(undata$Source.Year, by = list(undata$Country.or.Area), FUN = max)

# Reset colum names to the original ones
colnames(Country_Year)[1] <- "Country.or.Area"
colnames(Country_Year)[2] <- "Source.Year"

# Compute inner join of the two data frames, to select latest data for each country
undata <- merge(Country_Year, undata, by = c("Country.or.Area", "Source.Year"))

# ---------------------------------------------------------------------------------------

#
# Drop unneeded factors and select columns of interest
#

# Select data for both sexes
undata <- subset(undata, subset = Sex == "Both Sexes", select = c("Country.or.Area", "Age", "Type.of.household", "Value"))

# Drop unneeded levels
undata <- droplevels(undata)

# ---------------------------------------------------------------------------------------

#
# Cross-tabulate data for each country and create list of crosstabs
#

list_of_crosstabs <- NULL
for (country in levels(undata$Country.or.Area))
{
  # Select country and remove age totals (will be recomputed)
  undata_subset <- droplevels(subset(undata, Country.or.Area == country & Age != "Total" & Type.of.household != "Total"))
  
  # Create crosstab and turn into list, then add country name
  crosstab <- list(xtabs(Value ~ Age + Type.of.household, undata_subset))
  names(crosstab) <- country
  
  # Add to list, if there is sufficient data (there is only summary data available for some countries)
  if ( (dim(crosstab[[1]])[1] != 0) & (dim(crosstab[[1]])[2] != 0) )
  {
    list_of_crosstabs <- c(list_of_crosstabs, crosstab)
  }
}

# ---------------------------------------------------------------------------------------

# Function for preparing a crosstable for output (removes unneeded rows and columns,
# cleans up row names and column names)
prep_crosstab <- function(input_tab, remove_rows = NULL, remove_cols = NULL)
{
  # Copy input table
  crtab <- input_tab
  
  # Remove rows if requested, using a given integer vector
  if ( !is.null(remove_rows) )
  {
    crtab <- crtab[-remove_rows,]
  }

  # Remove columns if requested, using a given integer vector
  if ( !is.null(remove_cols) )
  {
    crtab <- crtab[,-remove_cols]
  }
  
  # Check if there is a "100 +" row
  row_100p <- which(rownames(crtab) == "100 +")
  
  # If there is, construct an index sequence with the "100 +" row
  # at the end and reorder crosstab
  if( length(row_100p) == 1 )
  {
    nrows <- nrow(crtab)
    rowidx <- seq(1, nrows)
    rowidx <- c(rowidx[-row_100p], row_100p)
    crtab <- crtab[rowidx,]
  }

  # Add "Age" column filled with row names and move it forward to the
  # first column. Also remove all whitespace from names.
  crtab <- cbind(crtab, gsub(" ", "", rownames(crtab)))
  ncols <- ncol(crtab)
  colnames(crtab)[ncols] <- "Age"
  crtab <- crtab[,c(ncols, seq(1, ncols-1))]
  
  # Replace all whitespace and hyphens in column names with underscores
  colnames(crtab) <- gsub("[ -]", "_", colnames(crtab))
  
  return(crtab)
  }

# ---------------------------------------------------------------------------------------

#
# Store data
#

# NZ
write.csv(prep_crosstab(list_of_crosstabs[["New Zealand"]], NULL, NULL), file="nz_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Brazil
write.csv(prep_crosstab(list_of_crosstabs[["Brazil"]], 2, c(4,5)), file="brazil_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Canada
write.csv(prep_crosstab(list_of_crosstabs[["Canada"]], NULL, c(4,5)), file="canada_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Italy
write.csv(prep_crosstab(list_of_crosstabs[["Italy"]], NULL, c(3,4)), file="italy_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Ghana
write.csv(prep_crosstab(list_of_crosstabs[["Ghana"]], 20, c(4,5)), file="ghana_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Russian Federation
write.csv(prep_crosstab(list_of_crosstabs[["Russian Federation"]], 20, c(4,5)), file="russian_fed_census_crosstab.csv",
          quote = 1, row.names = FALSE)

# Japan
write.csv(prep_crosstab(list_of_crosstabs[["Japan"]], 20, c(3,4)), file="japan_census_crosstab.csv",
          quote = 1, row.names = FALSE)
