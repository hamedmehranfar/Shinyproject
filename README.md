---
title: "Shiny project"
output: An interavtive document
---

In this project we are going to explore the use of Rmarkdown and Shiny to make interactive reports.

## Project structure

The structure of the project is as the following:

* Data
  * bridges_coordinates.xlsx
  * Visualization-new.qgz
  * ZolBgg-xmp.xlsx
  * emissions.csv
* apps
  * emission
    * app.R
  * evo
    * app.R
* data_prepration.R
* preload.R
* README.md
* the_interactive_document.Rmd
* ShinyProject.Rproj
* Input_Use_construction.R
* .Rdata
* .gitignore
* test.R


# How to run the document
There are two ways that you can run run the interactice doument: 
 1. Run on your local machine
 2. Use the given link

## Local machine
### Simplest approach
To be able to run the document on your machine, the simplest way is to download the project folder by clicking on the link below:
https://github.com/hamed-93/Shinyproject/archive/refs/heads/main.zip

After extracting the Zip file, you can open the document file **the_interactive_document.Rmd** and run it. In the first time, it might take some time to load (and probably install) all the required packages. 

### Alternative approaches
You can get a clone of the repository in your local machine using [git](https://git-scm.com/) or [GitHub CLI](https://docs.github.com/en/github-cli/github-cli/about-github-cli). For the first approach, you can use the following command:

``
git clone https://github.com/hamed-93/Shinyproject.git
``
For the second approch you might want to take a look at the manual first ([GitHub CLI](https://docs.github.com/en/github-cli/github-cli/about-github-cli)). Then you can use the following command to clone the project:

`
gh repo clone hamed-93/Shinyproject
`

In any case, you will need to open the document file, i.e., (**the_interactive_document.Rmd**) and run it.

The document has been coded in the way that it can take ultimate advantage of your machine's resources, i.e., parallel computing. However, parallel computing feature only works on Linux-based machines for the moment. 
