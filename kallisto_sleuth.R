library(devtools)
library(sleuth)
library(ggplot2)
library(biomaRt)
library(DESeq2)

# Set the working directory from RStudio(where all the folders of runs are)
setwd("~/.../...")
# Set the working directory
base_dir <- "~/.../.../"

# Where Kallisto result are ( make a folder with the name result, put all the result inside)
sample_id <- dir(file.path(base_dir,"results"))
sample_id

# A list of paths to the kallisto results indexed by the sample IDs
# Get the directories where the kallisto runs live
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "results", id))
kal_dirs

# Fill in metadata about the samples
#AuQuxillary table describes the experimental design and the relationship between the kallisto directories and the samples
s2c <- read.table(file.path(base_dir, "sample_table.csv"), sep = ',', header = TRUE, stringsAsFactors = FALSE)
s2c <- dplyr::select(s2c, sample ='Run_s', 'gender_s', 'age_s', 'tissue_region_s', 'treatment_s')
s2c

# Add file paths to the column (s2c table)
s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)

#
so <- sleuth_prep(s2c, extra_bootstrap_summary = TRUE,read_bootstrap_tpm=TRUE)

so <- sleuth_fit(so, ~treatment_s, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')

models(so)

sleuth_table_ltr <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant_ltr <- dplyr::filter(sleuth_table_ltr, qval <= 0.05)
head(sleuth_significant_ltr, 20)

so <- sleuth_wt(so, 'treatment_sVaccine')
sleuth_table_wt <- sleuth_results(so, 'treatment_sVaccine', test_type = 'wt')
sleuth_significant_wt <- dplyr::filter(sleuth_table_wt, qval <= 0.05)
head(sleuth_significant_wt, 20)

write.csv(sleuth_table_ltr, "/.../table_ltr")
write.csv(sleuth_table_wt, "/.../table_wt")


sleuth_live(so)

#include gene names into transcript-level analysys
mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                         dataset = "hsapiens_gene_ensembl",
                         host = "mar2015.archive.ensembl.org",
                         path = "/biomart/martservice")
ttg <- biomaRt::getBM (attributes = c("ensembl_transcript_id", "transcript_version",
                                      "ensembl_gene_id", "external_gene_name", "description",
                                      "transcript_biotype"), mart = mart)
head(ttg)

ttg <- dplyr::rename(ttg, target_id = ensembl_transcript_id,
                     ens_gene = ensembl_gene_id, ext_gene = external_gene_name)

so <- sleuth_prep(s2c)

so <- sleuth_fit(so, ~treatment_s, 'full')

so <- sleuth_fit(so, ~1, 'reduced')

so <- sleuth_lrt(so, 'reduced', 'full')

sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
head(sleuth_significant, 20)

so <- sleuth_wt(so, 'treatment_sVaccine')

sleuth_table <- sleuth_results(so, 'reduced:full', 'lrt', show_all = FALSE)
sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
head(sleuth_significant, 20)

sleuth_live(so)


so <- sleuth_prep(s2c, ~condition, target_mapping = ttg,
                  aggregation_column = 'ens_gene')

