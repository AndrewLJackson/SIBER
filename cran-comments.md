## Update submission

* this is a minor update to address a request to fix an issue on newer OSX builds that cause an error when rendering the unicode permille symbol 'U+2030'. This have been fixed by switching to the text label "permille" when building the graphics objects that require it. 


### Previous NOTES

N/A

## R CMD check results

0 errors | 0 warnings | 0 notes

## Additionaly Test environments

* local OS X 13.6 install, R 4.3.1. Apple clang version 14.0.3 (clang-1403.0.22.14.1)
       GNU Fortran (GCC) 12.2.0 - OK
* win-builder development
    * R devel   - OK
    * R release - OK
* R-hub
     * Debian Linux, R-devel, clang, ISO-8859-15 locale - OK
     * Ubuntu Linux 20.04.1 LTS, R-release, GCC
         * NOTE: checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
         * Maintainer states that this NOTE appears to arise owing to lack of 3rd party software on the server. These same HTML checks pass on other OS installs. 
     * Maintainer states that several other R-hub based OS failed testing owing to lack of available 3rd party installation of jags including Fedora Linux and Windows Server 2022.


## Downstream dependencies

Checked with `revdepcheck`
* Maintainer states: ongoing problems with local gcc installation on Apple M2 chipset prevents this package from running at this time.

