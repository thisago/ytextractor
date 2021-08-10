# Package

version       = "0.3.0"
author        = "Thiago Navarro"
description   = "Youtube data extractor"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.2.2"

# Javascript target
requires "ajax >= 0.1.1"

task genDocs, "Generate documentations":
  exec "nim doc --project --out:docs ./src/ytextractor.nim"
