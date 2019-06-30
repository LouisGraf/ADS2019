Applied Data Science
========================================================
author: Reproducible Research with R
date: 18.03.2019
autosize: false
width: 1920
height: 1080
font-family: 'Arial'
css: mySlideTemplate.css


<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 50px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 25px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="320">
</div>
</footer>


Disclaimer
========================================================

* Slides adopted from Detlef Steuer, HSU Hamburg
* http://fawn.hsu-hamburg.de/~steuer/downloads/Kolding/kurs-kolding.pdf

What is Reproducible Research
========================================================
* The roots of RepRes go back to the notion of literate programming by Donald Knuth around 1980.

> "Programs are meant to be read by humans, and only incidentally for computers to execute."

* In principle this is about giving complete analyses to future readers.
* This is made possible by making available
    * all the data,
    * all the steps of analysis,
    * with all the documentation to recipients (reader, editor).
* In an ideal world even 4. the computational environment is part of the analysis!

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>


Why should I practice Reproducible Research?
========================================================
> "Non-reproducible single occurrences are of no significance to science."
> <div style="text-align: right">Karl Popper</div>




* In 2012 a study bei Begley and Ellis was published in Nature, which re-examined a decade of cancer research. They found that 47 of 53 results in those papers could not be reproduced.
* A symposium in the UK found half of all results may be wrong in medicine, psychology and other fields. (Horton, 2015, Lancet)
* There is a real crisis of our beloved scientific method.
* In pharmacology nowadays reproducibilty is key for allowing new pharmacies on the market.
* Practical point of view: You should at least be able to reproduce your results exactly and easily.
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Replicability und Reproducibility: Two different kinds of "doing it again"
========================================================
* Replicability: Repetition of an experiment leads to the same
result (modulo noise)
* Reproducibility: Given data and the documentation a third
party can replay the whole analysis ang get identical results!
* Today: Reproducibility
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>


***
Obstacles for RepRes:
* Time pressure
* Data (and analyses) in Excel sheets
* Point and Klick Interfaces (SPSS)
* Propriatary data formats (STATA, SAS)
* Propriatary file formats for the reports (.docx)
* Missing attractive tool chain to change the workflow in the direction of reproducibility

<footer class = 'logo'>
<div style="position: absolute; right: 0px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Replicability und Reproducibility: Two different kinds of "doing it again"
========================================================
* A workflow, that does not hinder scientific work
* An evironment should be created, that follows all the requirements of RepRes and that results as an output in reports in various output formats like HTML, PDF or docx.
* Very important: the tools must have a very low overhead. It must feel natural to use the tools for the job.

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>


***

Typical steps in quantitative analysis

* Collection data, and preparing data for work
    * Part of this is having a plan how to share the date with partners, especially future partners! (homepage, cloud ...)
    * Being afraid of transparency is bad science!
* Analysis
* Presentation
* Remember: All three steps must be reproducible! If done correctly the last two steps coincide





From Literate Programming to Literate Data Analysis
========================================================
* Literate Programming (1984, Donald Knuth)

> "Let us change our traditional attitude to the construction of programs: Instead of imagining that our main task is to instruct a computer what to do, let us concentrate rather on explaining
to humans what we want the computer to do."

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>


***

* We want to have code and results and analysis in one file.
* All we need is a syntax and the tools, that can extract and evaluate
* source code from this mixed text and source file and insert the results of the computation back into the same or another file.
* When Knuth introduced the idea that kind of execution of the literate program in situ was not prepared.
* Nowadays we have one starting document containing mixed text and sources which is "weaved" if needed into a result document containing the results of the executed sources.
* Some problems arise from pictures and tables.


Some definitions
========================================================
* Code snippets contained in text traditionally are called "chunks".
* Using a special syntax a tool used for weaving learns which parts are
to be interpreted as programs.
* When Knuth first presented his idea the syntax looked as follows:

> surrounding text
> 
> \<\<opt. chunkname >>=
>
> CODE
>
> @
>
> surrounding text

* This is still a possible syntax, even for R, but there more readerfriendly ways.

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; right: 0px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

RStudio - An OS for RepRes
========================================================
* For what we do RStudio in not essential in a sense.
* Everything could be accomplished with plain R and a lot of tools.
* You could do the same with just an R console.
* BUT: RStudio offers a ready made setup to start the work. I.e. pandoc is not so easy
to setup.

* In that sense RStudio solves a huge problem!

Concept | Description
--- | ---
R project | Conveniently organizes files pertaining to specific analytic projects
R Markdown | Allows user to combine prose, code, and metadata into one file to increase reproducibility and reporting capabilities
R Notebook | An R Markdown document that allows for independent and interactive execution of code chunks.

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>


***
Workflow
---
* File -> New R Script
* File -> Compile Notebook
* Perfect format for excercises (rpub.com).
* In this case we have mainly an R program that contains some text, not a text with a bit of code.
* Comments are added in the form of R comments or as roxygen comments in lines starting with \#', which already are interpreted.
* It is possible to add some header info in a specially formated header (YAML).


Rmarkdown
========================================================
* R Markdown allows you to turn your analyses into high quality documents, reports, presentations, and dashboards in various formats (HTML, PDF, LaTex, ePUB, etc.)

* Rmarkdown is a superset of plain Markdown.
* It was developed to have a markup language that was easily readable in source.
* At the same time some markup should be available. (headlines, bold, italic, etc.)
* The source of our report is a Markdown text, which contains chunks written in R.

* pandoc extends the possibilities of pure markdown. I.e. citations are added, which are not part of pure Markdown.

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

***

![Image](figures/markdown.jpg)

Rmarkdown process
========================================================
* The processing chain is text.Rmd -> knitr -> text.md -> pandoc -> html, tex, doc (-> pdflatex -> pdf)

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

![Image](figures/mdprocess.jpg)

Basic structure of rmarkdown document
========================================================

Header
-----

`---`

`title: Reproducible Research`

`subtitle: A workflow mit R / knitr / RStudio`

`author: Someone` 

`date: Somewhere, Sometime`

`output: beamer_presentation`

`toc: true`

`---`

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

***
Some code examples
----

`A Headline!`  
`===========`  

`**bold**`  
`*italic*`

`Some subheadline`  
`----------------`  

  A formula inline in the text `$e^{i\pi} = -1$`.  

A code-chunk:  
` ''' { r chunkname, eval=FALSE}
hist(rnorm(100))
'''
`  

Even some inline calculation ist possible:  
The iris dataframe contains `'r nrow(iris)'` observations.

Cheat Sheet
=====

* Way too many options to know everything - always have a cheat sheet at hand!

https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf

![Image](figures/cheatsheet.jpg)

Markdown Task
=========

1. Turn the line that begins with "Data" into a second level header.
2. Change the words atmos and nasaweather into a monospaced font suitable for code snippets.
3. Make the letter R italicized.
4. Change "2006 ASA Data Expo" to a link that points to http://statcomputing.org/dataexpo/2006
5. Turn the text into a bulleted list with 3 bullets: temp, pressure, ozone.
6. Make temp, pressure, ozone bold at the start of each entry.
7. Make K, mb, and DU italicized at the end of each entry

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

***

Data

The atmos data set resides in the nasaweather package of the R programming language. It contains a collection of atmospheric variables measured between 1995 and 2000 on a grid of 576 coordinates in the western hemisphere. The data set comes from the 2006 ASA Data Expo.

Some of the variables in the atmos data set are:

temp - The mean monthly air temperature near the surface of the Earth (measured in degrees kelvin (K))

pressure - The mean monthly air pressure at the surface of the Earth (measured in millibars (mb))

ozone - The mean monthly abundance of atmospheric ozone (measured in Dobson units (DU))

Chunk Evaluation
========================================================

* Normally chunks are executed one by one in the order they appear in the document, as if they constituted one long R script.
* But: there are tons of otions controlling how and when chunks are executed and how their results are used.
* The following list is not complete! If you miss something you need, read the knitr documentation! It is probably there

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

***
Chunk options will be declared in the curly braces.

Computation Control
* eval = TRUE | FALSE ; codeblock is executed (or not)
* echo = TRUE | FALSE ; source will be containd in final document (or not)
* results = markup | asis | . . . ; kind of syntax used to put results in report
* error: (TRUE; logical) ; does not stop in case of an error in one chunk.
* message = TRUE | FALSE : are messages shown.

* Caching options for expensive calculations. knitr has mechanisms to decide
if a codeblock has changed or not. If nothing has changed, the
parameter `cache` can be used to decide that no re-calculation is
neccessary
