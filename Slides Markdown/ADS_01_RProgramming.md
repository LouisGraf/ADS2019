Applied Data Science
========================================================
author: Statistical Programming with R
date: 18.03.2019
autosize: false
width: 1280
height: 720
font-family: 'Rockwell'
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

R Syntax
========================================================
* Lightweight, script-oriented syntax
* No line ends (e.g., “;” in JAVA)
* Common mathematical operators are used:
* Whitespace typically without meaning
* Round brackets: Function arguments, e.g., `mean(x)`
* Square brackets: Array locations, e.g., `playerList[1]`
* Curly brackets: Code blocks (e.g., around loops or logical structures)
* Values are assigned using `<-` or `=`
* Comments initalized by `#`

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>





Package Management
========================================================
* Packages are collections of R functions, data, and compiled code
* Numerous packages are available for download and installation
* Installing and loading is done via the GUI or the console (script)
* Example for installing and loading the `tidyverse` package
    * With root privileges
        * `install.packages(“tidyverse")`
        * `library(tidyverse)`
    * Without root privileges
        * `install.packages("tidyverse", lib="/data/Rpackages/")`
        * `library(tidyverse, lib.loc="/data/Rpackages/")`
        
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>


R Objects and Data Types
========================================================
* Everything in R is an object
* No strict but dynamic typing
* Basic data types available in R:
    * Numeric: decimal numbers `2.3`
    * Integer: integer numbers `2`
    * Logical: true / false values `TRUE`
    * Character: single or multiple characters `"TWO"`
    * (Ordered) Factor: discrete values from a pre-defined scale `"good", "medium", "bad"`

<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Vectors
========================================================
* A vector is a sequence of data elements of the same basic type
    * Members of a vector are called components
    * Vectors are initialized using the `c()` command
    

```r
numericVector <- c(1.2, 1.3, 1.4)
```

* The number of members in a vector is given by the length function:

```r
length(numericVector)
```

```
[1] 3
```

Some vector creation helpers: Sequences
========================================================
The `seq` function has three arguments:
* `from`: starting point
* `to`: end point
* `by`: increment

```r
seq(10, 100, by=10)
```

```
 [1]  10  20  30  40  50  60  70  80  90 100
```
The colon operator `1:10` is a shorthand for `by=1`



<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Some vector creation helpers: Repetitions / Replications
========================================================
The `rep` function has two arguments:
* `x`: object to be replicated
* `times`: how often


```r
rep(10, 10) 
```

```
 [1] 10 10 10 10 10 10 10 10 10 10
```
Note: The first argument can be again a vector (e.g., sequences)



<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Vector Recycling
========================================================
* If a vector is of insufficient length for an operation, R will recycle previous values
* If longer length is not a mutltiple it will raise a warning



```r
x = c(10,11,12,13)
x + c(0,1)
```

```
[1] 10 12 12 14
```

```r
x + c(0,1,2)
```

```
Warning in x + c(0, 1, 2): Länge des längeren Objektes
 	 ist kein Vielfaches der Länge des kürzeren Objektes
```

```
[1] 10 12 14 13
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Subsetting Vectors
========================================================
* Vector subsetting is done via the `[]` operator
* Positive integers return elements at the specified positions (whitelisting), identical indexes will yield duplicates

```r
x=LETTERS
x[1:3]
```

```
[1] "A" "B" "C"
```

```r
x[c(1,1)]
```

```
[1] "A" "A"
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Subsetting Vectors (2)
========================================================
* Negative integers suppress elements at the specified positions (blacklisting)
You cannot mix positive and negative integers in subsetting!


```r
x[-seq(1,26,2)]
```

```
 [1] "B" "D" "F" "H" "J" "L" "N" "P" "R" "T" "V" "X" "Z"
```

* Logical vectors will return all positions where the vector is TRUE, This is clearly the most useful approach if we master logical expressions

```r
x[x<"D"]
```

```
[1] "A" "B" "C"
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Sorting Vectors
========================================================

```r
x = c(4, 3, 6, 2, 1, 10, 5, 8, 9, 7)
sort(x)
```

```
 [1]  1  2  3  4  5  6  7  8  9 10
```

```r
sort(x, decreasing = T)
```

```
 [1] 10  9  8  7  6  5  4  3  2  1
```

```r
order(x)
```

```
 [1]  5  4  2  1  7  3 10  8  9  6
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Sampling from Vectors
========================================================

```r
sample(1:6, 5) #sample from a vector (no replacement)
```

```
[1] 4 6 2 5 3
```

```r
sample(1:6, 5, replace = T) #sample from a vector (replacement)
```

```
[1] 6 5 5 5 6
```



<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>



Matrices
========================================================
* A matrix is a collection of data elements arranged in a two-dimensional rectangular layout
* Matrices are created in R with the matrix function


```r
A = matrix(c(2,4,3,1,5,7), nrow=2, ncol=3, byrow = TRUE)
A
```

```
     [,1] [,2] [,3]
[1,]    2    4    3
[2,]    1    5    7
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

NA Values
========================================================
* Oftentimes we will have missing or corrupt data
* These will often pop up as NA entries
* Running analyses on these values can cause problems

```r
set.seed(1)
v = sample(c(NA,1,2,3),8,replace = T)
mean(v)
```

```
[1] NA
```
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

NA Handling
========================================================
* Identify and remove NA values

```r
is.na(v)
```

```
[1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
```

```r
mean(v[!is.na(v)])
```

```
[1] 2.142857
```
***

* Replace NA values

```r
v.na.replaced <- v
v.na.replaced[is.na(v)] <- 0
mean(v.na.replaced)
```

```
[1] 1.875
```


<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Logical Expressions
========================================================
* A AND B: `A & B`
* A OR B: `A | B`
* IF-THEN-ELSE: `ifelse(v>=0, "+", "-")`

***

* Conditions may include the following:
    * `==` equal
    * `!=` not equal to
    * `> (>=)` greater (or equal) than
    * `< (<=)` less (or equal) than
    * `%in%` left element in vector on right


<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Standard statistical expressions
========================================================

```r
v = sample(1:6, 5, T)
mean(v)
```

```
[1] 2.8
```

```r
max(v)
```

```
[1] 5
```

```r
min(v)
```

```
[1] 1
```

***

```r
length(v)
```

```
[1] 5
```

```r
length(v[v>3])
```

```
[1] 2
```

```r
quantile(v)
```

```
  0%  25%  50%  75% 100% 
   1    2    2    4    5 
```



<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Extracting Information from Objects
========================================================

```r
str(v) #structure
```

```
 int [1:5] 4 1 2 2 5
```

```r
summary(v) #summary
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    1.0     2.0     2.0     2.8     4.0     5.0 
```

```r
class(v) #class
```

```
[1] "integer"
```

***


```r
length(v) #number of elements
```

```
[1] 5
```

```r
dim(v) #dimensionality
```

```
NULL
```

```r
unique(v) #unique value
```

```
[1] 4 1 2 5
```



<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

Character vector manipulation
========================================================
* The command `paste` creates a single string from the argument vectors’ character representations, sep specifies the separator

```r
paste(LETTERS[1:8], 1:4, sep="!") 
```

```
[1] "A!1" "B!2" "C!3" "D!4" "E!1" "F!2" "G!3" "H!4"
```
***
* `paste0` offers a shortcut

```r
paste(rep("A", 5), 1:4, sep="")
```

```
[1] "A1" "A2" "A3" "A4" "A1"
```

```r
paste0(rep("A", 5), 1:4)
```

```
[1] "A1" "A2" "A3" "A4" "A1"
```




<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>




String operations (1)
========================================================

* Extracting substrings

```r
substr("ABCDEFG",
       start=2, stop=3)
```

```
[1] "BC"
```

* Constructing compound strings with `sprintf()`

```r
sprintf("%s is %f feet tall", "Sven", 7.1)
```

```
[1] "Sven is 7.100000 feet tall"
```

***

* Splitting string on characters

```r
x <- "Split words."
strsplit(x, " ") # Result is a list – use unlist as needed
```

```
[[1]]
[1] "Split"  "words."
```

* String length

```r
nchar("ABC")
```

```
[1] 3
```


</style>
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>


String operations (2)
========================================================

* Check if string `x` contains expression `pattern`

```r
grepl(pattern = "aus",
      x = "Nikolaus")
```

```
[1] TRUE
```

```r
grepl(pattern = "haus",
      x = "Nikolaus")
```

```
[1] FALSE
```
***

* Replacement

```r
gsub(pattern = "aus",
     replacement = "aushaus",
     x = "Nikolaus")
```

```
[1] "Nikolaushaus"
```

</style>
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>

lubridate – temporal data made easy
========================================================


* Parsing time strings

```r
a = ymd("20110720")
c = dmy("31/08/2011")
arrive <- ymd_hms("2011-06-04 12:00:00")
leave <- ymd_hms("2011-08-10 14:00:00")
```

* Extracting time details

```r
wday(arrive) #also second / hour ...
```

```
[1] 7
```

***

```r
wday(arrive, label = TRUE)
```

```
[1] Sa
Levels: So < Mo < Di < Mi < Do < Fr < Sa
```

* Time intervals

```r
A <- interval(arrive, leave)
B <- interval(a, c)
int_overlaps(A,B)
```

```
[1] TRUE
```



</style>
<footer class = 'footnote'>
<div style="position: absolute; left: 0px; bottom: 0px; z-index:100; background-color:white">
Prof. Dr. Christoph Flath | ADS 2019</div>
</footer>
<footer class = 'logo'>
<div style="position: absolute; left: 1100px; bottom: 0px; z-index:100; background-color:white">
<img src = "uni-wuerzburg-logo.svg" width="160">
</div>
</footer>
