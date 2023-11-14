# AF-RCPP-2023-2024

This repository contains materials to the "Applied Finance" course at the University of Warsaw, Faculty of Economic Sciences in academic year 2023/2024. Materials refer to the part "Path dependent option pricing with Monte Carlo simulations and Rcpp package".

The aim of this short course is to provide techniques of incorporating `c++` code into `R` environment. Three techniques will be discussed:

* `cppFunction()` function - for short inline `c++` code chunks
* `sourceCpp()` function - for longer `c++` code chunks located in separate `*.cpp` files
* `Rcpp` package - for a project that consist of 2 or more files 

The `Rcpp` package will be used to provide function defined in `c++` which will be responsible for providing valuations of path-dependent option of European style using the Monte Carlo simulation technique.

To earn credits for this part of the curse, students will have to provide solutions to their individual home projects which will concentrate on valuation of a specific path-dependent option.

## Schedule

### Lecture #1

Slides with:

* introduction to options, 
* option payoff profiles, 
* factors which influence option price
* Black-Scholes-Merton (BSM) pricing formula for European options
* elements of Monte Carlo simulations for valuation of path-depending options

To create `slides/slides.pdf` open `slides/slides.Rmd` and run **knit to PDF (Beamer)** by pressing `Ctrl+K`.

### Labs #1

We will use the script `scripts/intro2Rcpp.R`. Following elements will be discussed:

* introduction to the `Rcpp` package
* "importing" `c++` code to `R` using two functions: `cppFunction()` and `sourceCpp()` * simple implementations in `R` of functions defined in `c++` code.

### Lecture #2

The aim is to compare of efficiency of Monte Carlo European Call option pricing techniques. The script `scripts/pricingComparison.R` will be used. We will compare following techniques:

* using loops in R
* using vectors in R
* using loops in C++, via Rcpp
* using vectors in R with antithetic sampling

We also introduce a simple `c++` application which runs in Command Line (Windows) or terminal (Linux/MacOS). To compile its source code into executable file you can use one of the popular IDEs ([Microsoft Visual Studio](https://visualstudio.microsoft.com/), [CLion](https://www.jetbrains.com/clion/), [Code Blocks](http://www.codeblocks.org/)), code editors ([VS Code](https://code.visualstudio.com/), [Xcode](https://developer.apple.com/xcode/), [Sublime Text](https://www.sublimetext.com/), [Vim](https://www.vim.org/), and many others) or even simple text editors (just to mention [Notepad++](https://notepad-plus-plus.org/) on Windows).

I highly recommend here trying [VS Code](https://code.visualstudio.com/) for this. Below you will useful information how to set up VS Code for work with c++ code using the GCC compiler. Its very simple and shouldn't take your more than 5 minutes!

- getting started with C/C++ for Visual Studio Code: https://code.visualstudio.com/docs/languages/cpp
* using GCC on Linux: https://code.visualstudio.com/docs/cpp/config-linux
* using GCC with MinGW on Windows: https://code.visualstudio.com/docs/cpp/config-mingw
* Please change the `"${file}"` element of the `tasks.json` file into `"${fileDirname}/*.cpp"` (under Linux/MacOS) or `"${fileDirname}\\**.cpp"` (under Windows). This will allow to build projects which consist of more then one `*.cpp` file.

### Labs #2

The task is to build the `optionPricer2` package on the basis of code of the `programs/prog2` application. Once we do this, we will then use function/functions of this package in the little playground provided inside the script `scripts/optionPricer2Application.R`.

### Creating an R package 

Below you will find steps to create an Rcpp package named `optionPricer2`, where code from `progs/prog2` is used.

1. In RStudio: 

* `File` -> `New Project` -> `New Directory` -> `R Package` -> 
* Type: package `w/ Rcpp`
* Package name: `optionPricer2` 
* give appropriate path

2. Copy your source files (`*.cpp`) and header files (`*.h`) from `progs/prog2` to `projects/optionsPricer2/src/` folder.

Although you may safely delete `RcppExports.cpp` and `rcpp_hello.cpp`, I would recommend to keep them, as they may serve in the next steps as hints in terms of syntax.

3. Include necessary changes `projects/optionsPricer2/src/main.cpp`:

* add before definition of your function: `using namespace Rcpp;`
* add before definition of your function: `#include <Rcpp.h>`
* add directly before definition of your function: `// [[Rcpp::export]]`
* change the name of the `main()` function and type of returned value according to your needs
* include necessary arguments for this function
* double check the returned object at the end of the function

Repeat these actions for any other function you would like to include in the package.

4. Fill free to edit DESCRIPTION file. However be careful! You must not change names of fields or change the inner structure of the file.

5. Build your package: either source package or binary package, or both of them:

* `menu Build` -> `Build Source Package`
* `menu Build` -> `Build Binary Package`

This will create `zip` and/or `tar.gz` files with your package. By default, they will be located next to the folder with the package.

6. This archive file (`*.zip` or `*.tar.gz`) could be then installed with:

* `install.packages("binary-package-filename.zip", type = "binaries", repos = NULL)`
* `install.packages("source-package-filename.tar.gz", type = "source", repos = NULL)`

See `scripts/optionPricer2Application.R` to examine the example.



## Grading Policy

* Each participant will get by 2023-12-10 an assignment with an individual home project.
* The aim of the project will be to apply Monte Carlo techniques to provide an approximation of the path-dependent option.
* The solution should be delivered in a form of a Rcpp-package, along with a short implementation of the function/functions which are provided by this package.
* All codes from the lectures and labs can be used in the solutions.
* A short report will be required.
* Solutions in a form of a private Github/GitLab/Bitbucket repository will get premium points!

## Happy learning! :-)

* If you need any sort of help, feel free to message me. 
* Do not be afraid to ask question! Asking question is super important to your growth!
* No question is a stupid question!
* I'm available on p.sakowski@uw.edu.pl
