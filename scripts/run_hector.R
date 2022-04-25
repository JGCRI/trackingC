# title title
# library(dplyr)

SLURM_ARRAY_JOB_ID <- Sys.getenv("SLURM_ARRAY_JOB_ID")
SLURM_ARRAY_TASK_ID <- Sys.getenv("SLURM_ARRAY_TASK_ID")
SLURM_ARRAY_TASK_COUNT <- Sys.getenv("SLURM_ARRAY_TASK_COUNT")


fn <- paste0("out_", SLURM_ARRAY_JOB_ID, "_", 
             SLURM_ARRAY_TASK_ID, "_", 
             SLURM_ARRAY_TASK_COUNT, ".csv")

write.csv(cars, "filename.csv")






# # Set directory, read in files
# BASE_DIR <- here::here()
# path = paste0(BASE_DIR, "/output")
# 
# files <- list.files(path = path, pattern = "*.csv", full.names = TRUE)
# runlist <- read.csv(files) %>% select(-X)
# 
# # Define function
# run_hector <- function(pdata, c) {
#   # Function to set multiple parameter values for Hector, run a core, and retrieve tracking data
#   # pdata will be the runlist specified above and c is a newcore environment
#   # For each parameter within each run, set its value and units
#   for(p in colnames(pdata)) {
#     message("\tSetting ", p)
#     setvar(c, NA, do.call(p, list()), pdata[p][[1]], units_vector[p])
#   }
#   # Set a tracking data, reset and run core
#   setvar(c, NA, TRACKING_DATE(), 1950, NA)
#   reset(c)
#   run(c)
#   # Access and save tracking data
#   tdata <- get_tracking_data(c)
#   tdata %>% filter(year %in% c(2000:2200))
# }
# 
# # Run function for each row of the runlist
# # Create destination list
# out <- list()
# 
# # List for the rows that error
# errors <- list()
# 
# # For each row of the runlist, apply the run_hector() function
# # If there is an error, record which row triggers the error, and skip to the next row
# 
# for(row in seq_len(nrow(runlist))) {
#   message(row, "/", nrow(runlist))
#   outp <- try(run_hector(runlist[row,][-1], core))
#   if(class(outp) == "try-error") { 
#     # if there is an error, record row numbers that error
#     errors[[row]] <- runlist$run_number[[row]]
#   } else {
#     out[[runlist$run_number[row]]] <- outp
#   }}  
# 
