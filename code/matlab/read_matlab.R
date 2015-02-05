pathname <- file.path("/Users/alejandroguizar/Google Drive/carbon_stocks_sussex_proj/Structure_reference", "Inputs.mat")

# from apollo
# pathname <- file.path("r_wd/RDF", "Structure/Inputs.mat")

pathname <- file.path("RDF/FIAstrat", "LCC_HF.mat")

library(R.matlab)
data <- readMat(pathname)
str(data)