June 2024, Rostock

*If you encounter any problems, please reach out to [me](mailto::schubert@demogr.mpg.de)!*

![](map_col_birth_squeeze.png)

# Colombian Vital Statistics Data
This repository contains the code to unpack, clean, and combine the Colombian register data for the period between 2000 and 2020.


# Code-pipeline
You should be able to reproduce the results by running the [Meta-File](META.R) file in the main directory. If you need to install packages, read the section 'Packages' below

# Packages
If you want to install the packages on a go, just change the variable `install` in the [Meta-File](META.R) to `TRUE`, and you should be able to run the scripts.

```
# Do you want to install packages? yes=TRUE, no=FALSE
install <- FALSE

# Install.packages
packages <- c("data.table", "tidyverse", "haven", "xlsx", "sf")
if(install) {
  install.packages(packages)
}
```

-   [`tidyverse`](https://cran.r-project.org/web/packages/tidyverse/index.html) by Hadley Wickham
-   [`data.table`](https://cran.r-project.org/web/packages/data.table/index.html) by Matt Dowle et al.
- xlsx
- sf
- haven

