# This script builds both the HTML and PDF versions of your CV

# If you wanted to speed up rendering for googlesheets driven CVs you could use
# this script to cache a version of the CV_Printer class with data already
# loaded and load the cached version in the .Rmd instead of re-fetching it twice
# for the HTML and PDF rendering. This exercise is left to the reader.

# Knit the HTML version
library(stringr)

render_cv <- function(lang) {
  rmarkdown::render(str_glue("docs/cv_{lang}.rmd"),
                    params = list(pdf_mode = FALSE),
                    output_file = str_glue("cv_{lang}.html"))
  file.copy(str_glue("docs/cv_{lang}.html"), str_glue("docs/index_{lang}.html"), overwrite = TRUE) 
  
  # Knit the PDF version to temporary html location
  tmp_html_cv_loc <- fs::file_temp(ext = ".html")
  rmarkdown::render(str_glue("docs/cv_{lang}.rmd"),
                    params = list(pdf_mode = TRUE),
                    output_file = tmp_html_cv_loc)
  
  # Convert to PDF using Pagedown
  pagedown::chrome_print(input = tmp_html_cv_loc,
                         output = str_glue("docs/cv_{lang}.pdf"))
}

render_cv("en")
render_cv("pt")
