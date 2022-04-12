library(doParallel)
library(parallel)
library(foreach)
library(hector)


run_hector <- function(index, ini_file, scenario, out_dir) {

    # spin up core
    core <- hector::newcore(ini_file)

    # run it
    hector::run(core)

    # fetch results
    results <- hector::fetchvars(core, 2000:2300)

    # write results to CSV
    out_file <- file.path(out_dir, paste0("fake_rcp", scenario, "_", index, ".csv"))
    write.csv(results, out_file, row.names = FALSE)

    # shutdown core
    hector::shutdown(core)

}

# take in arguments from the user / parent script
args = commandArgs(trailingOnly=TRUE)

# batch size for the number of runs to process on a single node
batch_size = 10

# list of RCP numbers to process
rcps <- c("26", "45", "60", "85")

# get rcp from slurm index
scenario <- rcps[[as.integer(args[1])]]

# directory to write the output CSV files to
out_dir <- "/people/pres520/code/example_output_dir"

# generate path for ini file
ini_path <- file.path("input", paste0("hector_rcp", scenario, ".ini"))

# get file path in system
ini_file <- system.file(ini_path, package="hector")

# create a cluster based off of the number of cores
cl <- parallel::makeCluster(detectCores())

# activate the cluster
doParallel::registerDoParallel(cl)

# run hector and produce output file for each iteration in parallel
foreach::foreach(i = 1:batch_size) %dopar% {

    run_hector(i, ini_file, scenario, out_dir)

}

# stop the cluster and free up resources
parallel::stopCluster(cl)

