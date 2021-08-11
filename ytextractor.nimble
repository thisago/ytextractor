# Package

version       = "0.3.2"
author        = "Thiago Navarro"
description   = "Youtube data extractor"
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.2.2"

# Javascript target
requires "ajax >= 0.1.1"

task genDocs, "Generate documentations":
  exec "nim doc --project -d:ssl --out:docs ./src/ytextractor.nim"
