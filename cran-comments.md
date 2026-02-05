## Update submission

* this is a minor update to replace `dplyr::group_by_()` with `dplyr::group_by()` in `SIBER::siberKapow()` per advice from `dplyr` package maintainers. 
* 


### Previous NOTES

* build attempted at CRAN returned an error in vignette `kapow-example.Rmd` arising from the call to `purrr::map()` ! The `.dots` argument of `group_by()` was deprecated in dplyr 1.0.0 and is now defunct.
* this error has now been fixed using the advise syntax `x |> map(\(x) f(x, 1, 2, collapse = ","))`

## R CMD check --as-cran results

local OS X 26.2 install, R 4.5.2. Apple clang version 17.0.0 (clang-1700.0.13.3) GNU Fortran (Homebrew GCC 15.2.0) 15.2.0
       
called by `devtools::check(remote = TRUE, manual = TRUE)`

0 errors | 0 warnings | 0 notes

## Additional Test environments

* OSX via `devtools::check_mac_release()`
    * r-release-macosx-arm64|4.3.0|macosx|macOS 13.3.1 (22E261)|Mac mini|Apple M1||en_US.UTF-8|macOS 11.3|clang-1403.0.22.14.1|GNU Fortran (GCC) 12.2.0 - OK
* win-builder
    * R devel - Windows Server 2022 x64 (build 20348) - x86_64-w64-mingw32 - OK
    * R release - Windows Server 2022 x64 (build 20348) - x86_64-w64-mingw32 - OK


## Downstream dependencies

### revdepcheck results

We checked 5 reverse dependencies (0 from CRAN + 5 from Bioconductor), comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages

