## Update submission

* this is a minor update to address a request to fix an issue on newer OSX builds that cause an error when rendering the unicode permille symbol 'U+2030'. This have been fixed by switching to the text label "permille" when building the graphics objects that require it. 


### Previous NOTES

*  Found the following URLs which should use \doi (with the DOI name only):
     File 'mongoose.Rd':
       https://doi.org/10.1111/ele.12933 - FIXED 

## R CMD check --as-cran results

0 errors | 0 warnings | 0 notes

## Additional Test environments

* local OS X 13.6 install, R 4.3.1. Apple clang version 14.0.3 (clang-1403.0.22.14.1)
       GNU Fortran (GCC) 12.2.0 - OK
* OSX via `devtools::check_mac_release()`
    * r-release-macosx-arm64|4.3.0|macosx|macOS 13.3.1 (22E261)|Mac mini|Apple M1||en_US.UTF-8|macOS 11.3|clang-1403.0.22.14.1|GNU Fortran (GCC) 12.2.0 - OK
* win-builder
    * R devel - Windows Server 2022 x64 (build 20348) - OK
    * R release - OK
* R-hub
     * Debian Linux, R-devel, clang, ISO-8859-15 locale - OK
     * Ubuntu Linux 20.04.1 LTS, R-release, GCC
         * NOTE: checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
         * Maintainer states that this NOTE appears to arise owing to lack of 3rd party software on the server. These same HTML checks pass on other OS installs. 
     * Maintainer states that several other R-hub based OS failed testing at vignette building stage owing to lack of available 3rd party installation of JAGS including Fedora Linux and Windows Server 2022.


## Downstream dependencies

Checked with `revdepcheck`
* Maintainer states: ongoing problems with local gcc installation on Apple M2 chipset prevents this package from running at this time.

